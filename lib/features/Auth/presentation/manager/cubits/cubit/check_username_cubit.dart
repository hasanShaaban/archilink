import 'package:archilink/features/Auth/domain/repo/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'check_username_state.dart';

class CheckUsernameCubit extends Cubit<CheckUsernameState> {
  CheckUsernameCubit(this.authRepo) : super(CheckUsernameInitial());
  final AuthRepo authRepo;

  Future<void> checkUsername({required String username}) async {
    emit(CheckUsernameLoading());
    final result = await authRepo.checkUsername(username: username);
    result.fold(
      (failure) => emit(CheckUsernameFailure(message: failure.message)),
      (available) {
        if (available) {
          emit(CheckUsernameAvailable());
        } else {
          emit(CheckUsernameTaken());
        }
      },
    );
  }
}
