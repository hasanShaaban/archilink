import 'package:archilink/features/Home/presentation/views/widgets/post_list_view.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';

class ProfilePostsPage extends StatelessWidget {
  const ProfilePostsPage({super.key, required this.width, required this.height});
  final double width, height;

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return PostListView(lang:lang , width: width, height: height);
  }
}