import 'dart:developer';

import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(const EditProfileState());

  String _initialFullName = '';
  String _initialBio = '';
  String _initialAboutMe = '';
  String _initialAccountType = 'Student';
  String _initialLocation = '';
  List<String> _initialSkills = const [];
  List<AcademicExperience> _initialAcademicExperiences = const [];
  List<ContactInfo> _initialContactInfos = const [];

  void initializeFromProfile(ProfileEntity profile) {
    final details = profile.details;
    final accountType = _normalizeAccountType(profile.role);
    final location = _buildLocation(details.city, details.country);
    final skills = details.skills.map((s) => s.name).toList();
    final academicExperiences = details.academicExperiences
        .map(
          (e) => AcademicExperience(
            universityId: -1,
            university: e.university,
            degree: e.degree,
            fieldOfStudy: e.fieldOfStudy,
            startYear: e.startYear,
            endYear: e.endYear,
          ),
        )
        .toList();
    final contactInfos = details.contactInfo
        .map(
          (c) => ContactInfo(
            handle: c.username,
            platform: c.platform,
            url: c.url!,
          ),
        )
        .toList();

    _initialFullName = profile.name;
    _initialBio = profile.bio ?? '';
    _initialAboutMe = details.aboutMe ?? '';
    _initialAccountType = accountType;
    _initialLocation = location;
    _initialSkills = List<String>.from(skills);
    _initialAcademicExperiences = List<AcademicExperience>.from(
      academicExperiences,
    );
    _initialContactInfos = List<ContactInfo>.from(contactInfos);

    emit(
      EditProfileState(
        fullName: _initialFullName,
        bio: _initialBio,
        aboutMe: _initialAboutMe,
        accountType: _initialAccountType,
        location: _initialLocation,
        skills: skills,
        academicExperiences: academicExperiences,
        contactInfos: contactInfos,
        hasChanges: false,
        hasBasicInfoChanges: false,
        hasAccountTypeChanges: false,
        hasAboutMeChanges: false,
        hasSkillsChanges: false,
        hasAcademicChanges: false,
        hasContactInfoChanges: false,
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
    final next = state.copyWith(
      fullName: value,
      hasBasicInfoChanges: _isBasicInfoChanged(
        fullName: value,
        bio: state.bio,
        location: state.location,
      ),
    );
    emit(_withOverallHasChanges(next));
  }

  void updateBio(String value) {
    final next = state.copyWith(
      bio: value,
      hasBasicInfoChanges: _isBasicInfoChanged(
        fullName: state.fullName,
        bio: value,
        location: state.location,
      ),
    );
    emit(_withOverallHasChanges(next));
  }

  void updateAboutMe(String value) {
    final next = state.copyWith(
      aboutMe: value,
      hasAboutMeChanges: _isTextChanged(value, _initialAboutMe),
    );
    emit(_withOverallHasChanges(next));
  }

  void updateAccountType(String value) {
    final next = state.copyWith(
      accountType: value,
      hasAccountTypeChanges: _isTextChanged(value, _initialAccountType),
    );
    emit(_withOverallHasChanges(next));
  }

  void updateLocation(String value) {
    final next = state.copyWith(
      location: value,
      hasBasicInfoChanges: _isBasicInfoChanged(
        fullName: state.fullName,
        bio: state.bio,
        location: value,
      ),
    );
    emit(_withOverallHasChanges(next));
  }

  void addSkill(String skill) {
    final cleaned = skill.trim();
    if (cleaned.isEmpty) return;
    final exists = state.skills.any(
      (s) => s.toLowerCase() == cleaned.toLowerCase(),
    );
    if (exists) return;
    final updated = List<String>.from(state.skills)..add(cleaned);
    final next = state.copyWith(
      skills: updated,
      hasSkillsChanges: !listEquals(updated, _initialSkills),
    );
    emit(_withOverallHasChanges(next));
  }

  void removeSkill(int index) {
    if (index < 0 || index >= state.skills.length) return;
    final updated = List<String>.from(state.skills)..removeAt(index);
    final next = state.copyWith(
      skills: updated,
      hasSkillsChanges: !listEquals(updated, _initialSkills),
    );
    emit(_withOverallHasChanges(next));
  }

  void addAcademicExperience(AcademicExperience experience) {
    final updated = List<AcademicExperience>.from(state.academicExperiences)
      ..add(experience);
    final next = state.copyWith(
      academicExperiences: updated,
      hasAcademicChanges: !listEquals(updated, _initialAcademicExperiences),
    );
    emit(_withOverallHasChanges(next));
  }

  void removeAcademicExperience(int index) {
    if (index < 0 || index >= state.academicExperiences.length) return;
    final updated = List<AcademicExperience>.from(state.academicExperiences)
      ..removeAt(index);
    final next = state.copyWith(
      academicExperiences: updated,
      hasAcademicChanges: !listEquals(updated, _initialAcademicExperiences),
    );
    emit(_withOverallHasChanges(next));
  }

  void updateAcademicExperience(int index, AcademicExperience experience) {
    if (index < 0 || index >= state.academicExperiences.length) return;
    final updated = List<AcademicExperience>.from(state.academicExperiences)
      ..[index] = experience;
    final next = state.copyWith(
      academicExperiences: updated,
      hasAcademicChanges: !listEquals(updated, _initialAcademicExperiences),
    );
    emit(_withOverallHasChanges(next));
  }

  void addContactInfo(ContactInfo info) {
    final updated = List<ContactInfo>.from(state.contactInfos)..add(info);
    final next = state.copyWith(
      contactInfos: updated,
      hasContactInfoChanges: !listEquals(updated, _initialContactInfos),
    );
    emit(_withOverallHasChanges(next));
  }

  void removeContactInfo(int index) {
    if (index < 0 || index >= state.contactInfos.length) return;
    final updated = List<ContactInfo>.from(state.contactInfos)..removeAt(index);
    final next = state.copyWith(
      contactInfos: updated,
      hasContactInfoChanges: !listEquals(updated, _initialContactInfos),
    );
    emit(_withOverallHasChanges(next));
  }

  void updateContactInfo(int index, ContactInfo info) {
    if (index < 0 || index >= state.contactInfos.length) return;
    final updated = List<ContactInfo>.from(state.contactInfos)..[index] = info;
    final next = state.copyWith(
      contactInfos: updated,
      hasContactInfoChanges: !listEquals(updated, _initialContactInfos),
    );
    emit(_withOverallHasChanges(next));
  }

  bool _isTextChanged(String value, String baseline) =>
      value.trim() != baseline.trim();

  bool _isBasicInfoChanged({
    required String fullName,
    required String bio,
    required String location,
  }) {
    return _isTextChanged(fullName, _initialFullName) ||
        _isTextChanged(bio, _initialBio) ||
        _isTextChanged(location, _initialLocation);
  }

  EditProfileState _withOverallHasChanges(EditProfileState next) {
    final hasChanges =
        next.hasBasicInfoChanges ||
        next.hasAccountTypeChanges ||
        next.hasAboutMeChanges ||
        next.hasSkillsChanges ||
        next.hasAcademicChanges ||
        next.hasContactInfoChanges;
    return next.copyWith(hasChanges: hasChanges);
  }

  void submit() {
    log(state.academicExperiences.first.universityId.toString());
  }
}
