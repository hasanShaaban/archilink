import 'package:archilink/features/Profile/data/model/follow_state_model.dart';
import 'package:archilink/features/Profile/data/model/profile_model.dart';
import 'package:archilink/features/Profile/domain/entity/user_profile_entity.dart';

class UserProfileResponseModel {
  final ProfileModel profile;
  final FollowStatsModel followStats;

  const UserProfileResponseModel({
    required this.profile,
    required this.followStats,
  });

  factory UserProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return UserProfileResponseModel(
      profile: ProfileModel.fromJson(
        json['profile_data'] as Map<String, dynamic>,
      ),
      followStats: FollowStatsModel.fromJson(
        json['follow_data'] as Map<String, dynamic>,
      ),
    );
  }
  factory UserProfileResponseModel.fromLocalDataSource(
    Map<String, dynamic> data,
  ) {
    return UserProfileResponseModel(
      profile: ProfileModel(
        name: data['name'],
        username: data['username'],
        email: data['email'],
        bio: data['bio'],
        location: data['location'],
        profilePictureUrl: data['profilePictureUrl'],
      ),
      followStats: FollowStatsModel(
        followedCount: data['followers'],
        followerCount: data['following'],
      ),
    );
  }

  UserProfileEntity toEntity() {
    return UserProfileEntity(
      profile: profile.toEntity(),
      followStats: followStats.toEntity(),
    );
  }
}
