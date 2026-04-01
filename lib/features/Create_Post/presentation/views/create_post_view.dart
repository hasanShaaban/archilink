
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Create_Post/presentation/views/widgets/create_post_view_body.dart';
import 'package:archilink/features/Create_Post/presentation/views/widgets/post_button.dart';
import 'package:flutter/material.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key});
  static const name = '/createPost';

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Post',
          style: AppTextStyle.interSemiBold16.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close),
        ),
        actions: [
          PostButton(width: width, height: height),
          SizedBox(width: 20),
        ],
      ),
    
      body: SafeArea(
        child: CreatePostViewBody(
          width: width,
          height: height,
          focusNode: focusNode,
        ),
      ),
    );
  }
}
