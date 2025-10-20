import 'package:flutter/material.dart';

class PostImagesListView extends StatelessWidget {
  const PostImagesListView({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.all(4),
        width: width * 150 / 402,
        height: width * 150 / 402,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      itemCount: 5,
    );
  }
}

