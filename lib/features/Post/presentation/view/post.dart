import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Post/presentation/manager/cubit/post_menu_cubit.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_actions.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_body.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_locaion_date_and_tags.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_menu_button.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_user_image.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_username_and_date.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/current_user_cubit.dart';
import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/features/Main/presentation/manager/main_tab_controller.dart';
import 'package:archilink/features/Profile/presentation/manager/bloc/profile_bloc.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/profile_cubit.dart';
import 'package:archilink/features/Profile/presentation/views/user_profile_view.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

enum PostMenuAction { edit, delete, hide, report, interest }

class Post extends StatefulWidget {
  const Post({
    super.key,
    required this.lang,
    required this.width,
    required this.height,
    this.onPostTapped,
    required this.withDetails,
    required this.entity,
    this.localAssets = const [],
  });
  final S lang;
  final double width, height;
  final VoidCallback? onPostTapped;
  final bool withDetails;
  final PostEntity entity;
  final List<AssetEntity> localAssets;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    final isHidden = context.select<PostMenuCubit, bool>(
      (cubit) => cubit.hiddenPostIds.contains(widget.entity.id),
    );
    final isClosed = context.select<PostMenuCubit, bool>(
      (cubit) => cubit.closedPostIds.contains(widget.entity.id),
    );

    if (isClosed) {
      return const SizedBox.shrink();
    }

    if (isHidden) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColorsFromTheme.secondaryColor(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColorsFromTheme.borderColor(context),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Post hidden. Report this post?',
                  style: AppTextStyle.interMedium14.copyWith(
                    color: AppColorsFromTheme.textColor(context),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Report functionality is not implemented yet'),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Report',
                  style: AppTextStyle.interSemiBold14.copyWith(
                    color: AppColors.red,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: 20,
                  color: AppColorsFromTheme.grayForText(context),
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  context.read<PostMenuCubit>().closeHiddenPost(
                    postId: widget.entity.id,
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPostTapped,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //------------// User image section //-------------------------------------------------------------------------
                    GestureDetector(
                      onTap: () {
                        final myUsername = context
                            .read<CurrentUserCubit>()
                            .state
                            .username;
                        final isMine =
                            myUsername != null &&
                            myUsername == widget.entity.owner.username;
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
                        context.read<ProfileCubit>().getUserProfile(
                          widget.entity.owner.username,
                        );
                        BlocProvider.of<ProfileBloc>(context).add(
                          LoadInitialProfilePosts(username: widget.entity.owner.username),
                        );
                      },
                      child: PostUserImage(
                        width: widget.width,
                        imageURL: widget.entity.owner.profilePictureUrl,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: widget.width * 34 / 402 / 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //--------------------// User name and date section //--------------------------------------------------------
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                PostUserNameAndDate(
                                  withDetails: widget.withDetails,
                                  date: widget.entity.createdAt.toString(),
                                  owner: widget.entity.owner,
                                ),
                                //----------------// Post more options section //--------------------------------------------------------
                                PostMenuButton(
                                  username: widget.entity.owner.username,
                                  postId: widget.entity.id,
                                ),
                              ],
                            ),
                            const SizedBox(height: 9),
                            //--------------------// Post body section //---------------------------------------------------------------
                            PostBody(
                              body: widget.entity.body,
                              mediaItems: widget.entity.mediaItems,
                              localAssets: widget.localAssets,
                              width: widget.width,
                              height: widget.height,
                              withDetails: widget.withDetails,
                            ),
                            const SizedBox(height: 16),
                            widget.withDetails
                                ? PostLocationDateAndTags(
                                    date: widget.entity.createdAt.toString(),
                                    tags: widget.entity.tags,
                                    city: widget.entity.owner.city,
                                    country: widget.entity.owner.country,
                                  )
                                : const SizedBox(),
                            //--------------------// Post actions section //------------------------------------------------------------
                            PostActions(
                              width: widget.width,
                              postId: widget.entity.id,
                              likesCount: widget.entity.likesCount,
                              commentsCount: widget.entity.commentsCount,
                              likedByMe: widget.entity.likedByMe,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
  }
}
