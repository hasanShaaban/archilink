part of 'edit_profile_cubit.dart';

class AcademicExperience extends Equatable {
  const AcademicExperience({
    required this.university,

    required this.degree,
    required this.fieldOfStudy,
    required this.startYear,
    required this.endYear,
    required this.universityId,
  });

  final String university;
  final int universityId;
  final String degree;
  final String fieldOfStudy;
  final int? startYear;
  final int? endYear;

  @override
  List<Object?> get props => [
    university,
    degree,
    fieldOfStudy,
    startYear,
    endYear,
    universityId
  ];
}

class ContactInfo extends Equatable {
  final String handle, platform, url;

  const ContactInfo({
    required this.handle,
    required this.platform,
    required this.url,
  });
  @override
  List<Object?> get props => [handle, platform, url];
}

class EditProfileState extends Equatable {
  const EditProfileState({
    this.fullName = '',
    this.bio = '',
    this.aboutMe = '',
    this.accountType = 'Student',
    this.location = '',
    this.skills = const [],
    this.academicExperiences = const [],
    this.hasChanges = false,
    this.contactInfos = const [],
    this.hasBasicInfoChanges = false,
    this.hasAccountTypeChanges = false,
    this.hasAboutMeChanges = false,
    this.hasSkillsChanges = false,
    this.hasAcademicChanges = false,
    this.hasContactInfoChanges = false,
  });

  final String fullName;
  final String bio;
  final String aboutMe;
  final String accountType;
  final String location;
  final List<String> skills;
  final List<ContactInfo> contactInfos;
  final List<AcademicExperience> academicExperiences;
  final bool hasChanges;
  final bool hasBasicInfoChanges;
  final bool hasAccountTypeChanges;
  final bool hasAboutMeChanges;
  final bool hasSkillsChanges;
  final bool hasAcademicChanges;
  final bool hasContactInfoChanges;

  EditProfileState copyWith({
    String? fullName,
    String? bio,
    String? aboutMe,
    String? accountType,
    String? location,
    List<String>? skills,
    List<AcademicExperience>? academicExperiences,
    bool? hasChanges,
    List<ContactInfo>? contactInfos,
    bool? hasBasicInfoChanges,
    bool? hasAccountTypeChanges,
    bool? hasAboutMeChanges,
    bool? hasSkillsChanges,
    bool? hasAcademicChanges,
    bool? hasContactInfoChanges,
  }) {
    return EditProfileState(
      fullName: fullName ?? this.fullName,
      bio: bio ?? this.bio,
      aboutMe: aboutMe ?? this.aboutMe,
      accountType: accountType ?? this.accountType,
      location: location ?? this.location,
      skills: skills ?? this.skills,
      academicExperiences: academicExperiences ?? this.academicExperiences,
      hasChanges: hasChanges ?? this.hasChanges,
      contactInfos: contactInfos ?? this.contactInfos,
      hasBasicInfoChanges: hasBasicInfoChanges ?? this.hasBasicInfoChanges,
      hasAccountTypeChanges:
          hasAccountTypeChanges ?? this.hasAccountTypeChanges,
      hasAboutMeChanges: hasAboutMeChanges ?? this.hasAboutMeChanges,
      hasSkillsChanges: hasSkillsChanges ?? this.hasSkillsChanges,
      hasAcademicChanges: hasAcademicChanges ?? this.hasAcademicChanges,
      hasContactInfoChanges:
          hasContactInfoChanges ?? this.hasContactInfoChanges,
    );
  }

  @override
  List<Object?> get props => [
    fullName,
    bio,
    aboutMe,
    accountType,
    location,
    skills,
    academicExperiences,
    hasChanges,
    contactInfos,
    hasBasicInfoChanges,
    hasAccountTypeChanges,
    hasAboutMeChanges,
    hasSkillsChanges,
    hasAcademicChanges,
    hasContactInfoChanges,
  ];
}
