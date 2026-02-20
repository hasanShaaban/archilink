
import 'package:archilink/features/Post/presentation/view/widget/post_details_view_body.dart';
import 'package:flutter/material.dart';

class PostDetailsView extends StatelessWidget {
  const PostDetailsView({super.key});

  static const String name = '/postDetails';

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: PostDetailsViewBody()));
  }
}

