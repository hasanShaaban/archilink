

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
  // UserProfileEntity? getProfileData();//TODO: implement this to get the saved data from local storage
}
