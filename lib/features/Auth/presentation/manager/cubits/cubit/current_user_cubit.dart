import 'package:archilink/features/Auth/domain/data_source/auth_local_data_source.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'current_user_state.dart';

class CurrentUserCubit extends Cubit<CurrentUserState> {
  CurrentUserCubit(this._authLocalDataSource)
    : super(const CurrentUserState());

  final AuthLocalDataSource _authLocalDataSource;

  void loadFromCache() {
    emit(CurrentUserState(username: _authLocalDataSource.getUsername()));
  }

  void setUsername(String username) {
    emit(CurrentUserState(username: username));
  }

  void clear() {
    emit(const CurrentUserState());
  }
}
