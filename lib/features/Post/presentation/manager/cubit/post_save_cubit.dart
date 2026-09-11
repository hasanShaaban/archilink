import 'package:archilink/features/Post/domain/repo/post_repo.dart';
import 'package:archilink/features/settings/domain/entity/user_collection_entity.dart';
import 'package:archilink/features/settings/domain/repo/setting_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'post_save_state.dart';

class PostSaveCubit extends Cubit<PostSaveState> {
  final PostRepo postRepo;
  final SettingRepo settingRepo;
  final Set<int> savedPostIds = {};
  final Map<int, int> _savedPostCollectionIds = {};
  final Map<int, int> _savedPostItemIds = {};

  int? _cachedDefaultCollectionId;
  String? _cachedDefaultCollectionTitle;

  PostSaveCubit({
    required this.postRepo,
    required this.settingRepo,
  }) : super(const PostSaveInitial());

  bool isPostSaved(int postId) => savedPostIds.contains(postId);

  void removeSavedPost(int postId) {
    savedPostIds.remove(postId);
    _savedPostCollectionIds.remove(postId);
    _savedPostItemIds.remove(postId);
  }

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
        _savedPostCollectionIds[postId] = targetCollectionId;
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

  Future<void> unsavePost({required int postId}) async {
    emit(PostSaveLoading(postId: postId));

    int? targetItemId = _savedPostItemIds[postId];

    if (targetItemId == null) {
      final collectionId =
          _savedPostCollectionIds[postId] ?? _cachedDefaultCollectionId;

      if (collectionId != null) {
        final postsResult =
            await settingRepo.getCollectionPosts(collectionId: collectionId);
        postsResult.fold(
          (_) {},
          (collectionPosts) {
            for (final item in collectionPosts.items) {
              if (item.collectibleId == postId) {
                targetItemId = item.id;
                break;
              }
            }
          },
        );
      }

      if (targetItemId == null) {
        final collectionsResult = await settingRepo.getCollections();
        final collections = collectionsResult.fold(
          (_) => <UserCollectionEntity>[],
          (cols) => cols,
        );

        for (final col in collections) {
          final postsResult =
              await settingRepo.getCollectionPosts(collectionId: col.id);
          final foundItem = postsResult.fold(
            (_) => null,
            (collectionPosts) {
              for (final item in collectionPosts.items) {
                if (item.collectibleId == postId) {
                  return item.id;
                }
              }
              return null;
            },
          );

          if (foundItem != null) {
            targetItemId = foundItem;
            break;
          }
        }
      }
    }

    if (targetItemId != null) {
      final result =
          await settingRepo.removeItemFromCollection(itemId: targetItemId!);

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
          removeSavedPost(postId);
          emit(
            PostUnsaveSuccess(
              postId: postId,
              message: 'Post removed from saved',
            ),
          );
        },
      );
    } else {
      removeSavedPost(postId);
      emit(
        PostUnsaveSuccess(
          postId: postId,
          message: 'Post removed from saved',
        ),
      );
    }
  }
}
