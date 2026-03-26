import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/follow_cubit.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileButtons extends StatelessWidget {
  const UserProfileButtons({
    super.key,
    required this.height,
    required this.width,
    required this.username,
  });

  final double height;
  final double width;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          BlocBuilder<FollowCubit, FollowState>(
            builder: (context, state) {
              final Color followColor = state.isFollowing
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primary;
              return SizedBox(
                height: height * 44 / 874,
                width: width * 150 / 402,
                child: ProfileCustomButton(
                  onPress: () {
                    if (state.isSubmitting) return;
                    context.read<FollowCubit>().follow(username);
                  },
                  title: 'Follow',
                  icon: Assets.assetsIconsEditProfile,
                  iconSize: 24,
                  backgroundColor: followColor,
                  textStyle: AppTextStyle.interMedium16.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              );
            },
          ),
          SizedBox(width: 8),
          Expanded(
            child: ProfileCustomButton(
              iconSize: 24,
              onPress: () {},
              icon: Assets.assetsIconsShareProfile,
              title: 'Send a message',
              backgroundColor: AppColorsFromTheme.grayForTheme(context),
              textStyle: AppTextStyle.interMedium16.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
