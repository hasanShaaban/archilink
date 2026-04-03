import 'package:archilink/features/Home/presentation/views/widgets/post_list_view.dart';
import 'package:archilink/features/Home/domain/entity/feed_item.dart';
import 'package:archilink/features/Home/presentation/manager/bloc/for_you_bloc.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowingPostsPage extends StatefulWidget {
  const FollowingPostsPage({super.key});

  @override
  State<FollowingPostsPage> createState() => _FollowingPostsPageState();
}

class _FollowingPostsPageState extends State<FollowingPostsPage> {
  @override
  void initState() {
    context.read<ForYouBloc>().add(LoadInitital());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ForYouBloc>().add(RefreshFeed());
      },
      child: BlocBuilder<ForYouBloc, ForYouState>(
        builder: (context, state) {
          final posts = state.items
              .whereType<PostItem>()
              .map((item) => item.post)
              .toList();
          return PostListView(
            lang: lang,
            width: width,
            height: height,
            posts: posts,
            isInitialLoading: state.isInitialLoading,
            isLoadingMore: state.isLoadingMore,
            failureMessage: state.failure?.message,
            onLoadMore: () => context.read<ForYouBloc>().add(LoadMore()),
          );
        },
      ),
    );
  }
}
