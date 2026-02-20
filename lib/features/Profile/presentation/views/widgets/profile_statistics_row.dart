
import 'package:archilink/features/Profile/domain/entity/follow_state_entity.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_statistics_column.dart';
import 'package:flutter/material.dart';

class ProfileStatisticsRow extends StatelessWidget {
  const ProfileStatisticsRow({
    super.key, this.statisticsData,
  });

  final FollowStatsEntity? statisticsData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 49),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ProfileStatisticsColumn(title: 'Posts', count: '50',),
          ProfileStatisticsColumn(title: 'Projects', count: '80',),
          ProfileStatisticsColumn(title: 'Followers', count: statisticsData != null ? '${statisticsData!.followerCount}' : '0',),
          ProfileStatisticsColumn(title: 'Following', count: statisticsData != null ? '${statisticsData!.followedCount}' : '0',),
        ],
      ),
    );
  }
}


