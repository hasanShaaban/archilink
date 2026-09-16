import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileTabBarDelegate extends SliverPersistentHeaderDelegate {
  const ProfileTabBarDelegate({this.firstTabLabel = 'Posts'});

  /// Label for the first tab. Defaults to 'Posts'; pass 'Products' for store profiles.
  final String firstTabLabel;

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
      child: Skeleton.keep(
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
              Tab(text: firstTabLabel),
              Tab(text: 'Details'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant ProfileTabBarDelegate oldDelegate) {
    return oldDelegate.firstTabLabel != firstTabLabel;
  }
}
