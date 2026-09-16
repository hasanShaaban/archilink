import 'package:archilink/features/Auth/domain/data_source/auth_local_data_source.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'current_user_state.dart';

class CurrentUserCubit extends Cubit<CurrentUserState> {
  CurrentUserCubit(this._authLocalDataSource) : super(const CurrentUserState());

  final AuthLocalDataSource _authLocalDataSource;

  void loadFromCache() {
    emit(
      CurrentUserState(
        username: _authLocalDataSource.getUsername(),
        token: _authLocalDataSource.getToken(),
        role: _authLocalDataSource.getRole(),
      ),
    );
  }

  void setUsername(String username) {
    emit(state.copyWith(username: username));
  }

  void setToken(String token) {
    emit(state.copyWith(token: token));
  }

  void setRole(String role) {
    emit(state.copyWith(role: role));
  }

  void setUser({
    required String username,
    required String token,
    String? role,
  }) {
    emit(state.copyWith(username: username, token: token, role: role));
  }

  void clear() {
    emit(const CurrentUserState());
  }
}
