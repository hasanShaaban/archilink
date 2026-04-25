import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/current_user_cubit.dart';
import 'package:archilink/features/Main/presentation/manager/main_tab_controller.dart';
import 'package:archilink/features/Profile/presentation/manager/bloc/profile_bloc.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/follow_cubit.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/profile_cubit.dart';
import 'package:archilink/features/Profile/presentation/views/user_profile_view.dart';
import 'package:archilink/features/Search/domain/entity/user_entity.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          final myUsername = context.read<CurrentUserCubit>().state.username;
          final isMine =
              myUsername != null && myUsername == user!.username;
          if (isMine) {
            context.read<ProfileCubit>().getPersonlProfile();
            BlocProvider.of<ProfileBloc>(
              context,
            ).add(LoadInitialProfilePosts());
            sl<MainTabController>().setIndex(2);
            return;
          }
          Navigator.of(
            context,
            rootNavigator: true,
          ).pushNamed(UserProfileView.name);
          context.read<ProfileCubit>().getUserProfile(user!.username);
          BlocProvider.of<ProfileBloc>(
            context,
          ).add(LoadInitialProfilePosts(username: user!.username));
        },
        child: Column(
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
              child: user != null && user!.userAvatar != null
                  ? ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: user!.userAvatar!,
                        fit: BoxFit.contain,
                      ),
                    )
                  : Center(
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: SvgPicture.asset(Assets.assetsIconsUser),
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
            if (user != null)
              BlocProvider(
                create: (context) => sl<FollowCubit>(),
                child: FeaturedMemeberFollowButton(
                  height: height,
                  width: width,
                  user: user!,
                  lang: lang,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class FeaturedMemeberFollowButton extends StatefulWidget {
  const FeaturedMemeberFollowButton({
    super.key,
    required this.height,
    required this.width,
    required this.user,
    required this.lang,
  });

  final double height;
  final double width;
  final UserEntity user;
  final S lang;

  @override
  State<FeaturedMemeberFollowButton> createState() =>
      _FeaturedMemeberFollowButtonState();
}

class _FeaturedMemeberFollowButtonState
    extends State<FeaturedMemeberFollowButton> {
  @override
  void initState() {
    super.initState();
    context.read<FollowCubit>().setInitial(
      isFollowing: widget.user.isFollowing,
    );
  }

  @override
  void didUpdateWidget(covariant FeaturedMemeberFollowButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.user.username != widget.user.username ||
        oldWidget.user.isFollowing != widget.user.isFollowing) {
      context.read<FollowCubit>().setInitial(
        isFollowing: widget.user.isFollowing,
        force: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height * 28 / 847,
      width: widget.width * 90 / 402,
      child: BlocBuilder<FollowCubit, FollowState>(
        builder: (context, state) {
          final bool isFollowing = state.isFollowing;
          final Color followColor = isFollowing
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.primary;
          return TextButton(
            onPressed: () {
              if (state.isSubmitting) return;
              final followCubit = context.read<FollowCubit>();
              if (followCubit.isClosed) return;
              if (isFollowing) {
                followCubit.unfollow(widget.user.username);
              } else {
                followCubit.follow(widget.user.username);
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: followColor,
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
                  widget.lang.follow,
                  style: AppTextStyle.interMedium10.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
