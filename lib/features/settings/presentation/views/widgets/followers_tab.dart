import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/features/Profile/domain/entity/follow_status.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/follow_cubit.dart';
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
          onRefresh: () => context
              .read<FollowersAndFollowingCubit>()
              .fetchFollowers(refresh: true),
          child: FollowersListView(
            users: followers,
            isLoadingMore: state.isLoadingMoreFollowers,
            onLoadMore: () =>
                context.read<FollowersAndFollowingCubit>().fetchFollowers(),
            actionBuilder: (user) => BlocProvider<FollowCubit>(
              create: (context) =>
                  sl<FollowCubit>()..setInitial(isFollowing: user.isFollowing),
              child: BlocConsumer<FollowCubit, FollowState>(
                listenWhen: (previous, current) =>
                    previous.errorMessage != current.errorMessage &&
                    current.errorMessage != null,
                listener: (context, state) {
                  final message = state.errorMessage;
                  if (message == null) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                },
                builder: (context, state) {
                  // Determine label and color based on follow status
                  final String label;
                  final Color color;
                  if (!state.isFollowing) {
                    label = 'Follow back';
                    color = Theme.of(context).colorScheme.primary;
                  } else if (state.followStatus == FollowStatus.requested) {
                    label = 'Requested';
                    color = Theme.of(context).colorScheme.primary.withAlpha(150);
                  } else {
                    label = 'Following';
                    color = Theme.of(context).colorScheme.primary.withAlpha(150);
                  }
                  return SingleActionButton(
                    label: label,
                    color: color,
                    onPressed: () {
                      if (state.isFollowing) {
                        context.read<FollowCubit>().unfollow(user.username);
                      } else {
                        context.read<FollowCubit>().follow(user.username);
                      }
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
