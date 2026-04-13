class EditProfileRequestBody {
  final String? fullName;
  final String? bio;
  final String? country;
  final String? city;
  final List<String>? skills;
  final List<AcademicExperianceRequestBody>? academicExperiences;
  final List<ContactInfoRequestBody>? contactInfo;

  EditProfileRequestBody({
    required this.fullName,
    required this.bio,
    required this.country,
    required this.city,
    required this.academicExperiences,
    required this.contactInfo,
    required this.skills,
  });
}

class AcademicExperianceRequestBody {
  final int university;
  final String degree;
  final String fieldOfStudy;
  final int startDate;
  final int? endDate;

  AcademicExperianceRequestBody({
    required this.university,
    required this.degree,
    required this.fieldOfStudy,
    required this.startDate,
    required this.endDate,
  });
}

class ContactInfoRequestBody {
  final String handel;
  final String platform;
  final String url;

  ContactInfoRequestBody({
    required this.handel,
    required this.platform,
    required this.url,
  });
}
