part of 'current_user_cubit.dart';

class CurrentUserState extends Equatable {
  final int? id;
  final String? username;
  final String? token;
  final String? role;

  const CurrentUserState({this.id, this.username, this.token, this.role});

  CurrentUserState copyWith({
    int? id,
    String? username,
    String? token,
    String? role,
  }) {
    return CurrentUserState(
      id: id ?? this.id,
      username: username ?? this.username,
      token: token ?? this.token,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [id, username, token, role];
}

