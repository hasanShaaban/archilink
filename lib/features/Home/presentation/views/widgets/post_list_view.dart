import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/fakers.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Post/presentation/view/post.dart';
import 'package:archilink/features/Post_Details/presentation/view/post_details_view.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PostListView extends StatefulWidget {
  const PostListView({
    super.key,
    required this.lang,
    required this.width,
    required this.height,
    required this.posts,
    required this.isInitialLoading,
    required this.isLoadingMore,
    required this.onLoadMore,
    this.failureMessage,
  });

  final S lang;
  final double width;
  final double height;
  final List<PostEntity> posts;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final String? failureMessage;
  final VoidCallback onLoadMore;

  @override
  State<PostListView> createState() => _PostListViewState();
}

class _PostListViewState extends State<PostListView> {
  ScrollController? _controller;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller = PrimaryScrollController.of(context);
      _controller!.addListener(_onScroll);
    });
    super.initState();
  }

  void _onScroll() {
    if (_controller == null || !_controller!.hasClients) return;
    if (_controller!.position.pixels >=
        _controller!.position.maxScrollExtent - 150) {
      widget.onLoadMore();
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.failureMessage != null) {
      return Center(child: Text(widget.failureMessage!));
    }
    final bool isSkeleton = widget.isInitialLoading && widget.posts.isEmpty;
    final List<PostEntity> posts = isSkeleton
        ? List<PostEntity>.generate(5, (index) => fakePostEntity(id: index))
        : widget.posts;
    if (!isSkeleton && widget.posts.isEmpty) {
      return Center(
        child: Text('No posts yet.', style: AppTextStyle.interMedium16),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: posts.length + 1,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (index == posts.length) {
          if (widget.isLoadingMore) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return const SizedBox.shrink(); // no more pages, render nothing
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Skeletonizer(
                effect: ShimmerEffect(
                  highlightColor: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.5),
                  baseColor: AppColorsFromTheme.grayForTheme(
                    context,
                  ).withOpacity(0.5),
                ),
                enabled: isSkeleton,
                child: Post(
                  entity: posts[index],
                  lang: widget.lang,
                  width: widget.width,
                  height: widget.height,
                  onPostTapped: () {
                    isSkeleton
                        ? null
                        : Navigator.of(context, rootNavigator: true).pushNamed(
                            PostDetailsView.name,
                            arguments: {'post': posts[index]},
                          );
                  },
                  withDetails: false,
                ),
              ),
            ),
            Divider(height: 1, color: Theme.of(context).colorScheme.secondary),
          ],
        );
      },
    );
  }
}
