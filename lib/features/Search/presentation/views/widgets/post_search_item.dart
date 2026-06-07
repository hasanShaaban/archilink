import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/current_user_cubit.dart';
import 'package:archilink/features/Main/presentation/manager/main_tab_controller.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_user_image.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_username_and_date.dart';
import 'package:archilink/features/Post_Details/presentation/view/post_details_view.dart';
import 'package:archilink/features/Profile/presentation/manager/bloc/profile_bloc.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/profile_cubit.dart';
import 'package:archilink/features/Profile/presentation/views/user_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class PostSearchItem extends StatelessWidget {
  const PostSearchItem({super.key, required this.width, required this.post});

  final double width;
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                final myUsername = context
                    .read<CurrentUserCubit>()
                    .state
                    .username;
                final isMine =
                    myUsername != null && myUsername == post.owner.username;
                if (isMine) {
                  context.read<ProfileCubit>().getPersonlProfile();
                  BlocProvider.of<ProfileBloc>(
                    context,
                  ).add(LoadInitialProfilePosts());
                  sl<MainTabController>().setIndex(2);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  return;
                }
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamed(UserProfileView.name);
                context.read<ProfileCubit>().getUserProfile(
                  post.owner.username,
                );
                BlocProvider.of<ProfileBloc>(
                  context,
                ).add(LoadInitialProfilePosts(username: post.owner.username));
              },
              child: PostUserImage(
                width: width,
                imageURL: post.owner.profilePictureUrl,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: width * 34 / 402 / 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: PostUserNameAndDate(
                            withDetails: false,
                            date: post.createdAt.toIso8601String(),
                            owner: post.owner,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColorsFromTheme.grayForTheme(context),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  Assets.assetsIconsLike,
                                  width: 12,
                                  height: 12,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '${post.likesCount}',
                                  style: AppTextStyle.interRegular10.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      post.body,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pushNamed(
                            PostDetailsView.name,
                            arguments: {'post': post},
                          );
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(10),
                          ),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'go to post',
                              style: AppTextStyle.interMedium12.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            SizedBox(width: 8),
                            SvgPicture.asset(
                              Assets.assetsIconsRightArrow,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}
