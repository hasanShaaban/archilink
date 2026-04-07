import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Edit_Profile/presentation/manager/cubit/edit_profile_cubit.dart';
import 'package:flutter/material.dart';

class AddSkillTextFiled extends StatelessWidget {
  const AddSkillTextFiled({
    super.key,
    required this.focusNode,
    required this.skillController,
    required this.cubit,
  });

  final FocusNode focusNode;
  final TextEditingController skillController;
  final EditProfileCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      child: TextField(
        focusNode: focusNode,
        onTapOutside: (event) {
          focusNode.unfocus();
        },
        style: AppTextStyle.interRegular12.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        controller: skillController,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          suffix: InkWell(
            onTap: () {
              if (skillController.text.isNotEmpty) {
                cubit.addSkill(skillController.text);
                skillController.clear();
              }
            },
            child: Text(
              'Save Skill',
              style: AppTextStyle.interSemiBold12.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          hintText: 'e.g. AutoCAD',
          filled: true,
          fillColor: AppColorsFromTheme.editProfileContainer(
            context,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 8,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
