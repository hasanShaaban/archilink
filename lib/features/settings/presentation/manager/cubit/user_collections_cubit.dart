import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/settings/domain/repo/setting_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'user_collections_state.dart';

class UserCollectionsCubit extends Cubit<UserCollectionsState> {
  UserCollectionsCubit(this._settingRepo) : super(const UserCollectionsInitial());

  final SettingRepo _settingRepo;

  Future<void> fetchCollections() async {
    if (state.isLoadingCollections) return;

    emit(
      state.copyWith(
        isLoadingCollections: true,
        collectionsErrorMessage: null,
      ),
    );

    final result = await _settingRepo.getCollections();
    if (isClosed) return;

    result.fold((failure) {
      emit(
        state.copyWith(
          isLoadingCollections: false,
          collectionsErrorMessage: failure.message,
        ),
      );
    }, (collectionsData) {
      emit(
        state.copyWith(
          isLoadingCollections: false,
          collectionsErrorMessage: null,
          collections: collectionsData,
        ),
      );
    });
  }

  Future<bool> createCollection({required String title}) async {
    if (state.isCreatingCollection) return false;

    emit(
      state.copyWith(
        isCreatingCollection: true,
        createCollectionErrorMessage: null,
      ),
    );

    final result = await _settingRepo.createCollection(title: title);
    if (isClosed) return false;

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            isCreatingCollection: false,
            createCollectionErrorMessage: failure.message,
          ),
        );
        return false;
      },
      (success) {
        emit(
          state.copyWith(
            isCreatingCollection: false,
            createCollectionErrorMessage: null,
          ),
        );
        fetchCollections();
        return true;
      },
    );
  }

  void clearCreateCollectionError() {
    if (state.createCollectionErrorMessage != null) {
      emit(state.copyWith(createCollectionErrorMessage: null));
    }
  }

  Future<bool> editCollectionName({
    required int id,
    required String name,
  }) async {
    if (state.isEditingCollection) return false;

    emit(
      state.copyWith(
        isEditingCollection: true,
        editCollectionErrorMessage: null,
      ),
    );

    final result = await _settingRepo.editCollectionName(
      id: id,
      name: name,
    );
    if (isClosed) return false;

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            isEditingCollection: false,
            editCollectionErrorMessage: failure.message,
          ),
        );
        return false;
      },
      (success) {
        if (success) {
          final updated = state.collections.map((c) {
            if (c.id == id) {
              return c.copyWith(title: name, updatedAt: DateTime.now());
            }
            return c;
          }).toList();
          emit(
            state.copyWith(
              isEditingCollection: false,
              editCollectionErrorMessage: null,
              collections: updated,
            ),
          );
        } else {
          emit(
            state.copyWith(
              isEditingCollection: false,
              editCollectionErrorMessage: null,
            ),
          );
        }
        return success;
      },
    );
  }

  void clearEditCollectionError() {
    if (state.editCollectionErrorMessage != null) {
      emit(state.copyWith(editCollectionErrorMessage: null));
    }
  }

  Future<Either<Failure, bool>> removeCollection({
    required int collectionId,
  }) async {
    final result =
        await _settingRepo.removeCollection(collectionId: collectionId);
    if (isClosed) return left(UnknownFailure());

    result.fold(
      (_) {},
      (success) {
        if (success) {
          final updated =
              state.collections.where((c) => c.id != collectionId).toList();
          emit(state.copyWith(collections: updated));
        }
      },
    );

    return result;
  }
}
