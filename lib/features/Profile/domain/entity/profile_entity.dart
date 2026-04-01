import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String name;
  final String username;
  final String? profilePictureUrl;
  final bool? isFollowing;
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
    required this.isFollowing,
    required this.followingCount,
    required this.postsCount,
    required this.projectCount,
    required this.role,
    required this.details,
  });

  @override
  List<Object?> get props => [
    name,
    username,
    profilePictureUrl,
    followersCount,
    followingCount,
    postsCount,
    isFollowing,
    projectCount,
    role,
    details,
  ];
}

class ProfileDetailsEntity extends Equatable {
  final String? bio;
  final List<AcademicExperienceEntity> academicExperiences;
  final List<ContactInfoEntity> contactInfo;
  final List<SkillsEntity> skills;
  final String? country;
  final String? city;
  final DateTime joinedAt;

  const ProfileDetailsEntity({
    this.bio,
    required this.academicExperiences,
    required this.contactInfo,
    required this.skills,
    required this.joinedAt,
    this.country,
    this.city,
  });

  @override
  List<Object?> get props => [
    bio,
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
