import 'package:archilink/features/Edit_Profile/domain/entity/university_entity.dart';

class UniversityModel extends UniversityEntity {
  const UniversityModel({
    required super.id,
    required super.name,
  });

  factory UniversityModel.fromJson(Map<String, dynamic> json) {
    return UniversityModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
