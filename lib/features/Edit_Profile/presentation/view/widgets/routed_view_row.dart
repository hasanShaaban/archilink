import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class RoutedViewRow extends StatelessWidget {
  const RoutedViewRow({super.key, required this.title, required this.route});
  final String title, route;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 17, horizontal: 16),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyle.interMedium12.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(
            width: 16,
            height: 16,
            child: MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pushNamed(route);
              },
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: AppColorsFromTheme.grayForText(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}