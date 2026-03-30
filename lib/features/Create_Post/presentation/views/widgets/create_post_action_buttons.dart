import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Create_Post/presentation/manager/cubit/create_post_cubit.dart';
import 'package:archilink/features/Create_Post/presentation/views/widgets/create_post_action_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePostActionButtons extends StatelessWidget {
  const CreatePostActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CreatePostActionButton(
            icon: Assets.assetsIconsAddTags,
            text: 'Add Tags',
            onPressed: () {
              context.read<CreatePostCubit>().toggleAddingTag(true);
            },
          ),
          CreatePostActionButton(
            icon: Assets.assetsIconsAddImage,
            text: 'Add Photos',
            onPressed: () =>
                context.read<CreatePostCubit>().pickImages(context),
          ),
          CreatePostActionButton(
            icon: Assets.assetsIconsAddLocation,
            text: 'Add Location',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
