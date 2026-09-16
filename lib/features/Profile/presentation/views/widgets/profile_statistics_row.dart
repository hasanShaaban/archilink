import 'package:archilink/features/Profile/presentation/views/widgets/profile_statistics_column.dart';
import 'package:flutter/material.dart';

class ProfileStatisticsRow extends StatelessWidget {
  const ProfileStatisticsRow({
    super.key,
    required this.followers,
    required this.following,
    required this.posts,
    required this.projects,
    this.isStore = false,
  });
  final int followers;
  final int following;
  final int posts;
  final int projects;
  /// When true, only shows Products and Followers (store profile layout).
  final bool isStore;

  @override
  Widget build(BuildContext context) {
    if (isStore) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 49),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ProfileStatisticsColumn(title: 'Products', count: '$posts'),
            ProfileStatisticsColumn(title: 'Followers', count: '$followers'),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 49),
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
