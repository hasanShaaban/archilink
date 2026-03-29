import 'dart:convert';
import 'dart:developer';

import 'package:archilink/core/storage/local_storage.dart';
import 'package:archilink/features/Profile/data/model/profile_model.dart';
import 'package:archilink/features/Profile/domain/data_source/profile_local_data_source.dart';

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final LocalStorage storage;
  static const _profileDataKey = 'ProfileData';

  ProfileLocalDataSourceImpl(this.storage);

  @override
  Future<void> saveProfileData(Map<String, dynamic> profileData) async {
    await storage.write(_profileDataKey, jsonEncode(profileData));
  }

  @override
  ProfileModel? getCachedProfile() {
    final jsonString = storage.read(_profileDataKey);
    if (jsonString == null) return null;
    log("jsonString: $jsonString");
    final decodedData = jsonDecode(jsonString) as Map<String, dynamic>;
    log("decodedData: $decodedData");

    return ProfileModel.fromJson(decodedData['data']);
  }
}


