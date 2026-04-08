import 'package:archilink/features/Edit_Profile/domain/entity/university_entity.dart';

class UniversitiesResponseEntity {
  final String status;
  final String message;
  final List<UniversityEntity> universities;

  const UniversitiesResponseEntity({
    required this.status,
    required this.message,
    required this.universities,
  });
}
