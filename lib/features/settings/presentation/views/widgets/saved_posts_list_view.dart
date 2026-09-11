import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/current_user_cubit.dart';
import 'package:archilink/features/Main/presentation/manager/main_tab_controller.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Post/domain/entity/post_owner_entity.dart';
import 'package:archilink/features/Post/presentation/manager/cubit/post_save_cubit.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_body.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_user_image.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_username_and_date.dart';
import 'package:archilink/features/Post_Details/domain/repo/post_details_repo.dart';
import 'package:archilink/features/Post_Details/presentation/view/post_details_view.dart';
import 'package:archilink/features/Profile/presentation/manager/bloc/profile_bloc.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/profile_cubit.dart';
import 'package:archilink/features/Profile/presentation/views/user_profile_view.dart';
import 'package:archilink/features/settings/domain/entity/collection_posts_entity.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/collection_posts_cubit.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/collection_posts_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SavedPostsListView extends StatefulWidget {
  const SavedPostsListView({super.key});

  @override
  State<SavedPostsListView> createState() => _SavedPostsListViewState();
}

class _SavedPostsListViewState extends State<SavedPostsListView> {
  int? _loadingPostId;
  final Set<int> _unsavingItemIds = {};

  Future<void> _unsavePost(CollectionItemEntity item) async {
    if (_unsavingItemIds.contains(item.id)) return;

    setState(() => _unsavingItemIds.add(item.id));

    final result = await context
        .read<CollectionPostsCubit>()
        .removeItemFromCollection(itemId: item.id);

    if (!mounted) return;

    setState(() => _unsavingItemIds.remove(item.id));

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
      (success) {
        if (sl.isRegistered<PostSaveCubit>()) {
          sl<PostSaveCubit>().removeSavedPost(item.collectibleId);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post removed from collection')),
        );
      },
    );
  }

  static final _dummySkeletonPosts = [
    PostEntity(
      id: 1,
      body:
          'This is a beautifully designed modern living room. Love the lighting setup!',
      createdAt: DateTime.now(),
      owner: const PostOwnerEntity(
        id: 1,
        name: 'John Doe',
        username: 'johndoe',
        city: 'New York',
        country: 'USA',
      ),
      tags: const [],
      likesCount: 120,
      commentsCount: 45,
      likedByMe: true,
      mediaItems: const [],
    ),
    PostEntity(
      id: 2,
      body: 'Minimalist workspace inspiration.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      owner: const PostOwnerEntity(
        id: 2,
        name: 'Jane Smith',
        username: 'janesmith',
        city: 'London',
        country: 'UK',
      ),
      tags: const [],
      likesCount: 89,
      commentsCount: 12,
      likedByMe: false,
      mediaItems: const [],
    ),
    PostEntity(
      id: 3,
      body:
          'Contemporary architecture with stunning natural lighting and open spaces.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      owner: const PostOwnerEntity(
        id: 3,
        name: 'Alex Rivera',
        username: 'alexrivera',
        city: 'Berlin',
        country: 'Germany',
      ),
      tags: const [],
      likesCount: 210,
      commentsCount: 33,
      likedByMe: true,
      mediaItems: const [],
    ),
  ];

  Future<void> _openPostDetails(PostEntity post) async {
    setState(() => _loadingPostId = post.id);
    final result = await sl<PostDetailsRepo>().refreshPostDetails(post.id);
    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() => _loadingPostId = null);
        // Fallback: Navigate with the collectible post entity directly
        Navigator.of(
          context,
          rootNavigator: true,
        ).pushNamed(PostDetailsView.name, arguments: {'post': post});
      },
      (fullPost) {
        setState(() => _loadingPostId = null);
        Navigator.of(
          context,
          rootNavigator: true,
        ).pushNamed(PostDetailsView.name, arguments: {'post': fullPost});
      },
    );
  }

  void _navigateToProfile(String username) {
    final myUsername = context.read<CurrentUserCubit>().state.username;
    final isMine = myUsername != null && myUsername == username;

    if (isMine) {
      context.read<ProfileCubit>().getPersonlProfile();
      BlocProvider.of<ProfileBloc>(context).add(LoadInitialProfilePosts());
      sl<MainTabController>().setIndex(2);
      return;
    }

    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(UserProfileView.name);
    context.read<ProfileCubit>().getUserProfile(username);
    BlocProvider.of<ProfileBloc>(context).add(
      LoadInitialProfilePosts(username: username),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return BlocBuilder<CollectionPostsCubit, CollectionPostsState>(
      builder: (context, state) {
        // 1. Loading state with Skeletonizer
        if (state.isLoading) {
          return Skeletonizer(
            effect: ShimmerEffect(
              highlightColor: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.5),
              baseColor: AppColorsFromTheme.grayForTheme(
                context,
              ).withValues(alpha: 0.5),
            ),
            enabled: true,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _dummySkeletonPosts.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final dummyPost = _dummySkeletonPosts[index];
                return _SavedPostCard(
                  width: width,
                  post: dummyPost,
                  isLoadingDetails: false,
                  onGoToPost: () {},
                  onUserTap: () {},
                  onUnsave: () {},
                  isUnsaving: false,
                );
              },
            ),
          );
        }

        // 2. Error state
        if (state.errorMessage != null && !state.hasData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.errorMessage!,
                    style: AppTextStyle.interMedium12.copyWith(
                      color: AppColorsFromTheme.grayForText(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      if (state.currentCollectionId != null) {
                        context
                            .read<CollectionPostsCubit>()
                            .fetchCollectionPosts(
                              collectionId: state.currentCollectionId!,
                              forceRefresh: true,
                            );
                      }
                    },
                    child: Text(
                      'Retry',
                      style: AppTextStyle.interSemiBold14.copyWith(
                        color: AppColorsFromTheme.primaryColor(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // 3. Empty state
        if (!state.isLoading && state.items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Text(
                'No saved posts in this collection',
                style: AppTextStyle.interMedium14.copyWith(
                  color: AppColorsFromTheme.grayForText(context),
                ),
              ),
            ),
          );
        }

        // 4. Data loaded state
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: state.items.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final collectionItem = state.items[index];
            final post = collectionItem.collectible.toPostEntity();

            return _SavedPostCard(
              width: width,
              post: post,
              isLoadingDetails: _loadingPostId == post.id,
              onGoToPost: () => _openPostDetails(post),
              onUserTap: () => _navigateToProfile(post.owner.username),
              onUnsave: () => _unsavePost(collectionItem),
              isUnsaving: _unsavingItemIds.contains(collectionItem.id),
            );
          },
        );
      },
    );
  }
}

