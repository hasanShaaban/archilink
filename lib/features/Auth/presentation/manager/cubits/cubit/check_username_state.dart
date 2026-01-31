part of 'check_username_cubit.dart';

sealed class CheckUsernameState extends Equatable {
  const CheckUsernameState();

  @override
  List<Object> get props => [];
}

final class CheckUsernameInitial extends CheckUsernameState {}
final class CheckUsernameLoading extends CheckUsernameState {}
final class CheckUsernameAvailable extends CheckUsernameState {
}
final class CheckUsernameTaken extends CheckUsernameState {}
final class CheckUsernameFailure extends CheckUsernameState {
  final String message;
  const CheckUsernameFailure({required this.message});
}
