// ignore_for_file: deprecated_member_use

import 'package:archilink/core/functions/snack_bar_builder.dart';
import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/check_username_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.height,
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.isPassword = false,
    this.errorText,
    this.onChanged,
    this.onSaved,
    this.textInputAction,
  });

  final double height;
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool isPassword;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final FormFieldSetter<String>? onSaved;
  final TextInputAction? textInputAction;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscureText = true;
  bool _hasFocus = false;

  Color _borderColor(BuildContext context) {
    if (!_hasFocus) {
      return AppColorsFromTheme.secondaryColor(context).withOpacity(0.5);
    }

    if (widget.errorText != null) {
      return AppColors.red;
    }

    return Theme.of(context).colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final fieldHeight = widget.height * 41 / 896;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTextStyle.mallannaSemiBold14),

        Focus(
          onFocusChange: (focus) {
            setState(() => _hasFocus = focus);
          },
          child: SizedBox(
            height: fieldHeight,
            width: double.infinity,
            child: TextFormField(
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              obscureText: widget.isPassword ? _obscureText : false,
              textInputAction: widget.textInputAction,
              onChanged: (value) {
                widget.onChanged?.call(value);
              },
              onSaved: widget.onSaved,
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: AppTextStyle.mallannaSemiBold14.copyWith(
                  color: AppColors.lightGrayDarkMode,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: buildBorder(_borderColor(context)),
                enabledBorder: buildBorder(_borderColor(context)),
                focusedBorder: buildBorder(_borderColor(context)),
                filled: true,
                fillColor: AppColorsFromTheme.secondaryColor(
                  context,
                ).withOpacity(0.5),
                suffixIcon: widget.isPassword
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        icon: SvgPicture.asset(Assets.assetsIconsEyeFill),
                      )
                    : null,
              ),
            ),
          ),
        ),

        /// Error container (does NOT affect text field height)
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: Alignment.topLeft,
          child: widget.errorText != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.errorText!,
                      style: AppTextStyle.interRegular10.copyWith(
                        color: AppColors.red,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}

OutlineInputBorder buildBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color, width: 1.5),
  );
}

class AuthUsernameField extends StatefulWidget {
  const AuthUsernameField({
    super.key,
    required this.height,
    required this.label,
    required this.hint,
    required this.controller,
    this.onChanged,
    required this.isUsernameTaken,
    this.errorText,
  });

  final double height;
  final String label;
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final bool isUsernameTaken;
  final String? errorText;

  @override
  State<AuthUsernameField> createState() => _AuthUsernameFieldState();
}

class _AuthUsernameFieldState extends State<AuthUsernameField>
    with TickerProviderStateMixin {
  bool _hasFocus = false;

  Color _borderColor(BuildContext context) {
    if (widget.isUsernameTaken) {
      return AppColors.red;
    }
    if (_hasFocus) {
      return Theme.of(context).colorScheme.primary;
    }
    return AppColorsFromTheme.secondaryColor(context).withOpacity(0.5);
  }

  @override
  Widget build(BuildContext context) {
    final fieldHeight = widget.height * 41 / 896;

    return BlocConsumer<CheckUsernameCubit, CheckUsernameState>(
      listener: (context, state) {
        if (state is CheckUsernameFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(appSnackBar(context, state.failure, state.message));
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.label, style: AppTextStyle.mallannaSemiBold14),

            const SizedBox(height: 6),

            Focus(
              onFocusChange: (focus) {
                setState(() => _hasFocus = focus);
              },
              child: SizedBox(
                height: fieldHeight,
                width: double.infinity,
                child: TextField(
                  controller: widget.controller,
                  onChanged: widget.onChanged,
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: AppTextStyle.mallannaSemiBold14.copyWith(
                      color: AppColors.lightGrayDarkMode,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: buildBorder(_borderColor(context)),
                    enabledBorder: buildBorder(_borderColor(context)),
                    focusedBorder: buildBorder(_borderColor(context)),
                    filled: true,
                    fillColor: AppColorsFromTheme.secondaryColor(
                      context,
                    ).withOpacity(0.5),
                  ),
                ),
              ),
            ),

            /// Custom error container (does NOT affect field size)
            AnimatedSize(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              alignment: Alignment.topLeft,
              child:
                  widget.errorText != null ||
                      state is CheckUsernameAvailable ||
                      state is CheckUsernameTaken ||
                      state is CheckUsernameLoading ||
                      state is CheckUsernameFailure
                  ? Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:widget.errorText != null ?AppColors.red.withOpacity(0.1):
                              state is CheckUsernameAvailable ||
                                  state is CheckUsernameLoading
                              ? Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.1)
                              :AppColors.red.withOpacity(0.1),

                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: state is CheckUsernameLoading
                            ? SizedBox(
                                height: 11,
                                width: 11,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1,
                                ),
                              )
                            : Text(
                                widget.errorText != null
                                    ? widget.errorText!
                                    : state is CheckUsernameTaken
                                    ? 'This username is already in use'
                                    : state is CheckUsernameAvailable
                                    ? 'accepted'
                                    : state is CheckUsernameFailure
                                    ? state.message
                                    : '',
                                style: AppTextStyle.interRegular10.copyWith(
                                  color:
                                      widget.errorText != null ||
                                          state is CheckUsernameTaken
                                      ? AppColors.red
                                      : state is CheckUsernameAvailable
                                      ? Theme.of(context).colorScheme.primary
                                      : AppColors.red,
                                ),
                              ),
                      ),
                    )
                  : const SizedBox(),
            ),
          ],
        );
      },
    );
  }
}
