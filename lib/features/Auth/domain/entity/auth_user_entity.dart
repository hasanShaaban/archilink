class AuthUserEntity {
  final int id;
  final String name;
  final String username;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? phoneNumber;

  const AuthUserEntity({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.createdAt,
    required this.updatedAt, this.phoneNumber,
  });
}
