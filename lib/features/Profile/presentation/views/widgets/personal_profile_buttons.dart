import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Create_Post/presentation/views/create_post_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/edit_profile_view.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PersonalProfileButtons extends StatelessWidget {
  const PersonalProfileButtons({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 61),
      child: Row(
        children: [
          Expanded(
            child: ProfileCustomButton(
              onPress: () {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamed(CreatePostView.name);
              },
              icon: Assets.assetsIconsAdd,
              iconSize: 16,
              title: 'Create Post',
              backgroundColor: Theme.of(context).colorScheme.primary,
              textStyle: AppTextStyle.interMedium12.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: ProfileCustomButton(
              onPress: () {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamed(EditProfileView.name);
              },
              icon: Assets.assetsIconsEditProfile,
              iconSize: 16,
              title: 'Edit Profile',
              backgroundColor: AppColorsFromTheme.grayForTheme(context),
              textStyle: AppTextStyle.interMedium12.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(width: 8),
          SizedBox(
            width: width * 36 / 402,
            height: width * 36 / 402,
            child: MaterialButton(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(10),
              ),
              color: AppColorsFromTheme.grayForTheme(context),

              padding: EdgeInsets.zero,
              onPressed: () {},
              child: SvgPicture.asset(
                Assets.assetsIconsShareProfile,
                width: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
