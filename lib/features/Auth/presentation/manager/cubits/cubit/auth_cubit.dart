import 'package:archilink/features/Auth/domain/repo/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AuthCubit(this.authRepo) : super(AuthInitial());

  Future<void> login({required String email, required String password}) async{
    emit(AuthLoading());

    final result = await authRepo.login(email: email, password: password);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthAuthenticated()),
    );
  }
}
