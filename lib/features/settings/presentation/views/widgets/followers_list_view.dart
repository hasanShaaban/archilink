import 'package:archilink/features/Search/domain/entity/user_entity.dart';
import 'package:archilink/features/settings/presentation/views/widgets/follower_tile.dart';
import 'package:flutter/material.dart';

class FollowersListView extends StatelessWidget {
  const FollowersListView({
    super.key,
    required this.users,
    required this.actionBuilder,
    required this.isLoadingMore,
    required this.onLoadMore,
  });

  final List<UserEntity> users;
  final Widget Function(UserEntity user) actionBuilder;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels >=
            notification.metrics.maxScrollExtent - 160) {
          onLoadMore();
        }
        return false;
      },
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          if (index == users.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final user = users[index];
          return FollowerTile(user: user, action: actionBuilder(user));
        },
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemCount: users.length + (isLoadingMore ? 1 : 0),
      ),
    );
  }
}
