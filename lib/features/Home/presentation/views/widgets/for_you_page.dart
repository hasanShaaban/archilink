import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/widgets/post.dart';
import 'package:archilink/features/Home/presentation/views/widgets/ads_section.dart';
import 'package:archilink/features/Home/presentation/views/widgets/featured_member_section.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';

class ForYouPage extends StatelessWidget {
  const ForYouPage({super.key});

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return RefreshIndicator(
      onRefresh: () async {},
      child: ListView(
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 15),
          const AdsSection(),
          const SizedBox(height: 20),
          const FeaturedMemberSection(),
          FeedSection(lang: lang),
        ],
      ),
    );
  }
}

class FeedSection extends StatelessWidget {
  const FeedSection({super.key, required this.lang});
  final S lang;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lang.feed, style: AppTextStyle.manjariRegular20),
          const SizedBox(height: 8),
          ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: 5,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
            return Post(lang: lang, width: width, height: height);
          })
        ],
      ),
    );
  }
}
