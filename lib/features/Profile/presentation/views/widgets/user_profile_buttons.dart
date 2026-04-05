import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/follow_cubit.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserProfileButtons extends StatefulWidget {
  const UserProfileButtons({
    super.key,
    required this.height,
    required this.width,
    required this.username,
    required this.isFollowing,
  });

  final double height;
  final double width;
  final String username;
  final bool isFollowing;

  @override
  State<UserProfileButtons> createState() => _UserProfileButtonsState();
}

class _UserProfileButtonsState extends State<UserProfileButtons> {
  @override
  void initState() {
    super.initState();
    // Seed cubit with server value for the initial render.
    context.read<FollowCubit>().setInitial(isFollowing: widget.isFollowing);
  }

  @override
  void didUpdateWidget(covariant UserProfileButtons oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.username != widget.username ||
        oldWidget.isFollowing != widget.isFollowing) {
      context.read<FollowCubit>().setInitial(
        isFollowing: widget.isFollowing,
        force: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          BlocBuilder<FollowCubit, FollowState>(
            builder: (context, state) {
              final bool isFollowing = state.isFollowing;
              final Color followColor = isFollowing
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primary;

              return Skeleton.unite(
                child: SizedBox(
                  width: widget.width * 150 / 402,
                  child: ProfileCustomButton(
                    onPress: () {
                      if (state.isSubmitting) return;
                      if (isFollowing) {
                        context.read<FollowCubit>().unfollow(widget.username);
                      } else {
                        context.read<FollowCubit>().follow(widget.username);
                      }
                    },
                    title: isFollowing ? 'Followed' : 'Follow',
                    icon: Assets.assetsIconsAdd,
                    iconSize: 24,
                    backgroundColor: followColor,
                    textStyle: AppTextStyle.interMedium16.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(width: 8),
          Expanded(
            child: Skeleton.unite(
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
          ),
        ],
      ),
    );
  }
}
