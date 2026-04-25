import 'package:archilink/core/error/failure.dart';
import 'package:archilink/core/network/websocket/reverb_client.dart';
import 'package:archilink/features/Auth/domain/data_source/auth_local_data_source.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/current_user_cubit.dart';
import 'package:archilink/features/settings/domain/repo/setting_repo.dart';
import 'package:bloc/bloc.dart';

import 'settings_session_state.dart';

class SettingsSessionCubit extends Cubit<SettingsSessionState> {
  SettingsSessionCubit(
    this._settingRepo,
    this._authLocalDataSource,
    this._currentUserCubit,
    this._reverbClient,
  ) : super(const SettingsSessionInitial());

  final SettingRepo _settingRepo;
  final AuthLocalDataSource _authLocalDataSource;
  final CurrentUserCubit _currentUserCubit;
  final ReverbClient _reverbClient;

  Future<void> logout() async {
    if (state is SettingsSessionLoading) return;
    emit(const SettingsSessionLoading());

    final result = await _settingRepo.logOut();

    await result.fold((failure) async {
      emit(SettingsSessionError(failure: failure, message: failure.message));
    }, (isSuccess) async {
      if (!isSuccess) {
        const failure = UnknownFailure();
        emit(SettingsSessionError(failure: failure, message: failure.message));
        return;
      }

      await _authLocalDataSource.clearToken();
      await _authLocalDataSource.clearUsername();
      await _authLocalDataSource.setRememberMe(false);
      await _authLocalDataSource.setTokenRegistered(false);
      _currentUserCubit.clear();
      _reverbClient.disconnect();
      emit(const SettingsSessionLoggedOut());
    });
  }
}