class _SavedPostCard extends StatelessWidget {
  const _SavedPostCard({
    required this.width,
    required this.post,
    required this.isLoadingDetails,
    required this.onGoToPost,
    required this.onUserTap,
    required this.onUnsave,
    this.isUnsaving = false,
  });

  final double width;
  final PostEntity post;
  final bool isLoadingDetails;
  final VoidCallback onGoToPost;
  final VoidCallback onUserTap;
  final VoidCallback onUnsave;
  final bool isUnsaving;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: onUserTap,
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
                      GestureDetector(
                        onTap: onUserTap,
                        child: PostUserNameAndDate(
                          withDetails: true,
                          date: post.createdAt.toIso8601String(),
                          owner: post.owner,
                        ),
                      ),
                      const SizedBox(height: 8),
                      PostBody(
                        width: width,
                        height: MediaQuery.of(context).size.height,
                        withDetails: false,
                        body: post.body,
                        mediaItems: post.mediaItems,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: isUnsaving ? null : onUnsave,
                            tooltip: 'Unsave post',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: isUnsaving
                                ? SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  )
                                : SvgPicture.asset(
                                    Assets.assetsIconsSaveFilled,
                                    colorFilter: ColorFilter.mode(
                                      Theme.of(context).colorScheme.primary,
                                      BlendMode.srcIn,
                                    ),
                                    width: 22,
                                    height: 22,
                                  ),
                          ),
                          const SizedBox(width: 16),
                          TextButton(
                            onPressed: isLoadingDetails ? null : onGoToPost,
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                            ),
                            child: isLoadingDetails
                                ? SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'go to post',
                                        style: AppTextStyle.interMedium12
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                      ),
                                      const SizedBox(width: 8),
                                      SvgPicture.asset(
                                        Assets.assetsIconsRightArrow,
                                        colorFilter: ColorFilter.mode(
                                          Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          BlendMode.srcIn,
                                        ),
                                        width: 16,
                                        height: 16,
                                      ),
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
  }
}
