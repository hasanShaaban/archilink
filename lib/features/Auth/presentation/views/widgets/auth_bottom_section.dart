
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Auth/domain/auth_step.dart';
import 'package:archilink/features/Auth/presentation/manager/controller/auth_flow_controller.dart';
import 'package:flutter/material.dart';

class BottomSection extends StatelessWidget {
  const BottomSection({
    super.key,
    required this.step,
    required this.controller,
  });
  final AuthStep step;
  final AuthFlowController controller;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return step == AuthStep.onboarding? SizedBox() :  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 27.5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                step == AuthStep.login
                    ? 'Don’t have an account? '
                    : 'Already have an account? ',
                style: AppTextStyle.mallannaSemiBold14.copyWith(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              GestureDetector(
                onTap: () => step == AuthStep.login
                    ? controller.toSignup()
                    : controller.toLogin(),
                child: Text(
                  step == AuthStep.login ? 'Sign up' : 'Login',
                  style: AppTextStyle.mallannaSemiBold14.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: height * 41/896,)
        ],
      ),
    );
  }
}
