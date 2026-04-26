import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class EmptyFollowersView extends StatelessWidget {
  const EmptyFollowersView({
    super.key,
    this.message = 'No followers yet',
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: AppTextStyle.interMedium14.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

