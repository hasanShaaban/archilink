
import 'package:archilink/features/Home/presentation/views/widgets/ads_section.dart';
import 'package:flutter/material.dart';

class ForYouPage extends StatelessWidget {
  const ForYouPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        AdsSection(),
        const SizedBox(height: 20),
        
      ],
    );
  }
}



