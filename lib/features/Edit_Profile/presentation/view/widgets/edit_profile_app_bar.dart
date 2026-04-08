import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Edit_Profile/presentation/manager/cubit/edit_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileAppBar extends StatelessWidget {
  const EditProfileAppBar({
    super.key,
    required this.titel,
    this.onDone,
    required this.withDoneButton,
    this.backButtonIcon = Icons.close_outlined,
    this.canSubmitOverride,
  });
  final String titel;
  final VoidCallback? onDone;
  final bool withDoneButton;
  final IconData backButtonIcon;
  final bool? canSubmitOverride;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      buildWhen: (prev, next) => prev.hasChanges != next.hasChanges,
      builder: (context, state) {
        final canSubmit = canSubmitOverride ?? state.hasChanges;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    backButtonIcon,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Text(
                titel,
                style: AppTextStyle.interSemiBold16.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Spacer(),
              if (withDoneButton)
                TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: canSubmit
                        ? Theme.of(context).colorScheme.primary
                        : AppColorsFromTheme.grayForTheme(context),
                  ),
                  onPressed: canSubmit ? (onDone ?? () {}) : null,
                  child: Text(
                    'Done',
                    style: AppTextStyle.interMedium16.copyWith(
                      color: canSubmit
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
