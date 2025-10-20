import 'package:archilink/core/widgets/expandable_text.dart';
import 'package:archilink/core/widgets/post_image_listview.dart';
import 'package:flutter/material.dart';

class PostBody extends StatelessWidget {
  const PostBody({super.key, required this.width, required this.height});

  final double width, height;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: width * 305 / 402,
          child: ExpandableText(
            //-----------------body
            'Sometimes being an INFP feels like your heart is a sponge, soaking up everyone else’s emotions while you’re still figuring out how to handle your own. Sometimes being an INFP feels like your heart is a sponge, soaking up everyone else’s emotions while you’re still figuring out how to handle your own.',
          ),
        ),
        SizedBox(
          height: height * 158 / 847,
          child: PostImagesListView(width: width),
        ),
      ],
    );
  }
}
