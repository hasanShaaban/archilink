import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Edit_Profile/presentation/manager/cubit/edit_profile_cubit.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/edit_profile_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SkillsView extends StatefulWidget {
  const SkillsView({super.key});
  static const name = '/skills';

  @override
  State<SkillsView> createState() => _SkillsViewState();
}

class _SkillsViewState extends State<SkillsView>
    with TickerProviderStateMixin {
  bool showInput = false;
  FocusNode focusNode = FocusNode();
  late final TextEditingController skillController;

  @override
  void initState() {
    skillController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    skillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    final cubit = context.read<EditProfileCubit>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            EditProfileAppBar(titel: 'Skills'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    showInput = !showInput;
                  });
                },
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: AppColorsFromTheme.borderColor(context),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.5,
                    horizontal: 24,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        Assets.assetsIconsAdd,
                        width: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      SizedBox(width: 16),
                      Text(
                        showInput ? 'Cancel' : 'Add skill',
                        style: AppTextStyle.interSemiBold12.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedSize(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: showInput ? 1 : 0,
                  child: Padding(
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
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<EditProfileCubit, EditProfileState>(
                buildWhen: (prev, next) => prev.skills != next.skills,
                builder: (context, state) {
                  if (state.skills.isEmpty) {
                    return Center(
                      child: Text(
                        'No skills yet',
                        style: AppTextStyle.interRegular12.copyWith(
                          color: AppColorsFromTheme.grayForText(context),
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    itemCount: state.skills.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final skill = state.skills[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColorsFromTheme.editProfileContainer(
                            context,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              skill,
                              style: AppTextStyle.interRegular12.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface,
                              ),
                            ),
                            Icon(Icons.close_rounded, size: 24, color: AppColors.red,),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

