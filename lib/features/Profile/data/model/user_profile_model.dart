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
    final data = json['data'] as Map<String, dynamic>;

    return UserProfileResponseModel(
      profile: ProfileModel.fromJson(
        data['profile_data'] as Map<String, dynamic>,
      ),
      followStats: FollowStatsModel.fromJson(
        data['follow_data'] as Map<String, dynamic>,
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
