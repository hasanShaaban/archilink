
import 'package:archilink/features/Home/presentation/views/widgets/featured_member_item.dart';
import 'package:archilink/features/Search/domain/entity/user_entity.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';


class ProfilesGridTab extends StatelessWidget {
  const ProfilesGridTab({
    super.key,
    required this.users,
    required this.isLoadingMore,
    required this.onLoadMore,
  });

  final List<UserEntity> users;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels >=
            notification.metrics.maxScrollExtent - 200) {
          onLoadMore();
        }
        return false;
      },
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 25,
          mainAxisSpacing: 0,
          mainAxisExtent: 194,
        ),
        itemCount: users.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= users.length) {
            return const Center(child: CircularProgressIndicator());
          }
          return FeaturedMemberItem(
            lang: S.of(context),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            user: users[index],
          );
        },
      ),
    );
  }
}
