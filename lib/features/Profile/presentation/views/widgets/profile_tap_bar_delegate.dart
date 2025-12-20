import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class ProfileTabBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 48;

  @override
  double get maxExtent => 48;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: TabBar(
          labelPadding: EdgeInsets.symmetric(horizontal: 34),
          indicatorWeight: 1,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurface, 
          labelStyle: AppTextStyle.mallannaRegular20.copyWith(height: 1),
          indicatorSize: TabBarIndicatorSize.label,
          physics: BouncingScrollPhysics(),
          isScrollable: true,
          indicatorColor: Theme.of(context).colorScheme.primary,
          tabs: [
            Tab(text: 'Posts',),
            Tab(text: 'Details'),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
