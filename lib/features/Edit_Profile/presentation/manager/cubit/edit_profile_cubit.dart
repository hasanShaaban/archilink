import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(const EditProfileState());

  void initializeFromProfile(ProfileEntity profile) {
    final details = profile.details;
    final accountType = _normalizeAccountType(profile.role);
    final location = _buildLocation(details.city, details.country);
    emit(
      EditProfileState(
        fullName: profile.name,
        bio: profile.bio ?? '',
        aboutMe: details.aboutMe ?? '',
        accountType: accountType,
        location: location,
        skills: details.skills.map((s) => s.name).toList(),
        academicExperiences: details.academicExperiences
            .map(
              (e) => AcademicExperience(
                university: e.university,
                degree: e.degree,
                fieldOfStudy: e.fieldOfStudy,
                startYear: e.startYear,
                endYear: e.endYear,
              ),
            )
            .toList(),
        hasChanges: false,
      ),
    );
  }

  String _normalizeAccountType(String role) {
    final cleaned = role.trim();
    if (cleaned.isEmpty) return 'Student';
    final lower = cleaned.toLowerCase();
    if (lower.contains('mentor')) return 'Mentor';
    if (lower.contains('student')) return 'Student';
    return 'Student';
  }

  String _buildLocation(String? city, String? country) {
    final parts = <String>[];
    if (city != null && city.trim().isNotEmpty) {
      parts.add(city.trim());
    }
    if (country != null && country.trim().isNotEmpty) {
      parts.add(country.trim());
    }
    return parts.join(', ');
  }

  void updateFullName(String value) {
    emit(state.copyWith(fullName: value, hasChanges: true));
  }

  void updateBio(String value) {
    emit(state.copyWith(bio: value, hasChanges: true));
  }

  void updateAboutMe(String value) {
    emit(state.copyWith(aboutMe: value, hasChanges: true));
  }

  void updateAccountType(String value) {
    emit(state.copyWith(accountType: value, hasChanges: true));
  }

  void updateLocation(String value) {
    emit(state.copyWith(location: value, hasChanges: true));
  }

  void addSkill(String skill) {
    final cleaned = skill.trim();
    if (cleaned.isEmpty) return;
    final exists = state.skills.any(
      (s) => s.toLowerCase() == cleaned.toLowerCase(),
    );
    if (exists) return;
    final updated = List<String>.from(state.skills)..add(cleaned);
    emit(state.copyWith(skills: updated, hasChanges: true));
  }

  void removeSkill(int index) {
    if (index < 0 || index >= state.skills.length) return;
    final updated = List<String>.from(state.skills)..removeAt(index);
    emit(state.copyWith(skills: updated, hasChanges: true));
  }

  void addAcademicExperience(AcademicExperience experience) {
    final updated = List<AcademicExperience>.from(state.academicExperiences)
      ..add(experience);
    emit(state.copyWith(academicExperiences: updated, hasChanges: true));
  }

  void removeAcademicExperience(int index) {
    if (index < 0 || index >= state.academicExperiences.length) return;
    final updated = List<AcademicExperience>.from(state.academicExperiences)
      ..removeAt(index);
    emit(state.copyWith(academicExperiences: updated, hasChanges: true));
  }
}
