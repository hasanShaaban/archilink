import 'package:archilink/features/settings/presentation/views/widgets/collection_card.dart';
import 'package:archilink/features/settings/presentation/views/widgets/collection_page_indector.dart';
import 'package:flutter/material.dart';

class SlidingCollectionsSection extends StatelessWidget {
  const SlidingCollectionsSection({
    super.key,
    required this.pageController,
    required this.currentPage,
    required this.collections,
    required this.onPageChanged,
  });

  final PageController pageController;
  final int currentPage;
  final List<String> collections;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final containerSize = size.height * 0.055;
    final double cardHeight = containerSize + 32; // 16 top + 16 bottom padding
    final double gridHeight = cardHeight * 2; // 2 rows

    return Column(
      children: [
        SizedBox(
          height: gridHeight,
          child: PageView.builder(
            controller: pageController,
            itemCount: (collections.length / 4).ceil(),
            onPageChanged: onPageChanged,
            itemBuilder: (context, pageIndex) {
              final startIdx = pageIndex * 4;
              final endIdx = startIdx + 4;
              final pageItems = collections.sublist(
                startIdx,
                endIdx > collections.length ? collections.length : endIdx,
              );

              return GridView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: cardHeight,
                ),
                itemCount: pageItems.length,
                itemBuilder: (context, index) {
                  return CollectionCard(title: pageItems[index]);
                },
              );
            },
          ),
        ),
        CollectionPageIndicator(
          currentPage: currentPage,
          pageCount: (collections.length / 4).ceil(),
        ),
      ],
    );
  }
}
