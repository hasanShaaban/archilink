class SenderEntity {
  final int id;
  final String name;
  final String username;
  final String? userAvatar;
  final String? country;
  final String? city;
  final String? role;
  final bool? isVerified;

  const SenderEntity({
    required this.id,
    required this.name,
    required this.username,
    this.userAvatar,
    this.country,
    this.city,
    this.role,
    this.isVerified,
  });
  @override
  bool operator ==(Object other) => other is SenderEntity && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
