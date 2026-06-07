import 'package:archilink/features/settings/domain/repo/setting_repo.dart';
import 'package:bloc/bloc.dart';
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
}
