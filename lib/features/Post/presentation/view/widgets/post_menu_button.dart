import 'dart:developer';

import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/current_user_cubit.dart';
import 'package:archilink/features/Create_Post/presentation/views/create_post_view.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Post/presentation/manager/cubit/post_menu_cubit.dart';
import 'package:archilink/features/Post/presentation/view/post.dart';
import 'package:archilink/features/Post_Details/presentation/manager/bloc/post_details_bloc.dart';
import 'package:archilink/features/Post_Details/presentation/view/post_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class PostMenuButton extends StatelessWidget {
  const PostMenuButton({
    super.key,
    required this.username,
    required this.postId,
    this.post,
  });
  final String username;
  final int postId;
  final PostEntity? post;

  @override
  Widget build(BuildContext context) {
    final myUsername = context.select((CurrentUserCubit c) => c.state.username);
    final isMine = myUsername != null && myUsername == username;
    const iconSize = 24.0;
    return BlocListener<PostMenuCubit, PostMenuState>(
      listenWhen: (previous, current) {
        if (current is PostMenuSuccess) return current.postId == postId;
        if (current is PostMenuFailure) return current.postId == postId;
        return false;
      },
      listener: (context, state) {
        if (state is PostMenuSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          if (state.action == PostMenuAction.delete &&
              ModalRoute.of(context)?.settings.name == PostDetailsView.name) {
            Navigator.of(context).pop();
          }
        } else if (state is PostMenuFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: PopupMenuButton<PostMenuAction>(
        onOpened: () {
          log(isMine.toString());
          log(username);
          log(myUsername.toString());
        },
        menuPadding: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(
          minWidth: iconSize,
          minHeight: iconSize,
        ),
        color: Theme.of(context).scaffoldBackgroundColor,
        elevation: 2,
        offset: const Offset(0, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
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
              if (post != null) {
                Navigator.of(context, rootNavigator: true).pushNamed(
                  CreatePostView.name,
                  arguments: {'post': post},
                ).then((result) {
                  if (result == true && context.mounted) {
                    try {
                      context.read<PostDetailsBloc>().add(RefreshPostDetails());
                    } catch (_) {}
                  }
                });
              }
              break;
            case PostMenuAction.delete:
              _showDeleteDialog(context);
              break;
            case PostMenuAction.hide:
              context.read<PostMenuCubit>().hidePost(postId: postId);
              break;
            case PostMenuAction.report:
              // TODO: wire report action.
              break;
            case PostMenuAction.interest:
              context.read<PostMenuCubit>().interestPost(postId: postId);
              break;
          }
        },
        itemBuilder: (context) {
          Widget item({required String label, required String icon}) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.transparent,
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    icon,
                    width: 24,
                    height: 24,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: AppTextStyle.interMedium12.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            );
          }

          return isMine
              ? [
                  PopupMenuItem(
                    value: PostMenuAction.edit,
                    child: item(
                      label: 'Edit',
                      icon: Assets.assetsIconsEditPostComment,
                    ),
                  ),
                  PopupMenuItem(
                    value: PostMenuAction.delete,
                    child: item(
                      label: 'Delete',
                      icon: Assets.assetsIconsDeletePostComment,
                    ),
                  ),
                ]
              : [
                  PopupMenuItem(
                    value: PostMenuAction.interest,
                    child: item(
                      label: 'Interested',
                      icon: Assets.assetsIconsLike,
                    ),
                  ),
                  PopupMenuItem(
                    value: PostMenuAction.hide,
                    child: item(
                      label: 'Hide',
                      icon: Assets.assetsIconsHidePost,
                    ),
                  ),
                  PopupMenuItem(
                    value: PostMenuAction.report,
                    child: item(
                      label: 'Report',
                      icon: Assets.assetsIconsReport,
                    ),
                  ),
                ];
        },
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text(
          'Are you sure you want to delete this post? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<PostMenuCubit>().deletePost(postId: postId);
    }
  }
}
