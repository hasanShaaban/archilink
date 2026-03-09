import 'package:archilink/core/widgets/post.dart';
import 'package:archilink/features/Post/presentation/view/post_details_view.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';

class PostListView extends StatelessWidget {
  const PostListView({
    super.key,
    required this.lang,
    required this.width,
    required this.height,
  });

  final S lang;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 5,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Post(
                entity: null,
                lang: lang,
                width: width,
                height: height,
                onPostTapped: () {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed(PostDetailsView.name);
                },
                withDetails: false,
              ),
            ),
            Divider(height: 1, color: Theme.of(context).colorScheme.secondary),
          ],
        );
      },
    );
  }
}


