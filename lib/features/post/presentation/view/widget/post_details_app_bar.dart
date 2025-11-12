import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PostDetailsAppBar extends StatelessWidget {
  const PostDetailsAppBar({
    super.key,
    required this.lang,
  });

  final S lang;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: 16,
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            radius: 24,
            borderRadius: BorderRadius.circular(12),
            child: SvgPicture.asset(
              Assets.assetsIconsBack,
              color: Theme.of(context).colorScheme.onSurface,
              width: 24,
            ),
          ),
          SizedBox(width: 26),
          Text(
            'Hasan shaaban\'s ${lang.post}',
            style: AppTextStyle.interSemiBold16,
          ),
        ],
      ),
    );
  }
}
