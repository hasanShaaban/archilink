import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:archilink/features/Profile/domain/entity/profile_type.dart';
import 'package:archilink/features/Profile/domain/repo/profile_repo.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/follow_cubit.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/personal_profile_buttons.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_image_section.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_info_section.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_statistics_row.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/user_profile_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
          _buildButtons(type, width, height, username: profileData.username, isFollowing: profileData.isFollowing),
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
  required bool isFollowing,
}) {
  if (type == ProfileType.personalProfile) {
    return Skeleton.keep(child: PersonalProfileButtons(width: width));
  }
  if (type == ProfileType.userProfile) {
    return BlocProvider(
      create: (context) => FollowCubit(sl<ProfileRepo>()),
      child: Skeleton.keep(
        child: UserProfileButtons(
          height: height,
          width: width,
          username: username,
          isFollowing: isFollowing,
        ),
      ),
    );
  }
  return const SizedBox();
}
