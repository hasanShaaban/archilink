
import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';

import 'package:flutter/material.dart';

class RememberMeSection extends StatelessWidget {
  const RememberMeSection({super.key, required this.checked, required this.onChanged});

  final bool checked;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            onChanged(!checked);
          },
          child: Stack(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColorsFromTheme.secondaryColor(context),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: AppColorsFromTheme.lightGray(context),
                    width: 1,
                  ),
                ),
              ),
              checked
                  ? Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 20,
                    )
                  : SizedBox(),
            ],
          ),
        ),
        SizedBox(width: 5),
        Text(
          'Remember Me',

          style: AppTextStyle.mallannaSemiBold14.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
