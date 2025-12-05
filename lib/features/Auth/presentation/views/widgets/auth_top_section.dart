import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Auth/domain/auth_step.dart';
import 'package:flutter/material.dart';

class TopSection extends StatelessWidget {
  const TopSection({super.key, required this.step});
  final AuthStep step;

  @override
  Widget build(BuildContext context) {
    return step == AuthStep.onboarding? SizedBox() : Padding(
      padding: EdgeInsetsGeometry.only(top: 75, left: 20, right: 20),
      child: Column(
        children: [
          Text(
            step == AuthStep.login ? 'Hey, Welcome Back!' :
            step == AuthStep.signup ? 'Create an account' :
            step == AuthStep.setupAccount ? 'Set up your account' : '',

            style: AppTextStyle.manjariBold25.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          if(step == AuthStep.signup)
          Text('Connect with Architectural Community today!',
          style: AppTextStyle.mallannaSemiBold14.copyWith(
              color: Theme.of(context).colorScheme.tertiary,
              height: 1,
            ),
          )
        ],
      ),
    );
  }
}
