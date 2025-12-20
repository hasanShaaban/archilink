import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class ProfileStatisticsColumn extends StatelessWidget {
  const ProfileStatisticsColumn({
    super.key, required this.title, required this.count,
  });

  final String title, count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: AppTextStyle.interBold20.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
    
        Text(
          title,
          style: AppTextStyle.interRegular12.copyWith(
            color: AppColors.gray,
          ),
        ),
      ],
    );
  }
}