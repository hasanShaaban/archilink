class UserEntity {
  final int id;
  final String name;
  final String username;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });
}
