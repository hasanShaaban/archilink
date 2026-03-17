
import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
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

  @override
  List<Object?> get props => [
    name,
    username,
    profilePictureUrl,
    followersCount,
    followingCount,
    postsCount,
    projectCount,
    role,
    details,
  ];
}

class ProfileDetailsEntity extends Equatable {
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

  @override
  List<Object?> get props => [
    bio,
    academicExperiences,
    contactInfo,
    skills,
    location,
    joinedAt,
  ];
}

class AcademicExperienceEntity extends Equatable {
  const AcademicExperienceEntity();

  @override
  List<Object?> get props => [];
}

class ContactInfoEntity extends Equatable {
  const ContactInfoEntity();

  @override
  List<Object?> get props => [];
}
