
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class ExpandableTags extends StatefulWidget {
  final List<String> tags;
  final int visibleLineCount;

  const ExpandableTags({
    super.key,
    required this.tags,
    this.visibleLineCount = 2,
  });

  @override
  State<ExpandableTags> createState() => _ExpandableTagsState();
}

class _ExpandableTagsState extends State<ExpandableTags>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {

    // We’ll approximate "lines" by tag count
    // This is often visually indistinguishable unless tag length varies wildly.
    const int tagsPerLine = 4; // adjust based on your design
    final int maxVisibleTags = widget.visibleLineCount * tagsPerLine;
    final bool shouldShowSeeMore = widget.tags.length > maxVisibleTags;

    final List<String> alwaysVisibleTags =
        shouldShowSeeMore ? widget.tags.take(maxVisibleTags).toList() : widget.tags;
    final List<String> hiddenTags =
        shouldShowSeeMore ? widget.tags.skip(maxVisibleTags).toList() : [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            // Always visible tags
            ...alwaysVisibleTags.map((tag) => _buildTag(context, tag)),

            // "See more" chip only if collapsed and there are more tags
            if (!_expanded && shouldShowSeeMore)
              _buildSeeMoreChip(context, "See more"),
          ],
        ),
        // Hidden tags smoothly fade/slide under the top part
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) => SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1,
            child: FadeTransition(opacity: animation, child: child),
          ),
          child: _expanded
              ? Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      ...hiddenTags.map((tag) => _buildTag(context, tag)),
                      _buildSeeMoreChip(context, "See less"),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildTag(BuildContext context, String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        tag,
        style:AppTextStyle.interRegular10.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
      ),
    );
  }

  Widget _buildSeeMoreChip(BuildContext context, String label) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
