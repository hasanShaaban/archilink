import 'package:archilink/features/Profile/domain/entity/follow_state_entity.dart';

class FollowStatsModel {
  final int followedCount;
  final int followerCount;

  const FollowStatsModel({
    required this.followedCount,
    required this.followerCount,
  });

  factory FollowStatsModel.fromJson(Map<String, dynamic> json) {
    return FollowStatsModel(
      followedCount: json['followed_count'] as int,
      followerCount: json['follower_count'] as int,
    );
  }

  FollowStatsEntity toEntity() {
    return FollowStatsEntity(
      followedCount: followedCount,
      followerCount: followerCount,
    );
  }
}
