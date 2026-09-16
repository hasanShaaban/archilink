import 'dart:developer';

import 'package:archilink/core/error/failure.dart';
import 'package:archilink/core/network/websocket/reverb_client.dart';
import 'package:archilink/features/Auth/domain/repo/auth_repo.dart';
import 'package:archilink/features/Auth/domain/repo/notification_repo.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/current_user_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

//TODO: Fix WebSocket Error: Client not connected.
class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  final NotificationRepo notificationRepo;
  final CurrentUserCubit currentUserCubit;
  final ReverbClient reverbClient;
  // final PusherClient pusherClient;

  AuthCubit(
    this.authRepo,
    this.currentUserCubit,
    this.notificationRepo,
    this.reverbClient,
  ) : super(AuthInitial());

  Future<void> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    emit(AuthLoading());

    final result = await authRepo.login(email: email, password: password);

    result.fold(
      (failure) => emit(AuthError(failure.message, failure: failure)),
      (success) async {
        authRepo.setRememberMe(rememberMe);
        currentUserCubit.setUser(
          username: success.username,
          token: success.accessToken,
          role: success.role,
        );

        // await reverbClient.init(token: success.accessToken);

        await notificationRepo.registerFCM();
        emit(AuthAuthenticated());
      },
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
      phone: phone,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message, failure: failure)),
      (success) async {
        authRepo.setRememberMe(true);
        currentUserCubit.setUser(
          username: success.user.username,
          token: success.token,
          role: role,
        );

        // await reverbClient.init(token: success.token);

        await notificationRepo.registerFCM();
        emit(AuthAuthenticated());
      },
    );
  }

  Future<void> initApp() async {
    final isLoggedIn = notificationRepo.isTokenRegistered;
    log(isLoggedIn.toString());
    if (!isLoggedIn) return;

    notificationRepo.listenToTokenRefresh();

    if (!notificationRepo.isTokenRegistered) {
      await notificationRepo.registerFCM();
    }
  }
}
