import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Profile/domain/entity/profile_type.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/update_profile_image_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileImageSection extends StatelessWidget {
  const ProfileImageSection({
    super.key,
    required this.width,
    this.image,
    required this.type,
  });

  final double width;
  final String? image;
  final ProfileType type;

  @override
  Widget build(BuildContext context) {
    final imageRadius = width * 35 / 402;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Skeleton.unite(
          child: CircleAvatar(
            radius: imageRadius,
            backgroundColor: AppColorsFromTheme.grayForTheme(context),
            child: ClipOval(
              child: image == null
                  ? SvgPicture.asset(
                      Assets.assetsIconsUser,
                      width: 35,
                      color: AppColorsFromTheme.reverseGrayForTheme(context),
                    )
                  : CachedNetworkImage(
                      imageUrl: image!,
                      fit: BoxFit.cover,
                      width: imageRadius * 2,
                      height: imageRadius * 2,
                      errorWidget: (context, url, error) => SvgPicture.asset(
                        Assets.assetsIconsUser,
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 24,
                      ),
                      placeholder: (context, url) => Skeletonizer(
                        enabled: true,
                        child: Container(
                          width: imageRadius,
                          height: imageRadius,
                        ),
                      ),
                    ),
            ),
          ),
        ),
        if (type == ProfileType.personalProfile)
          Positioned(
            bottom: -6,
            right: -6,
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: type == ProfileType.personalProfile
                      ? () {
                          context.read<UpdateProfileImageCubit>().pickImage(
                            context,
                          );
                        }
                      : null,
                  child: SvgPicture.asset(
                    Assets.assetsIconsEditProfileImage,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
