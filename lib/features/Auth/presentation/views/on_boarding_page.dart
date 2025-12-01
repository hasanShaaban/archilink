import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/widgets/auth_button.dart';
import 'package:archilink/features/Auth/presentation/views/widgets/on_boarding_welcome_section.dart';
import 'package:flutter/material.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.onLoginPressed,
    required this.onSignupPressed,
  });
  final VoidCallback onLoginPressed;
  final VoidCallback onSignupPressed;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 27.5),
      child: Column(
        children: [
          SizedBox(height: height * 271 / 896),
          OnBoardingWelcomeSection(),
          Spacer(),
          AuthButton(
            onPressed: onLoginPressed,
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
            onPressed: onSignupPressed,
            height: height,
            content: Text(
              'Sign Up',
              style: AppTextStyle.mallannaSemiBold17.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            secondary: true,
          ),
          SizedBox(height: height * 60 / 896,)
        ],
      ),
    );
  }
}

