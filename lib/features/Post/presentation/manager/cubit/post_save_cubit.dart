import 'package:archilink/features/Post/domain/repo/post_repo.dart';
import 'package:archilink/features/settings/domain/repo/setting_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'post_save_state.dart';

class PostSaveCubit extends Cubit<PostSaveState> {
  final PostRepo postRepo;
  final SettingRepo settingRepo;
  final Set<int> savedPostIds = {};

  int? _cachedDefaultCollectionId;
  String? _cachedDefaultCollectionTitle;

  PostSaveCubit({
    required this.postRepo,
    required this.settingRepo,
  }) : super(const PostSaveInitial());

  bool isPostSaved(int postId) => savedPostIds.contains(postId);

  void setDefaultCollection({required int id, required String title}) {
    _cachedDefaultCollectionId = id;
    _cachedDefaultCollectionTitle = title;
  }

  Future<void> savePost({
    required int postId,
    int? collectionId,
    String? collectionTitle,
  }) async {
    emit(PostSaveLoading(postId: postId));

    int targetCollectionId;
    String targetCollectionTitle = collectionTitle ?? '';

    if (collectionId != null) {
      targetCollectionId = collectionId;
    } else {
      // User skipped choosing a specific collection (e.g. tapped outside bottom sheet).
      // The manager resolves and uses the default collection ID.
      if (_cachedDefaultCollectionId != null) {
        targetCollectionId = _cachedDefaultCollectionId!;
        targetCollectionTitle = _cachedDefaultCollectionTitle ?? 'Default';
      } else {
        final collectionsResult = await settingRepo.getCollections();

        final defaultCollection = collectionsResult.fold(
          (failure) => null,
          (collections) {
            try {
              return collections.firstWhere((c) => c.isDefault);
            } catch (_) {
              return collections.isNotEmpty ? collections.first : null;
            }
          },
        );

        if (defaultCollection == null) {
          emit(
            PostSaveFailure(
              postId: postId,
              message: 'Default collection could not be found',
            ),
          );
          return;
        }

        _cachedDefaultCollectionId = defaultCollection.id;
        _cachedDefaultCollectionTitle = defaultCollection.title;
        targetCollectionId = defaultCollection.id;
        targetCollectionTitle = defaultCollection.title;
      }
    }

    final result = await postRepo.savePost(
      postId: postId,
      collectionId: targetCollectionId,
    );

    result.fold(
      (failure) {
        emit(
          PostSaveFailure(
            postId: postId,
            message: failure.message,
          ),
        );
      },
      (success) {
        savedPostIds.add(postId);
        emit(
          PostSaveSuccess(
            postId: postId,
            collectionId: targetCollectionId,
            collectionTitle: targetCollectionTitle,
            message: targetCollectionTitle.isNotEmpty
                ? 'Saved to $targetCollectionTitle'
                : 'Post saved successfully',
          ),
        );
      },
    );
  }
}
