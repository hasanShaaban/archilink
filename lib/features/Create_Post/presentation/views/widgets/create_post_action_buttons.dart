import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Create_Post/presentation/manager/cubit/create_post_cubit.dart';
import 'package:archilink/features/Create_Post/presentation/views/widgets/create_post_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CreatePostActionButtons extends StatelessWidget {
  const CreatePostActionButtons({super.key, required this.state});
  final CreatePostState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Audience', style: AppTextStyle.interMedium14),
              AudienceToggle(privacy: state.privacy),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Post elements', style: AppTextStyle.interMedium14),
              PostElementsButtons(state: state),
            ],
          ),
        ],
      ),
    );
  }
}

class PostElementsButtons extends StatelessWidget {
  const PostElementsButtons({super.key, required this.state});

  final CreatePostState state;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height * 33 / 874,
      width: width * 240 / 414,
      child: Row(
        children: [
          CreatePostActionButton(
            icon: Assets.assetsIconsAddTags,
            text: 'Add Tags',
    
            onPressed: () {
              state.isAddingTag
                  ? context.read<CreatePostCubit>().toggleAddingTag(false)
                  : context.read<CreatePostCubit>().toggleAddingTag(true);
            },
            color: state.isAddingTag
                ? Theme.of(context).colorScheme.primary
                : null,
          ),
          SizedBox(width: 12),
          CreatePostActionButton(
            icon: Assets.assetsIconsAddImage,
            text: 'Add Photos',
            onPressed: () =>
                context.read<CreatePostCubit>().pickImages(context),
          ),
        ],
      ),
    );
  }
}

class AudienceToggle extends StatelessWidget {
  const AudienceToggle({super.key, required this.privacy});
  final String privacy;

  @override
  Widget build(BuildContext context) {
    final isPublic = privacy == 'public';
    final baseColor = AppColorsFromTheme.grayForTheme(context).withAlpha(400);
    final selectedColor = AppColorsFromTheme.grayForTheme(context);
    final textStyle = AppTextStyle.interMedium12.copyWith(
      color: Theme.of(context).colorScheme.onSurface,
    );
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height * 33 / 874,
      width: width * 240 / 414,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ToggleButtons(
          isSelected: [isPublic, !isPublic],
          onPressed: (index) {
            final nextIsPublic = index == 0;
            if (nextIsPublic != isPublic) {
              context.read<CreatePostCubit>().togglePrivacy();
            }
          },
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.onSurface,
          selectedColor: Theme.of(context).colorScheme.onSurface,
          fillColor: selectedColor,
          borderColor: Colors.transparent,
          selectedBorderColor: AppColorsFromTheme.grayForTheme(
            context,
          ).withAlpha(450),
          renderBorder: true,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 29, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    Assets.assetsIconsPublic,
                    width: 16,
                    height: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  SizedBox(width: 4),
                  Text('Public', style: textStyle),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 29, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    Assets.assetsIconsPrivate,
                    width: 16,
                    height: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  SizedBox(width: 4),
                  Text('Private', style: textStyle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
