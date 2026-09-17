import 'package:archilink/features/Profile/data/model/profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<void> saveProfileData(Map<String, dynamic> profileData);
  ProfileModel? getCachedProfile();
}
