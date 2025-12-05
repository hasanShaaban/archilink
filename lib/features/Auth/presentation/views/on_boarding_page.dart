import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/widgets/auth_button.dart';
import 'package:archilink/features/Auth/presentation/manager/controller/auth_flow_controller.dart';
import 'package:archilink/features/Auth/presentation/views/widgets/on_boarding_welcome_section.dart';
import 'package:flutter/material.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key, required this.controller,

  });

  final AuthFlowController controller;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(height: height * 251 / 896),
        OnBoardingWelcomeSection(),
        SizedBox(height: height * 311/896,),
        AuthButton(
          onPressed: controller.toLogin,
          height: height,
          content: Text(
            'Login',
            style: AppTextStyle.mallannaSemiBold17.copyWith(
              color: AppColors.whiteForElements,
            ),
          ),
        ),
        SizedBox(height: 10),
        AuthButton(
          onPressed: controller.toSignup,
          height: height,
          content: Text(
            'Sign Up',
            style: AppTextStyle.mallannaSemiBold17.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          secondary: true,
        ),
      ],
    );
  }
}

