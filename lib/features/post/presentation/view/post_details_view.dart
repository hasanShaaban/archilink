import 'package:flutter/material.dart';

class PostDetailsView extends StatelessWidget {
  const PostDetailsView({super.key});

  static const String name = '/postDetails';

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: PostDetailsViewBody(),
    ));
  }
}

class PostDetailsViewBody extends StatelessWidget {
  const PostDetailsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column();
  }
}