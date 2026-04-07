import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Edit_Profile/presentation/manager/cubit/edit_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileAccountTypeButton extends StatelessWidget {
  const EditProfileAccountTypeButton({
    super.key,
  });

  static const String _student = 'Student';
  static const String _mentor = 'Mentor';

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditProfileCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Account Type',
            style: AppTextStyle.interMedium12.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          BlocBuilder<EditProfileCubit, EditProfileState>(
            buildWhen: (prev, next) =>
                prev.accountType != next.accountType,
            builder: (context, state) {
              return PopupMenuButton<String>(
                menuPadding: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                color: Theme.of(context).scaffoldBackgroundColor,
                elevation: 2,
                offset: const Offset(0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withOpacity(0.16),
                  ),
                ),
                onSelected: cubit.updateAccountType,
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: _student,
                    child: Text(_student),
                  ),
                  PopupMenuItem(
                    value: _mentor,
                    child: Text(_mentor),
                  ),
                ],
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.accountType,
                      style: AppTextStyle.interRegular12.copyWith(
                        color: AppColorsFromTheme.grayForText(
                          context,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
