
import 'package:archilink/features/Home/presentation/views/widgets/ads_section.dart';
import 'package:archilink/features/Home/presentation/views/widgets/featured_member_section.dart';
import 'package:flutter/material.dart';

class ForYouPage extends StatelessWidget {
  const ForYouPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 15),
        AdsSection(),
        const SizedBox(height: 20),
        const FeaturedMemberSection(),
      ],
    );
  }
}

