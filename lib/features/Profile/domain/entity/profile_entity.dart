class ProfileEntity {
  final String name;
  final String username;
  final String email;
  final String? bio;
  final String? location;
  final String? profilePictureUrl;

  const ProfileEntity({
    required this.name,
    required this.username,
    required this.email,
    this.bio,
    this.location,
    this.profilePictureUrl,
  });
}