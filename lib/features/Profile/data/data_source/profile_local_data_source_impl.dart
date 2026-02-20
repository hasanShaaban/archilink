import 'package:archilink/core/storage/local_storage.dart';
import 'package:archilink/features/Profile/data/model/user_profile_model.dart';
import 'package:archilink/features/Profile/domain/data_source/profile_local_data_source.dart';
import 'package:archilink/features/Profile/domain/entity/user_profile_entity.dart';

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final LocalStorage storage;
  static const _profileDataKey = 'ProfileData';
  
  ProfileLocalDataSourceImpl(this.storage);


  @override
  UserProfileEntity? getProfileData() {
    final rawData = storage.read(_profileDataKey);
    if(rawData != null){
      final data = Map<String, dynamic>.from(rawData as Map);
      return UserProfileResponseModel.fromLocalDataSource(data).toEntity();
    }
    return null;
  }

  @override
  Future<void> saveProfileData({
    required String name,
    required String username,
    required String email,
    String? bio,
    String? location,
    String? profilePictureUrl,
    required int followers,
    required int following,
  }) async {
    Map<String, dynamic> data = {
      'name': name,
      'username': username,
      'email': email,
      'bio': bio,
      'location': location,
      'profilePictureUrl': profilePictureUrl,
      'followers': followers,
      'following':following
    };
    await storage.write(_profileDataKey, data);
  }
}
