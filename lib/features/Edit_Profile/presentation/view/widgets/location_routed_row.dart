import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class LocationRoutedRow extends StatelessWidget {
  const LocationRoutedRow({
    super.key,
    required this.title,
    required this.route,
    this.value,
  });

  final String title;
  final String route;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.trim().isNotEmpty;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: AppColorsFromTheme.lightGray(context),
        highlightColor: AppColorsFromTheme.grayForTheme(context),
        onTap: () {
          Navigator.of(context, rootNavigator: true).pushNamed(route);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyle.interMedium12.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Expanded(
                child: Text(
                  hasValue ? value!.trim() : '',
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.interRegular12.copyWith(
                    color: AppColorsFromTheme.grayForText(context),
                  ),
                ),
              ),
              if (!hasValue)
                SizedBox(
                  width: 16,
                  height: 16,
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: AppColorsFromTheme.grayForText(context),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
