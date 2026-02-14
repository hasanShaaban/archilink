import 'package:archilink/features/Profile/data/model/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileResponseModel> getProfile({required String username});
}