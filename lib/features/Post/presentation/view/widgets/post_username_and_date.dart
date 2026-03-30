import 'package:archilink/core/functions/post_date_formater.dart';
import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Post/domain/entity/post_owner_entity.dart';
import 'package:flutter/material.dart';

class PostUserNameAndDate extends StatelessWidget {
  const PostUserNameAndDate({super.key, required this.withDetails, required this.date, required this.owner});
  final bool withDetails;
  final String date;
  final PostOwnerEntity owner;
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: owner.name, //-----------------name
        style: AppTextStyle.interMedium14.copyWith(color: Theme.of(context).colorScheme.onSurface),
        children: [
          !withDetails? TextSpan(
            text: '  ${formatPostDate(date)}', //-----------------date
            style: AppTextStyle.interMedium14.copyWith(
              color: AppColorsFromTheme.grayForText(context),
            ),
          ): const TextSpan(),
        ],
      ),
    );
  }
}
