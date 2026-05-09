import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/current_user_cubit.dart';
import 'package:archilink/features/Main/presentation/manager/main_tab_controller.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_user_image.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_username_and_date.dart';
import 'package:archilink/features/Post_Details/domain/repo/post_details_repo.dart';
import 'package:archilink/features/Post_Details/presentation/view/post_details_view.dart';
import 'package:archilink/features/Profile/presentation/manager/bloc/profile_bloc.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/profile_cubit.dart';
import 'package:archilink/features/Profile/presentation/views/user_profile_view.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/liked_posts_cubit.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/liked_posts_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class LikedPostsListView extends StatefulWidget {
  const LikedPostsListView({super.key});

  @override
  State<LikedPostsListView> createState() => _LikedPostsListViewState();
}

class _LikedPostsListViewState extends State<LikedPostsListView> {
  late final ScrollController _scrollController;
  int? _loadingPostId;

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
    final cubit = context.read<LikedPostsCubit>();
    final state = cubit.state;

    if (!state.hasMoreLikedPosts ||
        state.isLoadingLikedPosts ||
        state.isLoadingMoreLikedPosts) {
      return;
    }

    final threshold = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.position.pixels >= threshold) {
      cubit.fetchLikedPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return BlocBuilder<LikedPostsCubit, LikedPostsState>(
      builder: (context, state) {
        if (state.isLoadingLikedPosts && !state.hasLikedPostsData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.likedPostsErrorMessage != null && !state.hasLikedPostsData) {
          return Center(
            child: Text(
              state.likedPostsErrorMessage!,
              style: AppTextStyle.interMedium12,
              textAlign: TextAlign.center,
            ),
          );
        }

        if (!state.hasLikedPostsData) {
          return const Center(
            child: Text(
              'No liked posts yet',
              style: AppTextStyle.interMedium12,
            ),
          );
        }

        return ListView.separated(
          controller: _scrollController,
          itemBuilder: (context, index) {
            if (index == state.likedPosts.length) {
              if (!state.hasMoreLikedPosts) return const SizedBox.shrink();
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final likedPostItem = state.likedPosts[index];
            final likedPost = likedPostItem.entity;
            final isOpeningPost = _loadingPostId == likedPost.id;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
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
                              myUsername == likedPost.owner.username;
                          if (isMine) {
                            context.read<ProfileCubit>().getPersonlProfile();
                            BlocProvider.of<ProfileBloc>(
                              context,
                            ).add(LoadInitialProfilePosts());
                            sl<MainTabController>().setIndex(2);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            return;
                          }
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pushNamed(UserProfileView.name);
                          context.read<ProfileCubit>().getUserProfile(
                            likedPost.owner.username,
                          );
                          BlocProvider.of<ProfileBloc>(context).add(
                            LoadInitialProfilePosts(
                              username: likedPost.owner.username,
                            ),
                          );
                        },
                        child: PostUserImage(
                          width: width,
                          imageURL: likedPost.owner.profilePictureUrl,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: width * 34 / 402 / 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: PostUserNameAndDate(
                                      withDetails: true,
                                      date: DateTime.now().toIso8601String(),
                                      owner: likedPost.owner,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                likedPost.body,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SvgPicture.asset(Assets.assetsIconsFilldLike),
                                  SizedBox(width: 16),
                                  TextButton(
                                    onPressed: isOpeningPost
                                        ? null
                                        : () => _openPostDetails(likedPost.id),
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(10),
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
                                          SizedBox(width: 8),
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
                                          SizedBox(width: 8),
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
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => Divider(),
          itemCount:
              state.likedPosts.length + (state.hasMoreLikedPosts ? 1 : 0),
        );
      },
    );
  }

  Future<void> _openPostDetails(int postId) async {
    setState(() => _loadingPostId = postId);
    final result = await sl<PostDetailsRepo>().refreshPostDetails(postId);
    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() => _loadingPostId = null);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.message)));
      },
      (post) {
        setState(() => _loadingPostId = null);
        Navigator.of(
          context,
          rootNavigator: true,
        ).pushNamed(PostDetailsView.name, arguments: {'post': post});
      },
    );
  }
}
