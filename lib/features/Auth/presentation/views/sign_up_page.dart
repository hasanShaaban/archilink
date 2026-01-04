import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/core/widgets/auth_button.dart';
import 'package:archilink/core/widgets/auth_text_field.dart';
import 'package:archilink/features/Auth/presentation/manager/controller/auth_flow_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key, required this.onLoginTap, required this.controller});

  final VoidCallback onLoginTap;
  final AuthFlowController controller;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(height: height * 37 / 896),
        // AuthTextFiled(
        //   height: height,
        //   label: 'Email​ Address',
        //   hint: 'email@gmail.com',
        // ),
        SizedBox(height: 16),
        // AuthTextFiled(
        //   height: height,
        //   label: 'Password',
        //   hint: 'Your Password',
        //   isPassword: true,
        // ),
        SizedBox(height: 16),
        // AuthTextFiled(
        //   height: height,
        //   label: 'Confirm Password',
        //   hint: 'Your Password',
        //   isPassword: true,
        // ),
        SizedBox(height: height * 42 / 896),
        AuthButton(
          height: height,
          content: Text(
            'Continue',
            style: AppTextStyle.mallannaSemiBold17.copyWith(
              color: AppColors.whiteForElements,
            ),
          ),
          onPressed: controller.toSetupAccount,
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppColorsFromTheme.lightGray(context),
                thickness: 0.5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 19),
              child: Text(
                'Or With',
                style: AppTextStyle.mallannaSemiBold14.copyWith(
                  color: AppColorsFromTheme.lightGray(context),
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppColorsFromTheme.lightGray(context),
                thickness: 0.5,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        AuthButton(
          height: height,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                Assets.assetsIconsGoogle,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 10),
              Text(
                'Google',
                style: AppTextStyle.mallannaSemiBold14.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          onPressed: () {},
          secondary: true,
        ),
        
      ],
    );
  }
}
