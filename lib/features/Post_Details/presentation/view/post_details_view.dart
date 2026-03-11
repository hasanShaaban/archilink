
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Post_Details/presentation/view/widget/post_details_view_body.dart';
import 'package:flutter/material.dart';

class PostDetailsView extends StatelessWidget {
  const PostDetailsView({super.key, required this.post});

  final PostEntity post;

  static const String name = '/postDetails';

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: PostDetailsViewBody(post : post)));
  }
}

