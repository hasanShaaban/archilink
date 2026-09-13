import 'package:archilink/features/settings/presentation/manager/cubit/followers_and_following_cubit.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/followers_and_following_state.dart';
import 'package:archilink/features/settings/presentation/views/widgets/empty_followers_view.dart';
import 'package:archilink/features/settings/presentation/views/widgets/follower_tile.dart';
import 'package:archilink/features/settings/presentation/views/widgets/request_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncomingRequestsTab extends StatelessWidget {
  const IncomingRequestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FollowersAndFollowingCubit, FollowersAndFollowingState>(
      listenWhen: (previous, current) =>
          previous.incomingRequestsErrorMessage !=
              current.incomingRequestsErrorMessage &&
          current.incomingRequestsErrorMessage != null,
      listener: (context, state) {
        final message = state.incomingRequestsErrorMessage;
        if (message == null) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      },
      builder: (context, state) {
        if (state.isLoadingIncomingRequests &&
            !state.hasIncomingRequestsData) {
          return const Center(child: CircularProgressIndicator());
        }

        final requests = state.incomingRequests;
        if (requests.isEmpty) {
          return const EmptyFollowersView(
            message: 'No incoming requests yet',
          );
        }

        return RefreshIndicator(
          onRefresh: () => context
              .read<FollowersAndFollowingCubit>()
              .fetchIncomingRequests(refresh: true),
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 160) {
                context
                    .read<FollowersAndFollowingCubit>()
                    .fetchIncomingRequests();
              }
              return false;
            },
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount:
                  requests.length + (state.isLoadingMoreIncomingRequests ? 1 : 0),
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                if (index == requests.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final request = requests[index];
                return FollowerTile(
                  user: request.toUserEntity(),
                  action: RequestActions(
                    onAccept: () {
                      context
                          .read<FollowersAndFollowingCubit>()
                          .removeIncomingRequest(request.id);
                    },
                    onRemove: () {
                      context
                          .read<FollowersAndFollowingCubit>()
                          .removeIncomingRequest(request.id);
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
