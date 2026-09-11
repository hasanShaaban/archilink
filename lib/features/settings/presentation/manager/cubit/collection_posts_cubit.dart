import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/settings/domain/repo/setting_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'collection_posts_state.dart';

class CollectionPostsCubit extends Cubit<CollectionPostsState> {
  final SettingRepo _settingRepo;

  CollectionPostsCubit(this._settingRepo)
      : super(const CollectionPostsInitial());

  Future<void> fetchCollectionPosts({
    required int collectionId,
    bool forceRefresh = false,
  }) async {
    if (state.isLoading &&
        state.currentCollectionId == collectionId &&
        !forceRefresh) {
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        currentCollectionId: collectionId,
      ),
    );

    final result =
        await _settingRepo.getCollectionPosts(collectionId: collectionId);
    if (isClosed) return;

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          ),
        );
      },
      (collectionPosts) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: null,
            items: collectionPosts.items,
            currentCollectionId: collectionId,
          ),
        );
      },
    );
  }

  Future<Either<Failure, bool>> removeItemFromCollection({
    required int itemId,
  }) async {
    final result = await _settingRepo.removeItemFromCollection(itemId: itemId);
    if (isClosed) return left(UnknownFailure());

    result.fold(
      (_) {},
      (success) {
        if (success) {
          final updatedItems =
              state.items.where((item) => item.id != itemId).toList();
          emit(state.copyWith(items: updatedItems));
        }
      },
    );

    return result;
  }
}
