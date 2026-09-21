import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final int? id;
  final String name;
  final String username;
  final String role;
  final bool isFollowing;
  final bool isVerified;
  final ProfileDetailsEntity details;

  ProfileEntity({
    this.id,
    required this.name,
    required this.username,
    required this.role,
    this.isFollowing = false,
    this.isVerified = false,
    ProfileDetailsEntity? details,
    String? profilePictureUrl,
    String? bannerImageUrl,
    String? bio,
    int? followersCount,
    int? followingCount,
    int? postsCount,
    int? projectCount,
    String? privacySetting,
    String? publicEmail,
    String? publicPhoneNumber,
    String? websiteUrl,
    int? productsCount,
    DateTime? joinedAt,
  }) : details = details != null
            ? (profilePictureUrl != null ||
                    bannerImageUrl != null ||
                    bio != null ||
                    followersCount != null ||
                    followingCount != null ||
                    postsCount != null ||
                    projectCount != null ||
                    privacySetting != null ||
                    publicEmail != null ||
                    publicPhoneNumber != null ||
                    websiteUrl != null ||
                    productsCount != null ||
                    joinedAt != null
                ? details.copyWith(
                    profilePictureUrl: profilePictureUrl,
                    bannerImageUrl: bannerImageUrl,
                    bio: bio,
                    followersCount: followersCount,
                    followingCount: followingCount,
                    postsCount: postsCount,
                    projectCount: projectCount,
                    privacySetting: privacySetting,
                    publicEmail: publicEmail,
                    publicPhoneNumber: publicPhoneNumber,
                    websiteUrl: websiteUrl,
                    productsCount: productsCount,
                    joinedAt: joinedAt,
                  )
                : details)
            : ProfileDetailsEntity(
                profilePictureUrl: profilePictureUrl,
                bannerImageUrl: bannerImageUrl,
                bio: bio,
                followersCount: followersCount ?? 0,
                followingCount: followingCount ?? 0,
                postsCount: postsCount ?? 0,
                projectCount: projectCount ?? 0,
                privacySetting: privacySetting ?? 'public',
                academicExperiences: const [],
                contactInfo: const [],
                skills: const [],
                joinedAt: joinedAt,
                publicEmail: publicEmail,
                publicPhoneNumber: publicPhoneNumber,
                websiteUrl: websiteUrl,
                productsCount: productsCount,
              );

  // Convenience getters to access details fields directly
  String? get profilePictureUrl => details.profilePictureUrl;
  String? get bannerImageUrl => details.bannerImageUrl;
  String? get bio => details.bio;
  int get followersCount => details.followersCount;
  int get followingCount => details.followingCount;
  int get postsCount => details.postsCount;
  int get projectCount => details.projectCount;
  String get privacySetting => details.privacySetting;
  String? get publicEmail => details.publicEmail;
  String? get publicPhoneNumber => details.publicPhoneNumber;
  String? get websiteUrl => details.websiteUrl;
  int? get productsCount => details.productsCount;
  DateTime? get joinedAt => details.joinedAt;

  ProfileEntity copyWith({
    int? id,
    String? name,
    String? username,
    String? role,
    bool? isFollowing,
    bool? isVerified,
    ProfileDetailsEntity? details,
    String? profilePictureUrl,
    String? bannerImageUrl,
    String? bio,
    int? followersCount,
    int? followingCount,
    int? postsCount,
    int? projectCount,
    String? privacySetting,
    String? publicEmail,
    String? publicPhoneNumber,
    String? websiteUrl,
    int? productsCount,
    DateTime? joinedAt,
  }) {
    final updatedDetails = (details ?? this.details).copyWith(
      profilePictureUrl: profilePictureUrl,
      bannerImageUrl: bannerImageUrl,
      bio: bio,
      followersCount: followersCount,
      followingCount: followingCount,
      postsCount: postsCount,
      projectCount: projectCount,
      privacySetting: privacySetting,
      publicEmail: publicEmail,
      publicPhoneNumber: publicPhoneNumber,
      websiteUrl: websiteUrl,
      productsCount: productsCount,
      joinedAt: joinedAt,
    );

    return ProfileEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      role: role ?? this.role,
      isFollowing: isFollowing ?? this.isFollowing,
      isVerified: isVerified ?? this.isVerified,
      details: updatedDetails,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    username,
    role,
    isFollowing,
    isVerified,
    details,
  ];
}

class ProfileDetailsEntity extends Equatable {
  final String? profilePictureUrl;
  final String? bannerImageUrl;
  final int followersCount;
  final int followingCount;
  final String? bio;
  final String privacySetting;
  final int postsCount;
  final int projectCount;
  final String? aboutMe;
  final List<AcademicExperienceEntity> academicExperiences;
  final List<ContactInfoEntity> contactInfo;
  final List<SkillsEntity> skills;
  final String? country;
  final String? city;
  final DateTime? joinedAt;
  final String? publicEmail;
  final String? publicPhoneNumber;
  final String? websiteUrl;
  final int? productsCount;

  const ProfileDetailsEntity({
    this.profilePictureUrl,
    this.bannerImageUrl,
    this.followersCount = 0,
    this.followingCount = 0,
    this.bio,
    this.privacySetting = 'public',
    this.postsCount = 0,
    this.projectCount = 0,
    this.aboutMe,
    this.academicExperiences = const [],
    this.contactInfo = const [],
    this.skills = const [],
    this.joinedAt,
    this.country,
    this.city,
    this.publicEmail,
    this.publicPhoneNumber,
    this.websiteUrl,
    this.productsCount,
  });

  ProfileDetailsEntity copyWith({
    String? profilePictureUrl,
    String? bannerImageUrl,
    int? followersCount,
    int? followingCount,
    String? bio,
    String? privacySetting,
    int? postsCount,
    int? projectCount,
    String? aboutMe,
    List<AcademicExperienceEntity>? academicExperiences,
    List<ContactInfoEntity>? contactInfo,
    List<SkillsEntity>? skills,
    String? country,
    String? city,
    DateTime? joinedAt,
    String? publicEmail,
    String? publicPhoneNumber,
    String? websiteUrl,
    int? productsCount,
  }) {
    return ProfileDetailsEntity(
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      bannerImageUrl: bannerImageUrl ?? this.bannerImageUrl,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      bio: bio ?? this.bio,
      privacySetting: privacySetting ?? this.privacySetting,
      postsCount: postsCount ?? this.postsCount,
      projectCount: projectCount ?? this.projectCount,
      aboutMe: aboutMe ?? this.aboutMe,
      academicExperiences: academicExperiences ?? this.academicExperiences,
      contactInfo: contactInfo ?? this.contactInfo,
      skills: skills ?? this.skills,
      country: country ?? this.country,
      city: city ?? this.city,
      joinedAt: joinedAt ?? this.joinedAt,
      publicEmail: publicEmail ?? this.publicEmail,
      publicPhoneNumber: publicPhoneNumber ?? this.publicPhoneNumber,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      productsCount: productsCount ?? this.productsCount,
    );
  }

  @override
  List<Object?> get props => [
    profilePictureUrl,
    bannerImageUrl,
    followersCount,
    followingCount,
    bio,
    privacySetting,
    postsCount,
    projectCount,
    aboutMe,
    academicExperiences,
    contactInfo,
    skills,
    joinedAt,
    country,
    city,
    publicEmail,
    publicPhoneNumber,
    websiteUrl,
    productsCount,
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
