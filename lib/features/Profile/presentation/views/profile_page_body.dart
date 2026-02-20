import 'dart:developer';

import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/widgets/main_appbar.dart';
import 'package:archilink/features/Profile/domain/profile_type.dart';
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

class ProfilePageBody extends StatelessWidget {
  const ProfilePageBody({super.key, required this.type});

  final ProfileType type;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (_, _) => [
            type == ProfileType.personalProfile
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
              type: type,
              height: height,
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: ProfileTabBarDelegate(),
            ),
          ],
          body: TabBarView(
            children: [
              ProfilePostsPage(width: width, height: height),
              ProfileDetailsPage(),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfielInfoHeader extends StatelessWidget {
  const ProfielInfoHeader({
    super.key,
    required this.width,
    required this.type,
    required this.height,
  });

  final double width;
  final ProfileType type;
  final double height;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if(state is ProfileSuccess){
          log('Success');
        }else if (state is ProfileLoading){
          log('Loading');
        }else if(state is ProfileFailuer){
          log(state.errorMessage);
        }
      },
      builder: (context, state) {
        final bool isLoading = state is ProfileLoading;
        final profileData = state is ProfileSuccess ? state.profileData : null;
        return SliverToBoxAdapter(
          child: Skeletonizer(
            enabled: isLoading,
            child: Column(
              children: [
                ProfileImageSection(
                  width: width,
                  image: profileData?.profile.profilePictureUrl,
                ),
                SizedBox(height: 16),
                ProfileInfoSection(profileData: profileData?.profile,),
                SizedBox(height: 16),
                _buildButtons(type, width, height),
                SizedBox(height: 8),
                ProfileStatisticsRow(statisticsData: profileData?.followStats,),
                SizedBox(height: 19),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget _buildButtons(ProfileType type, double width, double height){
  if(type == ProfileType.personalProfile){
    return Skeleton.keep(child: PersonalProfileButtons(width: width));
  }
  if(type == ProfileType.userProfile){
    return UserProfileButtons(height: height, width: width);

  }
  return const SizedBox();
}
