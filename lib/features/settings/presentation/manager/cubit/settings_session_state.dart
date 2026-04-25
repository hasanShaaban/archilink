import 'package:archilink/core/error/failure.dart';
import 'package:equatable/equatable.dart';

sealed class SettingsSessionState extends Equatable {
  const SettingsSessionState();

  @override
  List<Object?> get props => [];
}

final class SettingsSessionInitial extends SettingsSessionState {
  const SettingsSessionInitial();
}

final class SettingsSessionLoading extends SettingsSessionState {
  const SettingsSessionLoading();
}

final class SettingsSessionLoggedOut extends SettingsSessionState {
  const SettingsSessionLoggedOut();
}

final class SettingsSessionError extends SettingsSessionState {
  final Failure failure;
  final String message;

  const SettingsSessionError({required this.failure, required this.message});

  @override
  List<Object?> get props => [failure, message];
}
