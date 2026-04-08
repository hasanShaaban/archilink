import 'package:archilink/features/Edit_Profile/data/model/university_model.dart';
import 'package:archilink/features/Edit_Profile/domain/entity/universities_response_entity.dart';

class UniversitiesResponseModel extends UniversitiesResponseEntity {
  const UniversitiesResponseModel({
    required super.status,
    required super.message,
    required super.universities,
  });

  factory UniversitiesResponseModel.fromJson(Map<String, dynamic> json) {
    return UniversitiesResponseModel(
      status: json['status'] as String,
      message: json['message'] as String,
      universities: (json['data'] as List<dynamic>)
          .map((e) => UniversityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
