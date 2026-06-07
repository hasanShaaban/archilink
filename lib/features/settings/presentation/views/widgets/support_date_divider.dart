import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class SupportDateDivider extends StatelessWidget {
  final String date;

  const SupportDateDivider({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
              thickness: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              date,
              style: AppTextStyle.interMedium12.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
