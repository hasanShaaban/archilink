import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Create_Post/presentation/manager/cubit/create_post_cubit.dart';
import 'package:archilink/features/Create_Post/presentation/views/widgets/add_tags_text_field.dart';
import 'package:archilink/features/Create_Post/presentation/views/widgets/save_tags_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class _CreatePostTagsSectionState extends State<CreatePostTagsSection>
    with TickerProviderStateMixin {
  final TextEditingController controller = TextEditingController();
  final List<String> suggestedTags = const [
    'Project',
    '3D Max',
    'AutoCAD',
    'Architecture',
  ];
  @override
  Widget build(BuildContext context) {
    final isVisible = widget.state.isAddingTag;
    return IgnorePointer(
      ignoring: !isVisible,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        opacity: isVisible ? 1 : 0,
        child: ClipRect(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: isVisible ? 1 : 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AddTagsTextField(widget: widget, controller: controller),
                  widget.state.tags.isEmpty
                      ? const SizedBox.shrink()
                      : Column(
                          children: [
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: [
                                    for (
                                      int i = 0;
                                      i < widget.state.tags.length;
                                      i++
                                    )
                                      _buildTagChip(
                                        context,
                                        widget.state.tags[i],
                                        i,
                                        widget.state,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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
                  SizedBox(height: 16),
                  SaveTagsButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTagChip(
    BuildContext context,
    String tag,
    int index,
    CreatePostState state,
  ) {
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: AppColorsFromTheme.grayForTheme(context),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            tag,
            style: AppTextStyle.interRegular12.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
