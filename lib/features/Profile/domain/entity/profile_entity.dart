import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final int? id;
  final String name;
  final String username;
  final String? profilePictureUrl;
  final String? bannerImageUrl;
  final String? bio;
  final bool isFollowing;
  final bool isVerified;
  final String privacySetting;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final int projectCount;
  final String role;
  final ProfileDetailsEntity details;

  const ProfileEntity({
    this.id,
    required this.name,
    required this.username,
    required this.profilePictureUrl,
    this.bannerImageUrl,
    required this.followersCount,
    required this.isFollowing,
    required this.followingCount,
    required this.postsCount,
    required this.projectCount,
    required this.role,
    required this.details,
    required this.bio,
    this.isVerified = false,
    this.privacySetting = 'public',
  });

  ProfileEntity copyWith({
    int? id,
    String? name,
    String? username,
    String? profilePictureUrl,
    String? bannerImageUrl,
    String? bio,
    bool? isFollowing,
    bool? isVerified,
    String? privacySetting,
    int? followersCount,
    int? followingCount,
    int? postsCount,
    int? projectCount,
    String? role,
    ProfileDetailsEntity? details,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      bannerImageUrl: bannerImageUrl ?? this.bannerImageUrl,
      bio: bio ?? this.bio,
      isFollowing: isFollowing ?? this.isFollowing,
      isVerified: isVerified ?? this.isVerified,
      privacySetting: privacySetting ?? this.privacySetting,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      postsCount: postsCount ?? this.postsCount,
      projectCount: projectCount ?? this.projectCount,
      role: role ?? this.role,
      details: details ?? this.details,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    username,
    bio,
    profilePictureUrl,
    bannerImageUrl,
    isFollowing,
    isVerified,
    privacySetting,
    followersCount,
    followingCount,
    postsCount,
    projectCount,
    role,
    details,
  ];
}

class ProfileDetailsEntity extends Equatable {
  final String? aboutMe;
  final List<AcademicExperienceEntity> academicExperiences;
  final List<ContactInfoEntity> contactInfo;
  final List<SkillsEntity> skills;
  final String? country;
  final String? city;
  final DateTime joinedAt;

  const ProfileDetailsEntity({
    this.aboutMe,
    required this.academicExperiences,
    required this.contactInfo,
    required this.skills,
    required this.joinedAt,
    this.country,
    this.city,
  });

  @override
  List<Object?> get props => [
    aboutMe,
    academicExperiences,
    contactInfo,
    skills,
    joinedAt,
    country,
    city,
  ];
}

class SkillsEntity extends Equatable {
  final String name;
  final int id;

  const SkillsEntity({required this.name, required this.id});

  @override
  List<Object?> get props => [name, id];
}

class AcademicExperienceEntity extends Equatable {
  final String university;
  final String degree;
  final String fieldOfStudy;
  final int startYear;
  final int? endYear;

  const AcademicExperienceEntity({
    required this.university,
    required this.degree,
    required this.fieldOfStudy,
    required this.startYear,
    this.endYear,
  });

  @override
  List<Object?> get props => [
    university,
    degree,
    fieldOfStudy,
    startYear,
    endYear,
  ];
}

class ContactInfoEntity extends Equatable {
  final String platform;
  final String? url;
  final String username;
  const ContactInfoEntity({
    required this.platform,
    this.url,
    required this.username,
  });

  @override
  List<Object?> get props => [platform, url, username];
}
