import 'package:archilink/core/utils/temp.dart';
import 'package:archilink/core/widgets/post.dart';
import 'package:archilink/features/Post/presentation/view/widget/comment.dart';
import 'package:archilink/features/Post/presentation/view/widget/post_details_app_bar.dart';
import 'package:archilink/features/Post/presentation/view/widget/sort_comments_buttons.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';

class PostDetailsViewBody extends StatelessWidget {
  const PostDetailsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: PostDetailsAppBar(lang: lang)),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverToBoxAdapter(
            child: Post(
              entity: null,
              lang: lang,
              width: width,
              height: height,
              withDetails: true,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Divider(
            height: 0,
            thickness: 1,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: _StickyHeaderDelegate(
            height: 56,
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: SortCommentsButton(lang: lang),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Divider(
            height: 0,
            thickness: 1,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Comment(width: width, comment: commentsTree[index],),
            );
          }, childCount: commentsTree.length),
        ),
      ],
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _StickyHeaderDelegate({
    required this.child,
    this.height = 56, // <— choose a value slightly larger than your button
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      height: height,
      child: child,
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) =>
      oldDelegate.child != child || oldDelegate.height != height;
}
