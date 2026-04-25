import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Search/domain/entity/user_entity.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FeaturedMemberItem extends StatelessWidget {
  const FeaturedMemberItem({
    super.key,
    required this.lang,
    required this.width,
    required this.height,
    this.user,
  });

  final S lang;
  final double width;
  final double height;
  final UserEntity? user; //TODO: make it required

  String _formatLocation(UserEntity? user) {
    if (user == null) {
      return 'no location';
    }

    final city = user.city?.trim();
    final country = user.country?.trim();
    final parts = [
      if (city != null && city.isNotEmpty) city,
      if (country != null && country.isNotEmpty) country,
    ];

    return parts.isNotEmpty ? parts.join(',') : 'no location';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: height * 16 / 847),
        Container(
          //-----------------image
          width: width * 100 / 402,
          height: width * 100 / 402,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: user != null && user!.userAvatar != null
                  ? CachedNetworkImage(imageUrl: user!.userAvatar!)
                  : SvgPicture.asset(Assets.assetsIconsUser),
            ),
          ),
        ),
        SizedBox(
          width: width * 88 / 402,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user != null
                      ? user!.name
                      : 'Adam Hasan', //-----------------name
                  style: AppTextStyle.mallannaRegular14.copyWith(
                    overflow: TextOverflow.ellipsis,
                    height: 1.8,
                  ),
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      Assets.assetsIconsLocation,
                      width: 12,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    SizedBox(width: 3),
                    SizedBox(
                      width: width * 64 / 402,
                      child: Text(
                        _formatLocation(user), //-----------------location
                        style: AppTextStyle.mallannaRegular12.copyWith(
                          color: Theme.of(context).colorScheme.tertiary,
                          overflow: TextOverflow.ellipsis,
                          height: 1.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 4),
        SizedBox(
          height: height * 28 / 847,
          width: width * 90 / 402,
          child: TextButton(
            onPressed: () {
              //-----------------follow
            },
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  width: 12,
                  Assets.assetsIconsAdd,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                SizedBox(width: 6),
                Text(
                  lang.follow,
                  style: AppTextStyle.interMedium10.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
