import 'package:archilink/features/Search/presentation/manager/cubit/search_cubit.dart';
import 'package:archilink/features/Search/presentation/views/widgets/post_search_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsResultsTab extends StatelessWidget {
  const PostsResultsTab({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state.posts.isEmpty) {
          return const Center(child: Text('No posts found'));
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.pixels >=
                notification.metrics.maxScrollExtent - 200) {
              context.read<SearchCubit>().loadMorePosts();
            }
            return false;
          },
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 12, left: 20, right: 20),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index >= state.posts.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return PostSearchItem(width: width, post: state.posts[index]);
            },
            itemCount: state.posts.length + (state.isLoadingMorePosts ? 1 : 0),
          ),
        );
      },
    );
  }
}
