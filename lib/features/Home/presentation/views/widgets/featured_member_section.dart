import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Home/presentation/views/widgets/featured_member_item.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';

class FeaturedMemberSection extends StatelessWidget {
  const FeaturedMemberSection({super.key});

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(
        left: lang.local == 'en' ? 20 : 0,
        right: lang.local == 'ar' ? 20 : 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lang.featuredMember, style: AppTextStyle.manjariRegular20),
          const SizedBox(height: 8),
          SizedBox(
            height: height * 210 / 847,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return FeaturedMemberItem(
                  lang: lang,
                  width: width,
                  height: height,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

