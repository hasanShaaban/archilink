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
    final normalized = role.toLowerCase().trim();
    _authLocalDataSource.saveRole(normalized);
    emit(state.copyWith(role: normalized));
  }

  void setUser({
    required String username,
    required String token,
    String? role,
  }) {
    final normalized = role?.toLowerCase().trim();
    if (normalized != null && normalized.isNotEmpty) {
      _authLocalDataSource.saveRole(normalized);
    }
    emit(state.copyWith(username: username, token: token, role: normalized));
  }

  void clear() {
    emit(const CurrentUserState());
  }
}
