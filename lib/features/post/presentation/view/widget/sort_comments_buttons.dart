import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SortCommentsButton extends StatelessWidget {
  const SortCommentsButton({
    super.key,
    required this.lang,
  });

  final S lang;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(children: [
        Text(lang.sortComments, style: AppTextStyle.interSemiBold12),
        SizedBox(width: 8),
        SvgPicture.asset(Assets.assetsIconsDownArrow, color: Theme.of(context).colorScheme.onSurface, width: 16,)
      ],),
    );
  }
}
