
import 'package:archilink/features/Home/presentation/views/widgets/ads_section.dart';
import 'package:archilink/features/Home/presentation/views/widgets/featured_member_section.dart';
import 'package:archilink/features/Home/presentation/views/widgets/post_section.dart';
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



