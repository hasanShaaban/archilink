import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FeaturedMemberItem extends StatelessWidget {
  const FeaturedMemberItem({
    super.key,
    required this.lang,
    required this.width,
    required this.height,
  });

  final S lang;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: lang.local == 'en' ? width * 30 / 402 : 0,
        left: lang.local == 'ar' ? width * 30 / 402 : 0,
      ),
      child: Column(
        children: [
          SizedBox(height: height * 16 / 847),
          Container(
            //-----------------image
            width: width * 100 / 402,
            height: width * 100 / 402,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          SizedBox(
            width: width * 88 / 402,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Adam Hasan', //-----------------name
                    style: AppTextStyle.mallannaRegular14.copyWith(
                      overflow: TextOverflow.ellipsis,
                      height: 1.8
                    ),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        Assets.assetsIconsLocation,
                        width: 12,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      SizedBox(width: 3),
                      SizedBox(
                        width: width * 64 / 402,
                        child: Text(
                          'Aleppo,Syria', //-----------------location
                          style: AppTextStyle.mallannaRegular12.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                            overflow: TextOverflow.ellipsis,
                            height: 1.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 4),
          SizedBox(
            height: height * 28 / 847,
            width: width * 90 / 402,
            child: TextButton(
              onPressed: () {
                //-----------------follow
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    width: 12,
                    Assets.assetsIconsAdd,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  SizedBox(width: 6),
                  Text(lang.follow, style: AppTextStyle.interMedium10.copyWith(color: Theme.of(context).colorScheme.onSurface)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
