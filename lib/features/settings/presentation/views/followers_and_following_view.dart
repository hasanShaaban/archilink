import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/followers_and_following_cubit.dart';
import 'package:archilink/features/settings/presentation/views/widgets/followers_tab.dart';
import 'package:archilink/features/settings/presentation/views/widgets/following_tab.dart';
import 'package:archilink/features/settings/presentation/views/widgets/request_action.dart';
import 'package:archilink/features/settings/presentation/views/widgets/users_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowersAndFollowingView extends StatelessWidget {
  const FollowersAndFollowingView({super.key});
  static const String name = '/FollowersAndFollowing';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Followers & Following',
          style: AppTextStyle.interSemiBold16.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: const SafeArea(child: FollowersAndFollowingViewBody()),
    );
  }
}

class FollowersAndFollowingViewBody extends StatelessWidget {
  const FollowersAndFollowingViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FollowersAndFollowingTabs();
  }
}

enum _FollowTab { followers, following, requests }

class _FollowersAndFollowingTabs extends StatefulWidget {
  const _FollowersAndFollowingTabs();

  @override
  State<_FollowersAndFollowingTabs> createState() =>
      _FollowersAndFollowingTabsState();
}

class _FollowersAndFollowingTabsState
    extends State<_FollowersAndFollowingTabs> {
  _FollowTab _selectedTab = _FollowTab.followers;

  final List<MockUser> _requests = const [
    MockUser(name: 'Ethan King'),
    MockUser(name: 'Charlotte Hill'),
    MockUser(name: 'Benjamin Lee'),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildTabChip(
                context,
                label: 'Followers',
                tab: _FollowTab.followers,
              ),
              const SizedBox(width: 8),
              _buildTabChip(
                context,
                label: 'Following',
                tab: _FollowTab.following,
              ),
              const SizedBox(width: 8),
              _buildTabChip(
                context,
                label: 'Requests',
                tab: _FollowTab.requests,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _buildTabContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildTabChip(
    BuildContext context, {
    required String label,
    required _FollowTab tab,
  }) {
    final isSelected = _selectedTab == tab;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedTab = tab);
        if (tab == _FollowTab.following) {
          final cubit = context.read<FollowersAndFollowingCubit>();
          final state = cubit.state;
          if (!state.hasFollowingData && !state.isLoadingFollowing) {
            cubit.fetchFollowing();
          }
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColorsFromTheme.grayForTheme(context)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: !isSelected
              ? Border.all(
                  color: AppColorsFromTheme.lightGray(context),
                  width: 0.5,
                )
              : null,
        ),
        child: Text(
          label,
          style: AppTextStyle.interMedium12.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case _FollowTab.followers:
        return const FollowersTab(key: ValueKey('followers'));
      case _FollowTab.following:
        return const FollowingTab(key: ValueKey('following'));
      case _FollowTab.requests:
        return UsersListView(
          key: const ValueKey('requests'),
          users: _requests,
          actionBuilder: (_) =>
              RequestActions(onAccept: () {}, onRemove: () {}),
        );
    }
  }
}

class MockUser {
  final String name;
  const MockUser({required this.name});
}
