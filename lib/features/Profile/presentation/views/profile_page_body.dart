import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/fakers.dart';
import 'package:archilink/core/widgets/main_appbar.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:archilink/features/Profile/domain/entity/profile_type.dart';
import 'package:archilink/features/Profile/presentation/manager/bloc/profile_bloc.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/profile_cubit.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/loading_new_post.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_details_page.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_info_header.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_posts_page.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_tap_bar_delegate.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfilePageBody extends StatefulWidget {
  const ProfilePageBody({super.key, required this.type});

  final ProfileType type;

  @override
  State<ProfilePageBody> createState() => _ProfilePageBodyState();
}

class _ProfilePageBodyState extends State<ProfilePageBody> {
  /// Tracks whether we have already triggered the initial posts load for the
  /// current profile. Resets to false whenever a new fetch starts (ProfileLoading),
  /// allowing a refresh to re-trigger the posts load.
  bool _postsLoaded = false;

  /// Returns true when the viewer is allowed to see this profile's posts/products.
  bool _canViewPosts(ProfileEntity profile) {
    if (widget.type == ProfileType.personalProfile) return true;
    if (widget.type == ProfileType.personalStoreProfile) return true;
    if (widget.type == ProfileType.storeProfile) return true;
    if (profile.privacySetting == 'public') return true;
    return profile.isFollowing;
  }

  /// Dispatches [LoadInitialProfilePosts] exactly once per profile fetch,
  /// but only when the privacy settings allow it.
  void _tryLoadPosts(BuildContext context, ProfileEntity profile) {
    if (_postsLoaded) return;
    _postsLoaded = true;
    if (_canViewPosts(profile)) {
      final bool isOwnProfile =
          widget.type == ProfileType.personalProfile ||
          widget.type == ProfileType.personalStoreProfile;
      context.read<ProfileBloc>().add(
        LoadInitialProfilePosts(
          username: isOwnProfile ? null : profile.username,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return BlocConsumer<ProfileCubit, ProfileCubitState>(
      listenWhen: (previous, current) {
        // Reset the flag so that after a refresh the posts are re-loaded.
        if (current is ProfileLoading) _postsLoaded = false;
        return current is ProfileSuccess;
      },
      listener: (context, state) {
        if (state is ProfileSuccess) {
          _tryLoadPosts(context, state.profileData);
        }
      },
      builder: (context, state) {
        if (state is ProfileFailuer) {
          return Center(child: Text(state.errorMessage));
        }

        final bool isSkeleton = state is! ProfileSuccess;
        final ProfileEntity profileData = isSkeleton
            ? fakeProfileEntity()
            : state.profileData;

        // While skeleton is shown we always render posts placeholder.
        // Once real data arrives we check privacy.
        final bool postsVisible = isSkeleton || _canViewPosts(profileData);

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            body: SafeArea(
              child: Skeletonizer(
                ignoreContainers: false,
                effect: ShimmerEffect(
                  highlightColor: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.5),
                  baseColor: AppColorsFromTheme.grayForTheme(
                    context,
                  ).withOpacity(0.5),
                ),
                enabled: isSkeleton,
                child: RefreshIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  backgroundColor: AppColorsFromTheme.grayForTheme(context),
                  displacement: 30,
                  onRefresh: () async {
                    if (widget.type == ProfileType.personalProfile ||
                        widget.type == ProfileType.personalStoreProfile) {
                      context.read<ProfileCubit>().getPersonlProfile();
                      // LoadInitialProfilePosts is dispatched by the listener
                      // once ProfileSuccess arrives.
                    }
                    if (widget.type == ProfileType.userProfile ||
                        widget.type == ProfileType.storeProfile) {
                      context.read<ProfileCubit>().getUserProfile(
                        profileData.username,
                      );
                      // LoadInitialProfilePosts is dispatched by the listener
                      // once ProfileSuccess arrives (privacy re-evaluated then).
                    }
                  },
                  notificationPredicate: (notification) =>
                      notification.depth == 0 || notification.depth == 2,
                  child: NestedScrollView(
                    headerSliverBuilder: (_, _) => [
                      // Own profiles use the main app bar; others show a back-button AppBar.
                      (widget.type == ProfileType.personalProfile ||
                              widget.type == ProfileType.personalStoreProfile)
                          ? MainAppBar(withTabbar: false)
                          : SliverToBoxAdapter(
                              child: Skeleton.keep(
                                child: AppBar(
                                  title: Text(
                                    'UserName\'s Profile',
                                    style: AppTextStyle.interSemiBold16
                                        .copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                      ProfielInfoHeader(
                        width: width,
                        type: widget.type,
                        height: height,
                        profileData: profileData,
                      ),
                      // LoadingNewPost is only relevant for the regular personal profile.
                      if (widget.type == ProfileType.personalProfile)
                        LoadingNewPost(),
                      SliverPersistentHeader(
                        pinned: true,
                        // Store profiles label the first tab "Products" instead of "Posts".
                        delegate: ProfileTabBarDelegate(
                          firstTabLabel:
                              (widget.type == ProfileType.storeProfile ||
                                      widget.type ==
                                          ProfileType.personalStoreProfile)
                                  ? 'Products'
                                  : 'Posts',
                        ),
                      ),
                    ],
                    body: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      dragStartBehavior: DragStartBehavior.down,
                      children: [
                        ProfilePostsPage(
                          width: width,
                          height: height,
                          postsVisible: postsVisible,
                        ),
                        ProfileDetailsPage(entity: profileData),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
