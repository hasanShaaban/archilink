part of 'current_user_cubit.dart';

class CurrentUserState extends Equatable {
  final String? username;
  final String? token;
  final String? role;

  const CurrentUserState({this.username, this.token, this.role});

  CurrentUserState copyWith({
    String? username,
    String? token,
    String? role,
  }) {
    return CurrentUserState(
      username: username ?? this.username,
      token: token ?? this.token,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [username, token, role];
}

