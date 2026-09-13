import 'package:archilink/features/Home/presentation/views/widgets/post_list_view.dart';
import 'package:archilink/features/Profile/presentation/manager/bloc/profile_bloc.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePostsPage extends StatelessWidget {
  const ProfilePostsPage({
    super.key,
    required this.width,
    required this.height,
    this.postsVisible = true,
  });

  final double width;
  final double height;

  /// When false (private profile that the viewer does not follow) the posts
  /// list is replaced with a "private account" message.
  final bool postsVisible;

  @override
  Widget build(BuildContext context) {
    if (!postsVisible) {
      return const _PrivateAccountMessage();
    }

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

class _PrivateAccountMessage extends StatelessWidget {
  const _PrivateAccountMessage();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 56,
            color: colorScheme.onSurface.withOpacity(0.35),
          ),
          const SizedBox(height: 16),
          Text(
            'This account is private',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Follow this account to see their posts.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.55),
            ),
          ),
        ],
      ),
    );
  }
}
