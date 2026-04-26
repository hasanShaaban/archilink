import 'package:archilink/features/settings/presentation/manager/cubit/followers_and_following_cubit.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/followers_and_following_state.dart';
import 'package:archilink/features/settings/presentation/views/widgets/empty_followers_view.dart';
import 'package:archilink/features/settings/presentation/views/widgets/followers_list_view.dart';
import 'package:archilink/features/settings/presentation/views/widgets/single_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowersTab extends StatelessWidget {
  const FollowersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FollowersAndFollowingCubit, FollowersAndFollowingState>(
      listenWhen: (previous, current) =>
          previous.followersErrorMessage != current.followersErrorMessage &&
          current.followersErrorMessage != null,
      listener: (context, state) {
        final message = state.followersErrorMessage;
        if (message == null) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      },
      builder: (context, state) {
        if (state.isLoadingFollowers && !state.hasFollowersData) {
          return const Center(child: CircularProgressIndicator());
        }

        final followers = state.followers;
        if (followers.isEmpty) {
          return const EmptyFollowersView();
        }

        return RefreshIndicator(
          onRefresh: () =>
              context.read<FollowersAndFollowingCubit>().fetchFollowers(
                refresh: true,
              ),
          child: FollowersListView(
            users: followers,
            isLoadingMore: state.isLoadingMoreFollowers,
            onLoadMore: () =>
                context.read<FollowersAndFollowingCubit>().fetchFollowers(),
            actionBuilder: (user) => SingleActionButton(
              label: user.isFollowing ? 'Following' : 'Follow back',
              color: user.isFollowing
                  ? Theme.of(context).colorScheme.primary.withAlpha(150)
                  : Theme.of(context).colorScheme.primary,
              onPressed: () {},
            ),
          ),
        );
      },
    );
  }
}
