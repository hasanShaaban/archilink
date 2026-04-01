import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Create_Post/presentation/manager/cubit/create_post_cubit.dart';
import 'package:archilink/features/Create_Post/presentation/views/widgets/create_post_action_button.dart';
import 'package:flutter/material.dart';
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
          Row(children: [Text('Audience', style: AppTextStyle.interMedium14,)]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              SizedBox(width: 12),
              CreatePostActionButton(
                icon: Assets.assetsIconsEyeFill,
                text: state.privacy == 'private' ? 'Private' : 'Public',
                onPressed: () {
                  context.read<CreatePostCubit>().togglePrivacy();
                },
                color: state.privacy == 'private'
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
