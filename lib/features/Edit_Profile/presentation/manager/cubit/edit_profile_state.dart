part of 'edit_profile_cubit.dart';

class AcademicExperience extends Equatable {
  const AcademicExperience({
    required this.university,
    required this.degree,
    required this.fieldOfStudy,
    required this.startYear,
    required this.endYear,
  });

  final String university;
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
      ];
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
  });

  final String fullName;
  final String bio;
  final String aboutMe;
  final String accountType;
  final String location;
  final List<String> skills;
  final List<AcademicExperience> academicExperiences;
  final bool hasChanges;

  EditProfileState copyWith({
    String? fullName,
    String? bio,
    String? aboutMe,
    String? accountType,
    String? location,
    List<String>? skills,
    List<AcademicExperience>? academicExperiences,
    bool? hasChanges,
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
      ];
}
