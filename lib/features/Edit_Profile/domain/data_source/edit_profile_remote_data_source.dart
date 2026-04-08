import 'package:archilink/features/Edit_Profile/domain/entity/universities_response_entity.dart';

abstract class EditProfileRemoteDataSource {
  Future<UniversitiesResponseEntity> getUniversities();
}