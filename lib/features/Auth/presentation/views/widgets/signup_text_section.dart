import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class SignUpTextSection extends StatelessWidget {
  const SignUpTextSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Text(
            'Create an account',
            style: AppTextStyle.manjariBold25.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            'Connect with Architectural Community today!',
            style: AppTextStyle.mallannaSemiBold14.copyWith(
              color: Theme.of(context).colorScheme.tertiary,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
