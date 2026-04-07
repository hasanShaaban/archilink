import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Edit_Profile/presentation/manager/cubit/edit_profile_cubit.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/edit_profile_add_button.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/edit_profile_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AcademicExperianceView extends StatelessWidget {
  const AcademicExperianceView({super.key});
  static const name = '/academicExperiance';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            EditProfileAppBar(
              titel: 'Academic Experiance',
              withDoneButton: false,
              backButtonIcon: Icons.arrow_back_ios_new_rounded,
            ),
            EditProfileAddButton(
              onPressed: () {},
              title: 'Add Academic Experience',
            ),
            SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<EditProfileCubit, EditProfileState>(
                buildWhen: (previous, current) =>
                    previous.academicExperiences != current.academicExperiences,
                builder: (context, state) {
                  if (state.academicExperiences.isEmpty) {
                    return Center(
                      child: Text(
                        'No Academic experiance yet',
                        style: AppTextStyle.interSemiBold12.copyWith(
                          color: AppColorsFromTheme.grayForText(context),
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    itemBuilder: (context, index) {
                      final academicExperiance =
                          state.academicExperiences[index];
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  academicExperiance.university,
                                  style: AppTextStyle.interRegular12.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                                Text(
                                  '${academicExperiance.degree} of ${academicExperiance.fieldOfStudy}',
                                  style: AppTextStyle.interRegular12.copyWith(
                                    height: 1.6,
                                    color: AppColorsFromTheme.grayForText(
                                      context,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${academicExperiance.startYear} - ${academicExperiance.endYear ?? 'Present'}',
                                  style: AppTextStyle.interRegular12.copyWith(
                                    color: AppColorsFromTheme.grayForText(
                                      context,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                context
                                    .read<EditProfileCubit>()
                                    .removeAcademicExperience(index);
                              },
                              child: Icon(
                                Icons.close_rounded,
                                size: 24,
                                color: AppColors.red,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => SizedBox(height: 10),
                    itemCount: state.academicExperiences.length,
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
