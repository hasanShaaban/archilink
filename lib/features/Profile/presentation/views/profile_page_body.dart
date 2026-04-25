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
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return BlocBuilder<ProfileCubit, ProfileCubitState>(
      builder: (context, state) {
        if (state is ProfileFailuer) {
          return Center(child: Text(state.errorMessage));
        }

        final bool isSkeleton = state is! ProfileSuccess;
        final ProfileEntity profileData = isSkeleton
            ? fakeProfileEntity()
            : (state as ProfileSuccess).profileData;
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
                    if (widget.type == ProfileType.personalProfile) {
                      context.read<ProfileCubit>().getPersonlProfile();
                      context.read<ProfileBloc>().add(
                        LoadInitialProfilePosts(),
                      );
                    }
                    if (widget.type == ProfileType.userProfile) {
                      context.read<ProfileCubit>().getUserProfile(
                        profileData.username,
                      );
                      context.read<ProfileBloc>().add(
                        LoadInitialProfilePosts(username: profileData.username),
                      );
                    }
                  },
                  notificationPredicate: (notification) =>
                      notification.depth == 0 || notification.depth == 2,
                  child: NestedScrollView(
                    headerSliverBuilder: (_, _) => [
                      widget.type == ProfileType.personalProfile
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
                      if (widget.type == ProfileType.personalProfile)
                        LoadingNewPost(),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: ProfileTabBarDelegate(),
                      ),
                    ],
                    body: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      dragStartBehavior: DragStartBehavior.down,
                      children: [
                        ProfilePostsPage(width: width, height: height),
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
