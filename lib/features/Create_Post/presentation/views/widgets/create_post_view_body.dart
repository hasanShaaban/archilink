import 'dart:developer';

import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/fakers.dart';
import 'package:archilink/features/Create_Post/presentation/manager/cubit/create_post_cubit.dart';
import 'package:archilink/features/Create_Post/presentation/views/widgets/create_post_action_buttons.dart';
import 'package:archilink/features/Create_Post/presentation/views/widgets/create_post_text_field.dart';
import 'package:archilink/features/Create_Post/presentation/views/widgets/post_header_row.dart';
import 'package:archilink/features/Create_Post/presentation/views/widgets/selected_images_list_view.dart';
import 'package:archilink/features/Post/domain/entity/post_owner_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

class CreatePostViewBody extends StatelessWidget {
  final double width, height;
  final FocusNode focusNode;
  const CreatePostViewBody({
    super.key,
    required this.width,
    required this.height,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
      builder: (context, state) {
        final fallbackOwner = fakePostEntity(id: 0).owner;
        final owner = state.profileData == null
            ? fallbackOwner
            : PostOwnerEntity(
                id: 0,
                name: state.profileData!.name,
                username: state.profileData!.username,
                profilePictureUrl: state.profileData!.profilePictureUrl,
              );
        return SingleChildScrollView(
          child: Column(
            children: [
              PostHeaderRow(width: width, owner: owner, state: state),
              SizedBox(height: 12),
              CreatePostTextFiled(width: width),
              SizedBox(height: 12),
              if (state.selectedAssets.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SelectedImagesListView(
                    height: height,
                    images: state.selectedAssets,
                    width: width,
                  ),
                ),

              Divider(height: 0),
              SizedBox(height: 12),
              CreatePostActionButtons(),
              SizedBox(height: 8),
              CreatePostTagsSection(
                height: height,
                focusNode: focusNode,
                state: state,
              ),
            ],
          ),
        );
      },
    );
  }
}

class CreatePostTagsSection extends StatefulWidget {
  const CreatePostTagsSection({
    super.key,
    required this.height,
    required this.focusNode,
    required this.state,
  });

  final double height;
  final FocusNode focusNode;
  final CreatePostState state;

  @override
  State<CreatePostTagsSection> createState() => _CreatePostTagsSectionState();
}

class _CreatePostTagsSectionState extends State<CreatePostTagsSection> {
  final TextEditingController controller = TextEditingController();
  final List<String> suggestedTags = const [
    'Project',
    '3D Max',
    'AutoCAD',
    'Architecture',
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: widget.height * 75 / 874,
            child: TextField(
              controller: controller,
              focusNode: widget.focusNode,
              maxLength: 15,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              buildCounter:
                  (
                    context, {
                    required int currentLength,
                    required bool isFocused,
                    required int? maxLength,
                  }) {
                    final limit = maxLength ?? 15;
                    return Text(
                      '$currentLength/$limit',
                      style: AppTextStyle.interRegular12.copyWith(
                        color: AppColorsFromTheme.grayForText(context),
                      ),
                    );
                  },
              onTapOutside: (event) {
                widget.focusNode.unfocus();
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                filled: true,
                fillColor: AppColorsFromTheme.grayForTheme(context),
                hintText: 'Enter new Tag',
                hintStyle: AppTextStyle.interRegular12.copyWith(
                  color: AppColorsFromTheme.grayForText(context),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(16),
                ),

                suffix: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      final value = controller.text.trim();
                      if (value.isEmpty) return;
                      if (value.length > 15) return;
                      context.read<CreatePostCubit>().addTag(value);
                      controller.clear();
                    },
                    child: Text(
                      'Add',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.interSemiBold12.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (widget.state.tags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (int i = 0; i < widget.state.tags.length; i++)
                    _buildTagChip(context, widget.state.tags[i], i),
                ],
              ),
            ),
          ),
          
        ],
        SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Suggested Tags',
              style: AppTextStyle.interSemiBold12.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final tag in suggestedTags)
                  _buildSuggestedChip(context, tag),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTagChip(BuildContext context, String tag, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            style: AppTextStyle.interRegular12.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              context.read<CreatePostCubit>().removeTag(index);
            },
            child: Icon(
              Icons.close,
              size: 15,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedChip(BuildContext context, String tag) {
    final alreadyAdded = widget.state.tags.contains(tag);
    return Opacity(
      opacity: alreadyAdded ? 0.5 : 1,
      child: InkWell(
        onTap: alreadyAdded
            ? null
            : () {
                context.read<CreatePostCubit>().addTag(tag);
              },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.4),
            ),
          ),
          child: Text(
            tag,
            style: AppTextStyle.interRegular10.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
