import 'package:archilink/features/Home/presentation/views/widgets/post_list_view.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';

class FollowingPostsPage extends StatelessWidget {
  const FollowingPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return PostListView(lang: lang, width: width, height: height);
  }
}