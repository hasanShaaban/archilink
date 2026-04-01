import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/widgets/main_appbar.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:archilink/features/Profile/domain/entity/profile_type.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/profile_cubit.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/loading_new_post.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_details_page.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_info_header.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_posts_page.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_tap_bar_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                  if (widget.type == ProfileType.personalProfile)
                    LoadingNewPost(),
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
