import 'package:archilink/features/Profile/presentation/views/widgets/profile_statistics_column.dart';
import 'package:flutter/material.dart';

class ProfileStatisticsRow extends StatelessWidget {
  const ProfileStatisticsRow({
    super.key,
    required this.followers,
    required this.following,
    required this.posts,
    required this.projects,
  });
  final int followers;
  final int following;
  final int posts;
  final int projects;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 49),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ProfileStatisticsColumn(title: 'Posts', count: '$posts'),
          ProfileStatisticsColumn(title: 'Projects', count: '$projects'),
          ProfileStatisticsColumn(title: 'Followers', count: '$followers'),
          ProfileStatisticsColumn(title: 'Following', count: '$following'),
        ],
      ),
    );
  }
}
