import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.name,
    required super.username,
    required super.bio,
    required super.profilePictureUrl,
    required super.followersCount,
    required super.followingCount,
    required super.postsCount,
    required super.projectCount,
    required super.role,
    required super.details,
    required super.isFollowing,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> data) {
    return ProfileModel(
      name: data['name'] as String,
      username: data['username'] as String,
      bio: data['bio'],
      profilePictureUrl: data['profile_picture_url'],
      isFollowing: data['is_following'],
      followersCount: data['followers_count'] as int,
      followingCount: data['following_count'] as int,
      postsCount: data['posts_count'] as int,
      projectCount: data['project_count'] as int,
      role: data['role'] as String,
      details: ProfileDetailsModel.fromJson(
        data['details'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'name': name,
        'username': username,
        'bio': bio,
        'profile_picture_url': profilePictureUrl,
        'followers_count': followersCount,
        'following_count': followingCount,
        'posts_count': postsCount,
        'project_count': projectCount,
        'role': role,
        'details': (details as ProfileDetailsModel).toJson(),
        'is_following': isFollowing,
      },
    };
  }
}

class ProfileDetailsModel extends ProfileDetailsEntity {
  const ProfileDetailsModel({
    super.aboutMe,
    required super.academicExperiences,
    required super.contactInfo,
    required super.skills,
    required super.joinedAt,
    super.country,
    super.city,
  });

  factory ProfileDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProfileDetailsModel(
      aboutMe: json['about_me'] as String?,
      country: json['country'],
      city: json['city'],
      academicExperiences: (json['academic_experiences'] as List<dynamic>)
          .map(
            (e) => AcademicExperienceModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      contactInfo: (json['contact_info'] as List<dynamic>)
          .map((e) => ContactInfoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      skills: (json['skills'] as List<dynamic>)
          .map((e) => SkillModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      joinedAt: DateTime.parse(json['joined_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'about_me': aboutMe,
      'academic_experiences': academicExperiences
          .map((e) => (e as AcademicExperienceModel).toJson())
          .toList(),
      'contact_info': contactInfo
          .map((e) => (e as ContactInfoModel).toJson())
          .toList(),
      'skills': skills.map((e) => (e as SkillModel).toJson()).toList(),
      'joined_at': joinedAt.toIso8601String().split('T').first,
      'country': country,
      'city': city,
    };
  }
}

class AcademicExperienceModel extends AcademicExperienceEntity {
  const AcademicExperienceModel({
    required super.university,
    required super.degree,
    required super.fieldOfStudy,
    required super.startYear,
    super.endYear,
  });

  factory AcademicExperienceModel.fromJson(Map<String, dynamic> json) {
    return AcademicExperienceModel(
      university: json['university'] as String,
      degree: json['degree'] as String,
      fieldOfStudy: json['field_of_study'] as String,
      startYear: json['start_year'] as int,
      endYear: json['end_year'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'university': university,
      'degree': degree,
      'field_of_study': fieldOfStudy,
      'start_year': startYear,
      'end_year': endYear,
    };
  }
}

class ContactInfoModel extends ContactInfoEntity {
  const ContactInfoModel({
    required super.platform,
    required super.username,
    super.url,
  });

  factory ContactInfoModel.fromJson(Map<String, dynamic> json) {
    return ContactInfoModel(
      platform: json['platform'] as String,
      username: json['handle'] as String,
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'platform': platform, 'handle': username, 'url': url};
  }
}

class SkillModel extends SkillsEntity {
  const SkillModel({required super.id, required super.name});

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(id: json['id'] as int, name: json['name'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
