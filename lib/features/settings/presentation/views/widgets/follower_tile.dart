import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Search/domain/entity/user_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FollowerTile extends StatelessWidget {
  const FollowerTile({super.key, required this.user, required this.action});

  final UserEntity user;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColorsFromTheme.grayForTheme(context),
            child: user.userAvatar == null
                ? SvgPicture.asset(
                    Assets.assetsIconsUser,
                    color: colorScheme.onSurface,
                  )
                : ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: user.userAvatar!,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => SvgPicture.asset(
                        Assets.assetsIconsUser,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: AppTextStyle.interSemiBold14.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '@${user.username}',
                  style: AppTextStyle.interMedium12.copyWith(
                    color: AppColors.gray,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          action,
        ],
      ),
    );
  }
}