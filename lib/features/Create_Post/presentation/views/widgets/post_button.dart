import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Create_Post/presentation/manager/cubit/create_post_cubit.dart';
import 'package:archilink/features/Post/presentation/view/post.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostButton extends StatelessWidget {
  const PostButton({super.key, required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CreatePostCubit, CreatePostState, bool>(
      selector: (state) => state.canPost,
      builder: (context, canPost) {
        return Center(
          child: SizedBox(
            width: width * 83 / 402,
            height: height * 44 / 874,
            child: TextButton(
              onPressed: () {
                postPreviewBuilder(context);

                // context.read<CreatePostCubit>().submitPost();
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(10),
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.zero,
                backgroundColor: canPost
                    ? Theme.of(context).colorScheme.primary
                    : AppColorsFromTheme.grayForTheme(context),
                foregroundColor: Theme.of(context).colorScheme.onSurface,
              ),
              child: Text('Post', style: AppTextStyle.interMedium16),
            ),
          ),
        );
      },
    );
  }

  Future<Object?> postPreviewBuilder(BuildContext context) {
    return showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: 'Post Preview',
      barrierColor: Colors.black.withAlpha(450),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) => Align(
        alignment: Alignment.center,
        child: Material(
          color: Colors.transparent,
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Post(
                    lang: S.of(context),
                    width: width,
                    height: height,
                    withDetails: true,
                    entity: context.read<CreatePostCubit>().buildPreviewPost(),
                    localAssets: context
                        .read<CreatePostCubit>()
                        .state
                        .selectedAssets,
                  ),
                ),
                Text(
                  'This is how your post will appear to others.\nReady to share it?',
                  style: AppTextStyle.interRegular14.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: AppColorsFromTheme.grayForTheme(
                          context,
                        ),
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onSurface,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text('Continue Editing'),
                    ),
                    SizedBox(width: 12),
                    TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onSurface,
                      ),
                      onPressed: () {
                        context.read<CreatePostCubit>().submitPost();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text('submit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      transitionBuilder: (_, anim, __, child) => FadeTransition(
        opacity: anim,
        child: SizeTransition(sizeFactor: anim, child: child),
      ),
    );
  }
}
