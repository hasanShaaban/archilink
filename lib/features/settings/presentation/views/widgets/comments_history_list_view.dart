import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/current_user_cubit.dart';
import 'package:archilink/features/Main/presentation/manager/main_tab_controller.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_body.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_user_image.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_username_and_date.dart';
import 'package:archilink/features/Post_Details/domain/repo/post_details_repo.dart';
import 'package:archilink/features/Post_Details/presentation/view/post_details_view.dart';
import 'package:archilink/features/Profile/presentation/manager/bloc/profile_bloc.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/profile_cubit.dart';
import 'package:archilink/features/Profile/presentation/views/user_profile_view.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/comments_history_cubit.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/comments_history_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class CommentsHistoryListView extends StatefulWidget {
  const CommentsHistoryListView({super.key});

  @override
  State<CommentsHistoryListView> createState() =>
      _CommentsHistoryListViewState();
}

class _CommentsHistoryListViewState extends State<CommentsHistoryListView> {
  late final ScrollController _scrollController;
  int? _loadingCommentId;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final cubit = context.read<CommentsHistoryCubit>();
    final state = cubit.state;

    if (!state.hasMoreComments ||
        state.isLoadingComments ||
        state.isLoadingMoreComments) {
      return;
    }

    final threshold = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.position.pixels >= threshold) {
      cubit.fetchCommentsHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return BlocBuilder<CommentsHistoryCubit, CommentsHistoryState>(
      builder: (context, state) {
        if (state.isLoadingComments && !state.hasCommentsData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.commentsErrorMessage != null && !state.hasCommentsData) {
          return Center(
            child: Text(
              state.commentsErrorMessage!,
              style: AppTextStyle.interMedium12,
              textAlign: TextAlign.center,
            ),
          );
        }

        if (!state.hasCommentsData) {
          return const Center(
            child: Text(
              'No comments history yet',
              style: AppTextStyle.interMedium12,
            ),
          );
        }

        return ListView.separated(
          controller: _scrollController,
          itemBuilder: (context, index) {
            if (index == state.comments.length) {
              if (!state.hasMoreComments) return const SizedBox.shrink();
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final comment = state.comments[index];
            final post = comment.post;
            final isOpeningPost = _loadingCommentId == comment.id;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      final myUsername = context
                          .read<CurrentUserCubit>()
                          .state
                          .username;
                      final isMine =
                          myUsername != null &&
                          myUsername == post.owner.username;
                      if (isMine) {
                        context.read<ProfileCubit>().getPersonlProfile();
                        BlocProvider.of<ProfileBloc>(
                          context,
                        ).add(LoadInitialProfilePosts());
                        sl<MainTabController>().setIndex(2);
                        Navigator.pop(context);
                        return;
                      }
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushNamed(UserProfileView.name);
                      context.read<ProfileCubit>().getUserProfile(
                        post.owner.username,
                      );
                      BlocProvider.of<ProfileBloc>(context).add(
                        LoadInitialProfilePosts(username: post.owner.username),
                      );
                    },
                    child: PostUserImage(
                      width: width,
                      imageURL: post.owner.profilePictureUrl,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: width * 34 / 402 / 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PostUserNameAndDate(
                            withDetails: false,
                            date: comment.createdAt,
                            owner: post.owner,
                          ),
                          const SizedBox(height: 8),

                          const SizedBox(height: 8),
                          PostBody(
                            width: width,
                            height: MediaQuery.of(context).size.height,
                            withDetails: false,
                            body: post.body,
                            mediaItems: post.mediaItems,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(19),
                              border: Border.all(
                                color: AppColorsFromTheme.lightGray(context),
                              ),
                              color: AppColorsFromTheme.grayForTheme(
                                context,
                              ).withOpacity(0.7),
                            ),

                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PostUserImage(
                                  width: width,
                                  imageURL: comment.owner.profilePictureUrl,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comment.owner.name,
                                        style: AppTextStyle.interMedium14,
                                      ),
                                      Text(
                                        comment.body,
                                        softWrap: true,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyle.mallannaRegular14
                                            .copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: isOpeningPost
                                    ? null
                                    : () => _openPostDetails(
                                        postId: post.id,
                                        commentId: comment.id,
                                      ),
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (isOpeningPost) ...[
                                      SizedBox(
                                        height: 14,
                                        width: 14,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'loading...',
                                        style: AppTextStyle.interMedium12
                                            .copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                            ),
                                      ),
                                    ] else ...[
                                      Text(
                                        'go to post',
                                        style: AppTextStyle.interMedium12
                                            .copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                            ),
                                      ),
                                      const SizedBox(width: 8),
                                      SvgPicture.asset(
                                        Assets.assetsIconsRightArrow,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: state.comments.length + (state.hasMoreComments ? 1 : 0),
        );
      },
    );
  }

  Future<void> _openPostDetails({
    required int postId,
    required int commentId,
  }) async {
    setState(() => _loadingCommentId = commentId);
    final result = await sl<PostDetailsRepo>().refreshPostDetails(postId);
    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() => _loadingCommentId = null);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.message)));
      },
      (post) {
        setState(() => _loadingCommentId = null);
        Navigator.of(
          context,
          rootNavigator: true,
        ).pushNamed(PostDetailsView.name, arguments: {'post': post});
      },
    );
  }
}
