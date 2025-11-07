import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class PostUserNameAndDate extends StatelessWidget {
  const PostUserNameAndDate({super.key, required this.withDetails});
  final bool withDetails;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'Hasan Shaaban', //-----------------name
        style: AppTextStyle.interMedium14.copyWith(color: Theme.of(context).colorScheme.onSurface),
        children: [
          !withDetails? TextSpan(
            text: '  3 Oct', //-----------------date
            style: AppTextStyle.interMedium14.copyWith(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ): const TextSpan(),
        ],
      ),
    );
  }
}

