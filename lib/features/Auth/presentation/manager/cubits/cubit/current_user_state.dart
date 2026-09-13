part of 'current_user_cubit.dart';

class CurrentUserState extends Equatable {
  final String? username;
  final String? token;

  const CurrentUserState({this.username, this.token});

  CurrentUserState copyWith({
    String? username,
    String? token,
  }) {
    return CurrentUserState(
      username: username ?? this.username,
      token: token ?? this.token,
    );
  }

  @override
  List<Object?> get props => [username, token];
}

