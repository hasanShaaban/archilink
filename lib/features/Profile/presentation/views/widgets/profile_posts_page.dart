import 'package:archilink/features/Home/presentation/views/widgets/post_list_view.dart';
import 'package:archilink/features/Profile/presentation/manager/bloc/profile_bloc.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePostsPage extends StatelessWidget {
  const ProfilePostsPage({super.key, required this.width, required this.height});
  final double width, height;

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return PostListView(
          lang: lang,
          width: width,
          height: height,
          posts: state.profilePosts,
          isInitialLoading: state.isInitialLoading,
          isLoadingMore: state.isLoadingMore,
          failureMessage: state.failure?.message,
          onLoadMore: () =>
              context.read<ProfileBloc>().add(LoadMoreProfilePosts()),
        );
      },
    );
  }
}
