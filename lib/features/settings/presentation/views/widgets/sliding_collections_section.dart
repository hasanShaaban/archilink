import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/settings/domain/entity/user_collection_entity.dart';
import 'package:archilink/features/settings/presentation/views/widgets/collection_card.dart';
import 'package:archilink/features/settings/presentation/views/widgets/collection_page_indector.dart';
import 'package:flutter/material.dart';

enum CollectionMenuAction {
  edit,
  delete,
}

class SlidingCollectionsSection extends StatelessWidget {
  const SlidingCollectionsSection({
    super.key,
    required this.pageController,
    required this.currentPage,
    required this.collections,
    required this.onPageChanged,
    this.selectedCollectionId,
    this.onCollectionSelected,
    this.onEditCollection,
    this.onDeleteCollection,
  });

  final PageController pageController;
  final int currentPage;
  final List<UserCollectionEntity> collections;
  final ValueChanged<int> onPageChanged;
  final int? selectedCollectionId;
  final ValueChanged<UserCollectionEntity>? onCollectionSelected;
  final ValueChanged<UserCollectionEntity>? onEditCollection;
  final ValueChanged<UserCollectionEntity>? onDeleteCollection;

  void _showCollectionMenu(BuildContext context, UserCollectionEntity item) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    final position = overlay != null
        ? RelativeRect.fromRect(
            Rect.fromPoints(
              renderBox.localToGlobal(Offset.zero, ancestor: overlay),
              renderBox.localToGlobal(
                renderBox.size.bottomRight(Offset.zero),
                ancestor: overlay,
              ),
            ),
            Offset.zero & overlay.size,
          )
        : RelativeRect.fromLTRB(
            0,
            0,
            0,
            0,
          );

    showMenu<CollectionMenuAction>(
      context: context,
      color: AppColorsFromTheme.secondaryColor(context),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColorsFromTheme.borderColor(context),
        ),
      ),
      position: position,
      items: [
        PopupMenuItem<CollectionMenuAction>(
          value: CollectionMenuAction.edit,
          height: 40,
          child: Row(
            children: [
              Icon(
                Icons.edit_outlined,
                size: 18,
                color: AppColorsFromTheme.textColor(context),
              ),
              const SizedBox(width: 10),
              Text(
                'Edit',
                style: AppTextStyle.interMedium14.copyWith(
                  color: AppColorsFromTheme.textColor(context),
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<CollectionMenuAction>(
          value: CollectionMenuAction.delete,
          height: 40,
          child: Row(
            children: [
              const Icon(
                Icons.delete_outline,
                size: 18,
                color: AppColors.red,
              ),
              const SizedBox(width: 10),
              Text(
                'Delete',
                style: AppTextStyle.interMedium14.copyWith(
                  color: AppColors.red,
                ),
              ),
            ],
          ),
        ),
      ],
    ).then((action) {
      if (action == null) return;
      switch (action) {
        case CollectionMenuAction.edit:
          onEditCollection?.call(item);
          break;
        case CollectionMenuAction.delete:
          onDeleteCollection?.call(item);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final containerSize = size.height * 0.055;
    final double cardHeight = containerSize + 32; // 16 top + 16 bottom padding
    final double gridHeight = collections.length > 2
        ? cardHeight * 2
        : cardHeight; // 2 rows

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
                  final item = pageItems[index];
                  return Builder(
                    builder: (cardContext) {
                      return CollectionCard(
                        title: item.title,
                        isSelected: item.id == selectedCollectionId,
                        onTap: () => onCollectionSelected?.call(item),
                        onLongPress: () =>
                            _showCollectionMenu(cardContext, item),
                      );
                    },
                  );
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

