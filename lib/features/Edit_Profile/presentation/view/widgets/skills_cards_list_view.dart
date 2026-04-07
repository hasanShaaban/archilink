import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Edit_Profile/presentation/manager/cubit/edit_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SkillsCardsListView extends StatelessWidget {
  const SkillsCardsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<EditProfileCubit, EditProfileState>(
        buildWhen: (prev, next) => prev.skills != next.skills,
        builder: (context, state) {
          if (state.skills.isEmpty) {
            return Center(
              child: Text(
                'No skills yet',
                style: AppTextStyle.interSemiBold12.copyWith(
                  color: AppColorsFromTheme.grayForText(context),
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  color: AppColorsFromTheme.editProfileContainer(context),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      skill,
                      style: AppTextStyle.interRegular12.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        context.read<EditProfileCubit>().removeSkill(index);
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
          );
        },
      ),
    );
  }
}
