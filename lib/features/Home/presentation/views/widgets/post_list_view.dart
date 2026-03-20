import 'package:archilink/core/utils/fakers.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Post/presentation/view/post.dart';
import 'package:archilink/features/Post_Details/presentation/view/post_details_view.dart';
import 'package:archilink/features/Profile/presentation/manager/bloc/profile_bloc.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state.failure != null) {
          return Center(child: Text(state.failure!.message));
        }
        bool isSkeleton = state.isInitialLoading && state.profilePosts.isEmpty;
        final List<PostEntity> posts = isSkeleton
            ? List<PostEntity>.generate(5, (index) => fakePostEntity(id: index))
            : state.profilePosts;
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: posts.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Skeletonizer(
                    enabled: isSkeleton,
                    child: Post(
                      entity: posts[index],
                      lang: lang,
                      width: width,
                      height: height,
                      onPostTapped: () {
                        isSkeleton
                            ? null
                            : Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pushNamed(
                                PostDetailsView.name,
                                arguments: {'post': posts[index]},
                              );
                      },
                      withDetails: false,
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
