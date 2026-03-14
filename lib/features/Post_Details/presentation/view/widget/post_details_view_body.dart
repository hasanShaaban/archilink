import 'package:archilink/core/utils/fakers.dart';
import 'package:archilink/features/Post/presentation/view/post.dart';
import 'package:archilink/features/Post_Details/domain/entity/comment_entity.dart';
import 'package:archilink/features/Post_Details/presentation/manager/bloc/post_details_bloc.dart';
import 'package:archilink/features/Post_Details/presentation/view/widget/comment.dart';
import 'package:archilink/features/Post_Details/presentation/view/widget/post_details_app_bar.dart';
import 'package:archilink/features/Post_Details/presentation/view/widget/sort_comments_buttons.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PostDetailsViewBody extends StatefulWidget {
  const PostDetailsViewBody({super.key, this.onReply});
  final Function(CommentEntity)? onReply;

  @override
  State<PostDetailsViewBody> createState() => _PostDetailsViewBodyState();
}

class _PostDetailsViewBodyState extends State<PostDetailsViewBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    const threshold = 200;

    if (maxScroll - currentScroll <= threshold) {
      context.read<PostDetailsBloc>().add(LoadMoreComments());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocBuilder<PostDetailsBloc, PostDetailsState>(
      builder: (context, state) {
        List<CommentEntity> fakeComments = fakeCommentEntities(count: 5);
        return RefreshIndicator(
          onRefresh: () async {
            context.read<PostDetailsBloc>().add(RefreshPostDetails());
            context.read<PostDetailsBloc>().add(LoadComments());
          },
          child: CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(child: PostDetailsAppBar(lang: lang)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: Skeletonizer(
                    enabled: state.isLoadingPost,
                    child: Post(
                      entity: state.post,
                      lang: lang,
                      width: width,
                      height: height,
                      withDetails: true,
                    ),
                  ),
                ),
              ),

              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyHeaderDelegate(
                  height: 56,
                  child: Column(
                    children: [
                      Divider(
                        height: 0,
                        thickness: 1,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: SortCommentsButton(lang: lang),
                      ),
                      Divider(
                        height: 0,
                        thickness: 1,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ListView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: state.isLoadingComments
                      ? fakeComments.length
                      : state.comments.length,
                  itemBuilder: (context, index) {
                    return Skeletonizer(
                      enabled: state.isLoadingComments,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Comment(
                          onReply: widget.onReply,
                          key: state.isLoadingComments
                              ? null
                              : ValueKey(state.comments[index].id),
                          width: width,
                          entity: state.isLoadingComments
                              ? fakeComments[index]
                              : state.comments[index],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: state.isLoadingMoreComments
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _StickyHeaderDelegate({required this.child, this.height = 56});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox(height: height, child: child);
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) =>
      oldDelegate.child != child || oldDelegate.height != height;
}
