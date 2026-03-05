
import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Auth/domain/repo/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AuthCubit(this.authRepo) : super(AuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());

    final result = await authRepo.login(email: email, password: password);

    result.fold(
      (failure) => emit(AuthError(failure.message, failure: failure)),
      (_) => emit(AuthAuthenticated()),
    );
  }

  Future<void> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    required String username,
    required String role,
    String? phone,
  }) async {
    emit(AuthLoading());
    final result = await authRepo.register(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      name: name,
      username: username,
      role: role,
      phone: phone
    );
    result.fold(
      (failure) => emit(AuthError(failure.message, failure: failure)),
      (_) => emit(AuthAuthenticated()),
    );
  }
}
