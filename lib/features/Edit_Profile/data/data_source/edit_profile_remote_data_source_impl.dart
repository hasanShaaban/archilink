import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/network/api_service.dart';
import 'package:archilink/features/Edit_Profile/data/model/universities_response_model.dart';
import 'package:archilink/features/Edit_Profile/domain/data_source/edit_profile_remote_data_source.dart';
import 'package:archilink/features/Edit_Profile/domain/entity/edit_profile_request_body.dart';
import 'package:archilink/features/Edit_Profile/domain/entity/universities_response_entity.dart';
import 'package:dio/dio.dart';

class EditProfileRemoteDataSourceImpl extends EditProfileRemoteDataSource {
  final ApiService apiService;

  EditProfileRemoteDataSourceImpl(this.apiService);
  @override
  Future<UniversitiesResponseEntity> getUniversities() async {
    try {
      final response = await apiService.get('utils/universities');
      final data = response.data;
      if (data == null) {
        throw ServerException(message: "Invalid data response");
      }
      return UniversitiesResponseModel.fromJson(data);
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<bool> updateProfile(EditProfileRequestBody requestBody) async {
    try {
      final body = <String, dynamic>{};

      if (requestBody.fullName != null) body['name'] = requestBody.fullName;
      if (requestBody.bio != null) body['bio'] = requestBody.bio;
      if (requestBody.country != null) body['country'] = requestBody.country;
      if (requestBody.city != null) body['city'] = requestBody.city;

      if (requestBody.skills != null) {
        body['skills'] = requestBody.skills;
      }

      if (requestBody.academicExperiences != null) {
        body['academic_experiences'] = requestBody.academicExperiences!
            .map(
              (e) => {
                'university_id': e.university,
                'degree': e.degree,
                'field_of_study': e.fieldOfStudy,
                'start_year': e.startDate,
                'graduation_year': e.endDate,
              },
            )
            .toList();
      }

      if (requestBody.contactInfo != null) {
        body['contact_info'] = requestBody.contactInfo!
            .map(
              (e) => {
                'platform': e.platform,
                'handle': e.handel, // double check key name with backend
                'url': e.url,
              },
            )
            .toList();
      }
      final response = await apiService.patch(
        'profile/update-profile',
        body: body,
      );
      final data = response.data;
      if (data == null) {
        throw ServerException(message: "Invalid data response");
      }
      return data['status'] == 'success' ? true : false;
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }
}
