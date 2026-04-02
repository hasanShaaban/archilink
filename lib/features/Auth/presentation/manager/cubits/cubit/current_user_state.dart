part of 'current_user_cubit.dart';

class CurrentUserState extends Equatable {
  final String? username;

  const CurrentUserState({this.username});

  @override
  List<Object?> get props => [username];
}
