class ProfileEntity {
  final String name;
  final String username;
  final String? profilePictureUrl;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final int projectCount;
  final String role;
  final ProfileDetailsEntity details;
 
  const ProfileEntity({
    required this.name,
    required this.username,
    required this.profilePictureUrl,
    required this.followersCount,
    required this.followingCount,
    required this.postsCount,
    required this.projectCount,
    required this.role,
    required this.details,
  });
}
 
class ProfileDetailsEntity {
  final String? bio;
  final List<AcademicExperienceEntity> academicExperiences;
  final List<ContactInfoEntity> contactInfo;
  final List<String> skills;
  final String? location;
  final DateTime joinedAt;
 
  const ProfileDetailsEntity({
    this.bio,
    required this.academicExperiences,
    required this.contactInfo,
    required this.skills,
    this.location,
    required this.joinedAt,
  });
}
 
class AcademicExperienceEntity {
  // Extend fields here once the API returns data
  const AcademicExperienceEntity();
}
 
class ContactInfoEntity {
  // Extend fields here once the API returns data
  const ContactInfoEntity();
}