import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    super.id,
    required super.name,
    required super.username,
    required super.role,
    super.isFollowing,
    super.isVerified,
    super.details,
    super.profilePictureUrl,
    super.bannerImageUrl,
    super.bio,
    super.followersCount,
    super.followingCount,
    super.postsCount,
    super.projectCount,
    super.privacySetting,
    super.publicEmail,
    super.publicPhoneNumber,
    super.websiteUrl,
    super.productsCount,
    super.joinedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    final Map<String, dynamic> detailsData =
        (data['details'] is Map<String, dynamic>)
            ? Map<String, dynamic>.from(data['details'] as Map<String, dynamic>)
            : Map<String, dynamic>.from(data);

    if (!detailsData.containsKey('profile_picture_url') &&
        data.containsKey('profile_picture_url')) {
      detailsData['profile_picture_url'] = data['profile_picture_url'];
    }
    if (!detailsData.containsKey('store_banner_url') &&
        data.containsKey('store_banner_url')) {
      detailsData['store_banner_url'] = data['store_banner_url'];
    }
    if (!detailsData.containsKey('banner_image_url') &&
        data.containsKey('banner_image_url')) {
      detailsData['banner_image_url'] = data['banner_image_url'];
    }
    if (!detailsData.containsKey('banner') && data.containsKey('banner')) {
      detailsData['banner'] = data['banner'];
    }
    if (!detailsData.containsKey('bio') && data.containsKey('bio')) {
      detailsData['bio'] = data['bio'];
    }
    if (!detailsData.containsKey('followers_count') &&
        data.containsKey('followers_count')) {
      detailsData['followers_count'] = data['followers_count'];
    }
    if (!detailsData.containsKey('following_count') &&
        data.containsKey('following_count')) {
      detailsData['following_count'] = data['following_count'];
    }
    if (!detailsData.containsKey('posts_count') &&
        data.containsKey('posts_count')) {
      detailsData['posts_count'] = data['posts_count'];
    }
    if (!detailsData.containsKey('products_count') &&
        data.containsKey('products_count')) {
      detailsData['products_count'] = data['products_count'];
    }
    if (!detailsData.containsKey('project_count') &&
        data.containsKey('project_count')) {
      detailsData['project_count'] = data['project_count'];
    }
    if (!detailsData.containsKey('privacy_setting') &&
        data.containsKey('privacy_setting')) {
      detailsData['privacy_setting'] = data['privacy_setting'];
    }
    if (!detailsData.containsKey('public_email') &&
        data.containsKey('public_email')) {
      detailsData['public_email'] = data['public_email'];
    }
    if (!detailsData.containsKey('public_phone_number') &&
        data.containsKey('public_phone_number')) {
      detailsData['public_phone_number'] = data['public_phone_number'];
    }
    if (!detailsData.containsKey('website_url') &&
        data.containsKey('website_url')) {
      detailsData['website_url'] = data['website_url'];
    }

    return ProfileModel(
      id: (data['id'] as num?)?.toInt(),
      name: (data['name'] as String?) ?? '',
      username: (data['username'] ?? data['handle'] ?? '') as String,
      role: (data['role'] as String?) ?? '',
      isFollowing: (data['is_following'] as bool?) ?? false,
      isVerified: (data['is_verified'] as bool?) ?? false,
      details: ProfileDetailsModel.fromJson(detailsData),
    );
  }

  factory ProfileModel.fromStoreJson(
    Map<String, dynamic> data, {
    bool isFollowing = false,
    int? followCount,
  }) {
    final description = (data['description'] ?? data['bio']) as String?;
    final bannerUrl = (data['store_banner_url'] ??
        data['banner_image_url'] ??
        data['banner']) as String?;
    final logoUrl =
        (data['store_logo_url'] ?? data['profile_picture_url']) as String?;
    final prodCount =
        (data['products_count'] ?? data['posts_count'] as num?)?.toInt() ?? 0;

    return ProfileModel(
      id: (data['id'] as num?)?.toInt(),
      name: (data['name'] as String?) ?? '',
      username: (data['handle'] ?? data['username'] ?? '') as String,
      role: (data['role'] as String?) ?? 'store',
      isFollowing: isFollowing,
      isVerified: (data['is_verified'] as bool?) ?? false,
      details: ProfileDetailsModel(
        profilePictureUrl: logoUrl,
        bannerImageUrl: bannerUrl,
        publicEmail: data['public_email'] as String?,
        publicPhoneNumber: data['public_phone_number'] as String?,
        websiteUrl: data['website_url'] as String?,
        productsCount: prodCount,
        followersCount:
            followCount ?? (data['followers_count'] as num?)?.toInt() ?? 0,
        followingCount: (data['following_count'] as num?)?.toInt() ?? 0,
        bio: description,
        privacySetting: 'public',
        postsCount: prodCount,
        projectCount: 0,
        aboutMe: description,
        academicExperiences: const [],
        contactInfo: const [],
        skills: const [],
        joinedAt: null,
        city: data['city'] as String?,
        country: data['country'] as String?,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        if (id != null) 'id': id,
        'name': name,
        'username': username,
        'role': role,
        'is_verified': isVerified,
        'is_following': isFollowing,
        'details': (details as ProfileDetailsModel).toJson(),
      },
    };
  }
}

