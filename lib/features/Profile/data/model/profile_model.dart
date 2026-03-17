

import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';


class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.name,
    required super.username,
    required super.profilePictureUrl,
    required super.followersCount,
    required super.followingCount,
    required super.postsCount,
    required super.projectCount,
    required super.role,
    required super.details,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> data) {
    return ProfileModel(
      name: data['name'] as String,
      username: data['username'] as String,
      profilePictureUrl: data['profile_picture_url'],
      followersCount: data['followers_count'] as int,
      followingCount: data['following_count'] as int,
      postsCount: data['posts_count'] as int,
      projectCount: data['project_count'] as int,
      role: data['role'] as String,
      details: ProfileDetailsModel.fromJson(
        data['Details'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'name': name,
        'username': username,
        'profile_picture_url': profilePictureUrl,
        'followers_count': followersCount,
        'following_count': followingCount,
        'posts_count': postsCount,
        'project_count': projectCount,
        'role': role,
        'Details': (details as ProfileDetailsModel).toJson(),
      },
    };
  }
}

class ProfileDetailsModel extends ProfileDetailsEntity {
  const ProfileDetailsModel({
    super.bio,
    required super.academicExperiences,
    required super.contactInfo,
    required super.skills,
    super.location,
    required super.joinedAt,
  });

  factory ProfileDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProfileDetailsModel(
      bio: json['bio'] as String?,
      academicExperiences: (json['academic_experiences'] as List<dynamic>)
          .map((_) => const AcademicExperienceEntity())
          .toList(),
      contactInfo: (json['contact_info'] as List<dynamic>)
          .map((_) => const ContactInfoEntity())
          .toList(),
      skills: (json['skills'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      location: json['location'] as String?,
      joinedAt: DateTime.parse(json['joined_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'academic_experiences': [],
      'contact_info': [],
      'skills': skills,
      'location': location,
      'joined_at': joinedAt.toIso8601String().split('T').first,
    };
  }
}