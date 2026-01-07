class ProfileEntity {
  final int id;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProfileEntity({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });
}