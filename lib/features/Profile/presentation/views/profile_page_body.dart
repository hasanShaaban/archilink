import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/core/widgets/main_appbar.dart';
import 'package:archilink/features/Profile/domain/profile_type.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/personal_profile_buttons.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_custom_button.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_details_page.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_image_section.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_info_section.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_posts_page.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_statistics_row.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_tap_bar_delegate.dart';
import 'package:flutter/material.dart';

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
            SliverToBoxAdapter(
              child: Column(
                children: [
                  ProfileImageSection(width: width),
                  SizedBox(height: 16),
                  ProfileInfoSection(),
                  SizedBox(height: 16),
                  type == ProfileType.personalProfile ? PersonalProfileButtons(width: width) : 
                  type == ProfileType.userProfile ? UserProfileButtons(width: width, height: height) : SizedBox(),
                  SizedBox(height: 8),
                  ProfileStatisticsRow(),
                  SizedBox(height: 19),
                ],
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
              ProfileDetailsPage(),
            ],
          ),
        ),
      ),
    );
  }
}

class UserProfileButtons extends StatelessWidget {
  const UserProfileButtons({
    super.key,
    required this.width,
    required this.height,
  });
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          SizedBox(
            width: width * 150 / 402,
            child: ProfileCustomButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPress: () {},
              title: 'Follow',
              icon: Assets.assetsIconsAdd,

              iconSize: 24,
              textStyle: AppTextStyle.interMedium16.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: ProfileCustomButton(
              onPress: () {},
              icon: Assets.assetsIconsMailAdd,
              title: 'Send a message',
              backgroundColor: AppColorsFromTheme.grayForTheme(context),
              textStyle: AppTextStyle.interMedium16.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              iconSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}
