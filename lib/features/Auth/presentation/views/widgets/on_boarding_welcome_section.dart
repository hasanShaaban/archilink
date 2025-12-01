import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class OnBoardingWelcomeSection extends StatelessWidget {
  const OnBoardingWelcomeSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Hey, Welcome to ArchiLink',
          style: AppTextStyle.manjariBold25.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 16,),
        Text(
          'Where you can find a helpful, lovely and \nsupportive Architectural Community',
          style: AppTextStyle.mallannaSemiBold14.copyWith(
            color: Theme.of(context).colorScheme.tertiary,
            height: 19 / 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
