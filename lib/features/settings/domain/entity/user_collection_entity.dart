class UserCollectionEntity {
  final int id;
  final int userId;
  final String title;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserCollectionEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });
}
