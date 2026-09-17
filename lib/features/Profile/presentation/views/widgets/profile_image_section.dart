import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Profile/domain/entity/profile_type.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/update_banner_cubit.dart';
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
    this.bannerImageUrl,
    required this.type,
  });

  final double width;
  final String? image;
  final String? bannerImageUrl;
  final ProfileType type;

  @override
  Widget build(BuildContext context) {
    final imageRadius = width * 35 / 402;
    final bool isStore =
        type == ProfileType.storeProfile ||
        type == ProfileType.personalStoreProfile;

    if (!isStore) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          _buildAvatar(context, imageRadius),
          if (type == ProfileType.personalProfile)
            Positioned(
              bottom: -6,
              right: -6,
              child: _buildAvatarEditButton(context),
            ),
        ],
      );
    }

    final double bannerHeight = 100.0;
    final double totalHeight = bannerHeight + imageRadius;

    return SizedBox(
      height: totalHeight,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Banner strip (image or placeholder)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: bannerHeight,
            child: _buildBanner(context, bannerHeight),
          ),
          // Banner edit icon (personalStoreProfile only)
          if (type == ProfileType.personalStoreProfile)
            Positioned(
              top: 10,
              right: 14,
              child: _buildBannerEditButton(context),
            ),
          // Avatar overlapping bottom of banner
          Positioned(
            top: bannerHeight - imageRadius,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _buildAvatar(context, imageRadius, withBorder: true),
                if (type == ProfileType.personalStoreProfile)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: _buildAvatarEditButton(context),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner(BuildContext context, double height) {
    if (bannerImageUrl != null && bannerImageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: bannerImageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: height,
        placeholder: (context, url) => Skeletonizer(
          enabled: true,
          child: Container(
            width: double.infinity,
            height: height,
            color: AppColorsFromTheme.grayForTheme(context),
          ),
        ),
        errorWidget: (context, url, error) =>
            _buildBannerPlaceholder(context, height),
      );
    }
    return _buildBannerPlaceholder(context, height);
  }

  Widget _buildBannerPlaceholder(BuildContext context, double height) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: AppColorsFromTheme.grayForTheme(context),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColorsFromTheme.grayForTheme(context),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
          ],
        ),
      ),
      child: Center(
        child: SvgPicture.asset(
          Assets.assetsIconsShoppingBasket,
          width: 30,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.25),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Widget _buildBannerEditButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color:
            Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.85),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            context.read<UpdateBannerCubit>().pickBanner(context);
          },
          child: SvgPicture.asset(
            Assets.assetsIconsEditProfileImage,
            width: 18,
            height: 18,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.onSurface,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(
    BuildContext context,
    double imageRadius, {
    bool withBorder = false,
  }) {
    final avatarWidget = Skeleton.unite(
      child: CircleAvatar(
        radius: imageRadius,
        backgroundColor: AppColorsFromTheme.grayForTheme(context),
        child: ClipOval(
          child: image == null
              ? SvgPicture.asset(
                  Assets.assetsIconsUser,
                  width: 35,
                  colorFilter: ColorFilter.mode(
                    AppColorsFromTheme.reverseGrayForTheme(context),
                    BlendMode.srcIn,
                  ),
                )
              : CachedNetworkImage(
                  imageUrl: image!,
                  fit: BoxFit.cover,
                  width: imageRadius * 2,
                  height: imageRadius * 2,
                  errorWidget: (context, url, error) => SvgPicture.asset(
                    Assets.assetsIconsUser,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
                    width: 24,
                  ),
                  placeholder: (context, url) => Skeletonizer(
                    enabled: true,
                    child: SizedBox(
                      width: imageRadius,
                      height: imageRadius,
                    ),
                  ),
                ),
        ),
      ),
    );

    if (withBorder) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).scaffoldBackgroundColor,
            width: 3.5,
          ),
        ),
        child: avatarWidget,
      );
    }
    return avatarWidget;
  }

  Widget _buildAvatarEditButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            final bool isStore = type == ProfileType.personalStoreProfile ||
                type == ProfileType.storeProfile;
            context.read<UpdateProfileImageCubit>().pickImage(
                  context,
                  isStore: isStore,
                );
          },
          child: SvgPicture.asset(
            Assets.assetsIconsEditProfileImage,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.onSurface,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