class ProfileDetailsModel extends ProfileDetailsEntity {
  const ProfileDetailsModel({
    super.profilePictureUrl,
    super.bannerImageUrl,
    super.followersCount = 0,
    super.followingCount = 0,
    super.bio,
    super.privacySetting = 'public',
    super.postsCount = 0,
    super.projectCount = 0,
    super.aboutMe,
    super.academicExperiences = const [],
    super.contactInfo = const [],
    super.skills = const [],
    super.joinedAt,
    super.country,
    super.city,
    super.publicEmail,
    super.publicPhoneNumber,
    super.websiteUrl,
    super.productsCount,
  });

  factory ProfileDetailsModel.fromJson(Map<String, dynamic> json) {
    DateTime? joinedDate;
    if (json['joined_at'] != null) {
      try {
        joinedDate = DateTime.parse(json['joined_at'] as String);
      } catch (_) {
        joinedDate = null;
      }
    }

    final bannerUrl = (json['store_banner_url'] ??
            json['banner_image_url'] ??
            json['banner']) as String?;

    final profilePic = (json['profile_picture_url'] ??
            json['store_logo_url'] ??
            json['logo']) as String?;

    final products = (json['products_count'] as num?)?.toInt();
    final posts = (json['posts_count'] as num?)?.toInt() ?? products ?? 0;

    return ProfileDetailsModel(
      profilePictureUrl: profilePic,
      bannerImageUrl: bannerUrl,
      publicEmail: json['public_email'] as String?,
      publicPhoneNumber: json['public_phone_number'] as String?,
      websiteUrl: json['website_url'] as String?,
      productsCount: products,
      followersCount: (json['followers_count'] as num?)?.toInt() ?? 0,
      followingCount: (json['following_count'] as num?)?.toInt() ?? 0,
      bio: json['bio'] as String?,
      privacySetting: json['privacy_setting'] as String? ?? 'public',
      postsCount: posts,
      projectCount: (json['project_count'] as num?)?.toInt() ?? 0,
      aboutMe: (json['about_me'] ?? json['bio']) as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
      academicExperiences: (json['academic_experiences'] as List<dynamic>?)
              ?.map(
                (e) =>
                    AcademicExperienceModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      contactInfo: (json['contact_info'] as List<dynamic>?)
              ?.map((e) => ContactInfoModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => SkillModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      joinedAt: joinedDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profile_picture_url': profilePictureUrl,
      if (bannerImageUrl != null) 'banner_image_url': bannerImageUrl,
      if (bannerImageUrl != null) 'store_banner_url': bannerImageUrl,
      if (publicEmail != null) 'public_email': publicEmail,
      if (publicPhoneNumber != null) 'public_phone_number': publicPhoneNumber,
      if (websiteUrl != null) 'website_url': websiteUrl,
      if (productsCount != null) 'products_count': productsCount,
      'followers_count': followersCount,
      'following_count': followingCount,
      'bio': bio,
      'privacy_setting': privacySetting,
      'posts_count': postsCount,
      'project_count': projectCount,
      'about_me': aboutMe,
      'academic_experiences': academicExperiences
          .map((e) => (e as AcademicExperienceModel).toJson())
          .toList(),
      'contact_info': contactInfo
          .map((e) => (e as ContactInfoModel).toJson())
          .toList(),
      'skills': skills.map((e) => (e as SkillModel).toJson()).toList(),
      if (joinedAt != null)
        'joined_at': joinedAt!.toIso8601String().split('T').first,
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
