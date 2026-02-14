
import 'package:archilink/features/Profile/domain/entity/follow_state_entity.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';

class UserProfileEntity {
  final ProfileEntity profile;
  final FollowStatsEntity followStats;

  const UserProfileEntity({
    required this.profile,
    required this.followStats,
  });
}