
import 'package:archilink/features/Home/presentation/views/widgets/post_list_view.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';

class FeedSection extends StatelessWidget {
  const FeedSection({super.key, required this.lang});
  final S lang;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        const SizedBox(height: 8),
        PostListView(lang: lang, width: width, height: height)
      ],
    );
  }
}