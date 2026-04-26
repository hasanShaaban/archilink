import 'package:archilink/features/settings/presentation/views/followers_and_following_view.dart';
import 'package:archilink/features/settings/presentation/views/widgets/user_tile.dart';
import 'package:flutter/material.dart';

class UsersListView extends StatelessWidget {
  const UsersListView({
    super.key,
    required this.users,
    required this.actionBuilder,
  });

  final List<MockUser> users;
  final Widget Function(MockUser user) actionBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final user = users[index];
        return UserTile(user: user, action: actionBuilder(user));
      },
      separatorBuilder: (_, __) => Divider(height: 1),
      itemCount: users.length,
    );
  }
}