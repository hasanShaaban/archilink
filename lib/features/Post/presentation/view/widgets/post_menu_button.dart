import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/current_user_cubit.dart';
import 'package:archilink/features/Post/presentation/view/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

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
        Widget item({required String label, required String icon}) {
          return Row(
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
                  child: item(label: 'Hide', icon: Assets.assetsIconsHidePost),
                ),
                PopupMenuItem(
                  value: PostMenuAction.report,
                  child: item(label: 'Report', icon: Assets.assetsIconsReport),
                ),
              ];
      },
    );
  }
}
