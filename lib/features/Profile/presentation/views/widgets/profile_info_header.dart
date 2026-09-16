import 'package:archilink/core/services/media_picker_service.dart';
import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/core/utils/constants.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:archilink/features/Profile/domain/entity/profile_type.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/follow_cubit.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/update_banner_cubit.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/update_profile_image_cubit.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/personal_profile_buttons.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/personal_store_profile_buttons.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_image_section.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_info_section.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_statistics_row.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/store_profile_buttons.dart';
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
    final bool isStore =
        type == ProfileType.storeProfile ||
        type == ProfileType.personalStoreProfile;

    return SliverToBoxAdapter(
      child: Column(
        children: [
          MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    UpdateProfileImageCubit(sl<MediaPickerService>(instanceName: kProfileImagePicker)),
              ),
              BlocProvider(
                create: (context) =>
                    UpdateBannerCubit(sl<MediaPickerService>(instanceName: kProfileImagePicker)),
              ),
            ],
            child: ProfileImageSection(
              type: type,
              width: width,
              image: profileData.profilePictureUrl,
              bannerImageUrl: profileData.bannerImageUrl,
            ),
          ),
          const SizedBox(height: 16),
          ProfileInfoSection(profileData: profileData),
          const SizedBox(height: 16),
          _buildButtons(
            type,
            width,
            height,
            username: profileData.username,
            isFollowing: profileData.isFollowing,
            profileData: profileData,
          ),
          const SizedBox(height: 8),
          ProfileStatisticsRow(
            followers: profileData.followersCount,
            following: profileData.followingCount,
            posts: profileData.postsCount,
            projects: profileData.projectCount,
            isStore: isStore,
          ),
          const SizedBox(height: 19),
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
  required ProfileEntity profileData,
}) {
  if (type == ProfileType.personalProfile) {
    return Skeleton.keep(
      child: PersonalProfileButtons(width: width, profileData: profileData),
    );
  }
  if (type == ProfileType.userProfile) {
    return BlocProvider(
      create: (context) => sl<FollowCubit>(),
      child: UserProfileButtons(
        height: height,
        width: width,
        username: username,
        isFollowing: isFollowing,
      ),
    );
  }
  if (type == ProfileType.personalStoreProfile) {
    return Skeleton.keep(
      child: PersonalStoreProfileButtons(width: width, profileData: profileData),
    );
  }
  if (type == ProfileType.storeProfile) {
    return BlocProvider(
      create: (context) => sl<FollowCubit>(),
      child: StoreProfileButtons(
        height: height,
        width: width,
        username: username,
        isFollowing: isFollowing,
      ),
    );
  }
  return const SizedBox();
}
