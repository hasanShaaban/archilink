import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/current_user_cubit.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_actions.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_body.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_locaion_date_and_tags.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_user_image.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_username_and_date.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Profile/presentation/manager/bloc/profile_bloc.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/profile_cubit.dart';
import 'package:archilink/features/Profile/presentation/views/user_profile_view.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

enum PostMenuAction { edit, delete, settings, hide, report, interest }

class Post extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPostTapped,
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
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed(UserProfileView.name);
                  context.read<ProfileCubit>().getUserProfile(
                    entity.owner.username,
                  );
                  BlocProvider.of<ProfileBloc>(context).add(
                    LoadInitialProfilePosts(username: entity.owner.username),
                  );
                },
                child: PostUserImage(
                  width: width,
                  imageURL: entity.owner.profilePictureUrl,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: width * 34 / 402 / 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //--------------------// User name and date section //--------------------------------------------------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PostUserNameAndDate(
                            withDetails: withDetails,
                            date: entity.createdAt.toString(),
                            owner: entity.owner,
                          ),
                          //----------------// Post more options section //--------------------------------------------------------
                          PostMenuButton(username: entity.owner.username),
                        ],
                      ),
                      const SizedBox(height: 9),
                      //--------------------// Post body section //---------------------------------------------------------------
                      PostBody(
                        body: entity.body,
                        mediaItems: entity.mediaItems,
                        localAssets: localAssets,
                        width: width,
                        height: height,
                        withDetails: withDetails,
                      ),
                      SizedBox(height: 16),
                      withDetails
                          ? PostLocationDateAndTags(
                              date: entity.createdAt.toString(),
                              tags: entity.tags,
                            )
                          : SizedBox(),
                      //--------------------// Post actions section //------------------------------------------------------------
                      PostActions(
                        width: width,
                        postId: entity.id,
                        likesCount: entity.likesCount,
                        commentsCount: entity.commentsCount,
                        likedByMe: entity.likedByMe,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PostMenuButton extends StatelessWidget {
  const PostMenuButton({super.key, required this.username});
  final String username;

  @override
  Widget build(BuildContext context) {
    final myUsername = context.select((CurrentUserCubit c) => c.state.username);
    final isMine = myUsername != null && myUsername == username;
    const iconSize = 24.0;
    return PopupMenuButton<PostMenuAction>(
      menuPadding: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: iconSize,
        minHeight: iconSize,
      ),
      color: Theme.of(context).colorScheme.surface,
      elevation: 0,
      offset: const Offset(0, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.16),
        ),
      ),
      child: SvgPicture.asset(
        Assets.assetsIconsMoreVertical,
        color: Theme.of(context).colorScheme.onSurface,
        width: iconSize,
      ),
      onSelected: (value) {
        switch (value) {
          case PostMenuAction.edit:
            // TODO: wire edit action.
            break;
          case PostMenuAction.delete:
            // TODO: wire delete action.
            break;
          case PostMenuAction.settings:
            // TODO: wire settings action.
            break;
          case PostMenuAction.hide:
            // TODO: wire hide action.
            break;
          case PostMenuAction.report:
            // TODO: wire report action.
            break;
          case PostMenuAction.interest:
            // TODO: wire interest action.
            break;
        }
      },
      itemBuilder: (context) {
        final onSurface = Theme.of(context).colorScheme.onSurface;
        final error = Theme.of(context).colorScheme.error;
        final textStyle = Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);

        Widget item({
          required String label,
          required IconData icon,
          required Color color,
        }) {
          return Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 12),
              Text(label, style: textStyle?.copyWith(color: color)),
            ],
          );
        }

        return isMine
            ? [
                PopupMenuItem(
                  value: PostMenuAction.edit,
                  child: item(
                    label: 'Edit post',
                    icon: Icons.edit_rounded,
                    color: onSurface,
                  ),
                ),
                PopupMenuItem(
                  value: PostMenuAction.delete,
                  child: item(
                    label: 'Delete post',
                    icon: Icons.delete_rounded,
                    color: error,
                  ),
                ),
                PopupMenuItem(
                  value: PostMenuAction.settings,
                  child: item(
                    label: 'Post settings',
                    icon: Icons.tune_rounded,
                    color: onSurface,
                  ),
                ),
              ]
            : [
                PopupMenuItem(
                  value: PostMenuAction.hide,
                  child: item(
                    label: 'Hide post',
                    icon: Icons.visibility_off_rounded,
                    color: onSurface,
                  ),
                ),
                PopupMenuItem(
                  value: PostMenuAction.report,
                  child: item(
                    label: 'Report',
                    icon: Icons.flag_rounded,
                    color: error,
                  ),
                ),
                PopupMenuItem(
                  value: PostMenuAction.interest,
                  child: item(
                    label: 'Not interested',
                    icon: Icons.remove_circle_rounded,
                    color: onSurface,
                  ),
                ),
              ];
      },
    );
  }
}
