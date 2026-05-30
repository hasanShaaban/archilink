import 'package:archilink/core/functions/snack_bar_builder.dart';
import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/fakers.dart';
import 'package:archilink/features/Post/presentation/view/post.dart';
import 'package:archilink/features/Post_Details/domain/entity/comment_entity.dart';
import 'package:archilink/features/Post_Details/domain/entity/comment_node.dart';
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
  int _lastTopLevelCount = 0;

  Future<void> _showCommentOptionsMenu(
    CommentEntity comment,
    Offset position,
  ) async {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final selected = await showMenu<String>(
      color: AppColorsFromTheme.grayForTheme(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(position.dx, position.dy, 0, 0),
        Offset.zero & overlay.size,
      ),
      items: const [
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline),
              SizedBox(width: 8),
              Text('Delete'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'report',
          child: Row(
            children: [
              Icon(Icons.flag_outlined),
              SizedBox(width: 8),
              Text('Report'),
            ],
          ),
        ),
      ],
    );

    if (!mounted || selected == null) return;

    if (selected == 'delete') {
      context.read<PostDetailsBloc>().add(
            DeleteComment(
              commentId: comment.id,
              parentId: comment.parentId,
            ),
          );
      return;
    }

    if (selected == 'report') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Report selected for comment #${comment.id}')),
      );
    }
  }

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
    return BlocConsumer<PostDetailsBloc, PostDetailsState>(
      listener: (context, state) {
        if (state.failure != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            appSnackBar(context, state.failure!, state.failure!.message),
          );
        }
        if (state.comments.length > _lastTopLevelCount &&
            state.comments.isNotEmpty &&
            state.comments.first.isPending) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
          }
        }
        _lastTopLevelCount = state.comments.length;
      },
      builder: (context, state) {
        List<CommentNode> fakeComments = fakeCommentEntities(count: 5);
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
                    effect: ShimmerEffect(
                      highlightColor: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.5),
                      baseColor: AppColorsFromTheme.grayForTheme(
                        context,
                      ).withOpacity(0.5),
                    ),
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
                      effect: ShimmerEffect(
                        highlightColor: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.5),
                        baseColor: AppColorsFromTheme.grayForTheme(
                          context,
                        ).withOpacity(0.5),
                      ),
                      enabled: state.isLoadingComments,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Comment(
                          onReply: widget.onReply,
                          onLongPress: (comment, position) {
                            _showCommentOptionsMenu(comment, position);
                          },
                          key: state.isLoadingComments
                              ? null
                              : ValueKey(state.comments[index].comment.id),
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
