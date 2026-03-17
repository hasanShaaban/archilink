import 'package:archilink/features/Profile/data/model/profile_model.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';

abstract class ProfileLocalDataSource {
  Future<void> saveProfileData(Map<String, dynamic> profileData);
  ProfileModel? getCachedProfile();
}
