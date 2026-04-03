import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileInfoSection extends StatelessWidget {
  const ProfileInfoSection({super.key, required this.profileData});

  final ProfileEntity? profileData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              profileData != null ? profileData!.name : 'name',
              style: AppTextStyle.interBold20.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(width: 8),
            Text(
              profileData != null ? '@${profileData!.username}' : 'username',
              style: AppTextStyle.interRegular12.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          profileData != null
              ? profileData!.details.bio ?? 'No bio yet'
              : 'No bio yet',
          style: AppTextStyle.interRegular12.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8),
        if (profileData!.details.city != null ||
            profileData!.details.country != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                Assets.assetsIconsLocation,
                width: 12,
                height: 12,
              ),
              SizedBox(width: 8),
              Text(
                '${profileData!.details.city ?? ''}${(profileData!.details.city != null && profileData!.details.country != null) ? ', ' : ''}${profileData!.details.country ?? ''}',
                style: AppTextStyle.interMedium10.copyWith(
                  color: AppColorsFromTheme.grayForText(context),
                ),
              ),
            ],
          ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColorsFromTheme.grayForTheme(context),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'Student Account',
            style: AppTextStyle.interRegular10.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
