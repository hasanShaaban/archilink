import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/followers_and_following_cubit.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/followers_and_following_state.dart';
import 'package:archilink/features/settings/presentation/views/widgets/empty_followers_view.dart';
import 'package:archilink/features/settings/presentation/views/widgets/follower_tile.dart';
import 'package:archilink/features/settings/presentation/views/widgets/single_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OutgoingRequestsTab extends StatelessWidget {
  const OutgoingRequestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FollowersAndFollowingCubit, FollowersAndFollowingState>(
      listenWhen: (previous, current) =>
          previous.outgoingRequestsErrorMessage !=
              current.outgoingRequestsErrorMessage &&
          current.outgoingRequestsErrorMessage != null,
      listener: (context, state) {
        final message = state.outgoingRequestsErrorMessage;
        if (message == null) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      },
      builder: (context, state) {
        if (state.isLoadingOutgoingRequests &&
            !state.hasOutgoingRequestsData) {
          return const Center(child: CircularProgressIndicator());
        }

        final requests = state.outgoingRequests;
        if (requests.isEmpty) {
          return const EmptyFollowersView(
            message: 'No outgoing requests yet',
          );
        }

        return RefreshIndicator(
          onRefresh: () => context
              .read<FollowersAndFollowingCubit>()
              .fetchOutgoingRequests(refresh: true),
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 160) {
                context
                    .read<FollowersAndFollowingCubit>()
                    .fetchOutgoingRequests();
              }
              return false;
            },
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount:
                  requests.length + (state.isLoadingMoreOutgoingRequests ? 1 : 0),
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
                  action: SingleActionButton(
                    label: 'Cancel',
                    onPressed: () {
                      context
                          .read<FollowersAndFollowingCubit>()
                          .removeOutgoingRequest(request.id);
                    },
                    color: AppColorsFromTheme.grayForTheme(context),
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
