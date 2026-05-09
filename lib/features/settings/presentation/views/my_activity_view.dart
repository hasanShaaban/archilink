
import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';

import 'package:archilink/features/settings/presentation/views/widgets/liked_post_list_view.dart';
import 'package:flutter/material.dart';
class MyActivityView extends StatelessWidget {
  const MyActivityView({super.key});

  static const String name = '/MyActivty';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Activity',
          style: AppTextStyle.interSemiBold16.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: const SafeArea(child: _MyActivityTabs()),
    );
  }
}

enum _ActivityTab { likes, comments }

class _MyActivityTabs extends StatefulWidget {
  const _MyActivityTabs();

  @override
  State<_MyActivityTabs> createState() => _MyActivityTabsState();
}

class _MyActivityTabsState extends State<_MyActivityTabs> {
  _ActivityTab _selectedTab = _ActivityTab.likes;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildTabChip(context, label: 'Likes', tab: _ActivityTab.likes),
              const SizedBox(width: 8),
              _buildTabChip(
                context,
                label: 'Comments',
                tab: _ActivityTab.comments,
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
    required _ActivityTab tab,
  }) {
    final isSelected = _selectedTab == tab;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => setState(() => _selectedTab = tab),
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
      case _ActivityTab.likes:
        return const Center(
          key: ValueKey('likes'),
          child: LikedPostsListView(),
        );
      case _ActivityTab.comments:
        return const Center(
          key: ValueKey('comments'),
          child: Text('Comments', style: AppTextStyle.interMedium12),
        );
    }
  }
}


