import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/core/widgets/expandable_text.dart';
import 'package:archilink/core/widgets/main_appbar.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/personal_profile_buttons.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_details_container.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_image_section.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_info_section.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_posts_page.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_statistics_row.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_tap_bar_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfilePageBody extends StatelessWidget {
  const ProfilePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (_, _) => [
            MainAppBar(withTabbar: false),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  ProfileImageSection(width: width),
                  SizedBox(height: 16),
                  ProfileInfoSection(),
                  SizedBox(height: 16),
                  PersonalProfileButtons(width: width),
                  SizedBox(height: 8),
                  ProfileStatisticsRow(),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 29),
                child: Column(
                  children: [
                    SizedBox(height: 18),
                    ProfileDetailsContainer(
                      title: 'About me',
                      content: ExpandableText(
                        style: AppTextStyle.interRegular12,
                        trimLines: 2,
                        '  I am a licensed architect with 3 years of experience in designing residential, commercial, and public spaces. My work focuses on blending functionality with aesthetics, creating sustainable and user-centered environments. Skilled in AutoCAD, Revit, and 3D visualization tools, I translate concepts into detailed plans that bring clients’ visions to life. I am passionate about innovative design, efficient project management, and delivering high-quality results from concept to completion.',
                      ),
                    ),
                    SizedBox(height: 8),
                    ProfileDetailsContainer(
                      title: 'Academic Experience',
                      content: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 8),
                              SvgPicture.asset(
                                Assets.assetsIconsDot,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Bachelor of Architecture from Homs University.',
                                style: AppTextStyle.interRegular12.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ProfileDetailsContainer(title: 'Contact Info', content: Column(
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(Assets.assetsIconsFacebook)
                          ],
                        )
                      ],
                    ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
