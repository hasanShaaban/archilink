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

  UserCollectionEntity copyWith({
    int? id,
    int? userId,
    String? title,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserCollectionEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
