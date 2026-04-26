import 'package:archilink/features/settings/presentation/manager/cubit/followers_and_following_cubit.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/followers_and_following_state.dart';
import 'package:archilink/features/settings/presentation/views/widgets/empty_followers_view.dart';
import 'package:archilink/features/settings/presentation/views/widgets/followers_list_view.dart';
import 'package:archilink/features/settings/presentation/views/widgets/single_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowingTab extends StatelessWidget {
  const FollowingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FollowersAndFollowingCubit, FollowersAndFollowingState>(
      listenWhen: (previous, current) =>
          previous.followingErrorMessage != current.followingErrorMessage &&
          current.followingErrorMessage != null,
      listener: (context, state) {
        final message = state.followingErrorMessage;
        if (message == null) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      },
      builder: (context, state) {
        if (state.isLoadingFollowing && !state.hasFollowingData) {
          return const Center(child: CircularProgressIndicator());
        }

        final following = state.following;
        if (following.isEmpty) {
          return const EmptyFollowersView(message: 'No following yet');
        }

        return RefreshIndicator(
          onRefresh: () =>
              context.read<FollowersAndFollowingCubit>().fetchFollowing(
                refresh: true,
              ),
          child: FollowersListView(
            users: following,
            isLoadingMore: state.isLoadingMoreFollowing,
            onLoadMore: () =>
                context.read<FollowersAndFollowingCubit>().fetchFollowing(),
            actionBuilder: (_) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SingleActionButton(
                  label: 'Message',
                  onPressed: () {},
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.close),
                  constraints: const BoxConstraints(maxHeight: 24, maxWidth: 24),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
