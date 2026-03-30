import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Create_Post/presentation/manager/cubit/create_post_cubit.dart';
import 'package:archilink/features/Create_Post/presentation/views/widgets/create_post_tags_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTagsTextField extends StatelessWidget {
  const AddTagsTextField({
    super.key,
    required this.widget,
    required this.controller,
  });

  final CreatePostTagsSection widget;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
