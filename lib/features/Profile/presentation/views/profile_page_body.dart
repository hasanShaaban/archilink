import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/widgets/main_appbar.dart';
import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/features/Create_Post/presentation/manager/cubit/create_post_cubit.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:archilink/features/Profile/domain/entity/profile_type.dart';
import 'package:archilink/features/Profile/domain/repo/profile_repo.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/follow_cubit.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/profile_cubit.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/personal_profile_buttons.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_details_page.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_image_section.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_info_section.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_posts_page.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_statistics_row.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_tap_bar_delegate.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/user_profile_buttons.dart';
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
        if (state is ProfileSuccess) {
          ProfileEntity profileData = state.profileData;
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              body: NestedScrollView(
                headerSliverBuilder: (_, _) => [
                  widget.type == ProfileType.personalProfile
                      ? MainAppBar(withTabbar: false)
                      : SliverToBoxAdapter(
                          child: AppBar(
                            title: Text(
                              'UserName\'s Profile',
                              style: AppTextStyle.interSemiBold16.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
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
                  SliverToBoxAdapter(
                    child: BlocSelector<CreatePostCubit, CreatePostState, bool>(
                      selector: (state) {
                        return state.isSubmitting;
                      },
                      builder: (context, isSubmitting) {
                        return isSubmitting
                            ? Column(
                                children: [
                                  Divider(
                                    thickness: 1,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 6,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'loading new post...',
                                          style: AppTextStyle.interRegular16
                                              .copyWith(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                              ),
                                        ),
                                        SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                ],
                              )
                            : SizedBox();
                      },
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: ProfileTabBarDelegate(),
                  ),
                ],
                body: TabBarView(
                  children: [
                    ProfilePostsPage(width: width, height: height),
                    ProfileDetailsPage(entity: profileData),
                  ],
                ),
              ),
            ),
          );
        } else if (state is ProfileFailuer) {
          return Center(child: Text(state.errorMessage));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class ProfielInfoHeader extends StatelessWidget {
  const ProfielInfoHeader({
    super.key,
    required this.width,
    required this.type,
    required this.height,
    required this.profileData,
  });

  final double width;
  final ProfileType type;
  final double height;
  final ProfileEntity profileData;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          ProfileImageSection(
            width: width,
            image: profileData.profilePictureUrl,
          ),
          SizedBox(height: 16),
          ProfileInfoSection(profileData: profileData),
          SizedBox(height: 16),
          _buildButtons(type, width, height, username: profileData.username),
          SizedBox(height: 8),
          ProfileStatisticsRow(
            followers: profileData.followersCount,
            following: profileData.followingCount,
            posts: profileData.postsCount,
            projects: profileData.projectCount,
          ),
          SizedBox(height: 19),
        ],
      ),
    );
  }
}

Widget _buildButtons(
  ProfileType type,
  double width,
  double height, {
  required String username,
}) {
  if (type == ProfileType.personalProfile) {
    return Skeleton.keep(child: PersonalProfileButtons(width: width));
  }
  if (type == ProfileType.userProfile) {
    return BlocProvider(
      create: (context) => FollowCubit(sl<ProfileRepo>()),
      child: UserProfileButtons(
        height: height,
        width: width,
        username: username,
      ),
    );
  }
  return const SizedBox();
}
