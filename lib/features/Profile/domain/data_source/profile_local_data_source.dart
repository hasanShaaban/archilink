import 'package:archilink/features/Profile/domain/entity/user_profile_entity.dart';

abstract class ProfileLocalDataSource {
  Future<void> saveProfileData({
    required String name,
    required String username,
    required String email,
    String? bio,
    String? location,
    String? profilePictureUrl,
    required int followers,
    required int following,
  });
  UserProfileEntity? getProfileData();
}
