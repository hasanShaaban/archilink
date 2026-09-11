import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Post/presentation/manager/cubit/post_save_cubit.dart';
import 'package:archilink/features/settings/domain/entity/user_collection_entity.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/user_collections_cubit.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/user_collections_state.dart';
import 'package:archilink/features/settings/presentation/views/widgets/collection_title_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SaveToCollectionBottomSheet extends StatelessWidget {
  const SaveToCollectionBottomSheet({super.key});

  void _showAddCollectionDialog(BuildContext context) {
    CollectionTitleDialog.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height * 0.6,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(
          color: AppColorsFromTheme.borderColor(context),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle pill
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColorsFromTheme.borderColor(context),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header: Title & Add Collection button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Save to collection',
                    style: AppTextStyle.interSemiBold16.copyWith(
                      color: AppColorsFromTheme.textColor(context),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showAddCollectionDialog(context),
                    tooltip: 'New collection',
                    icon: SvgPicture.asset(
                      Assets.assetsIconsAdd,
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        theme.colorScheme.onSurface,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: AppColorsFromTheme.borderColor(context),
            ),
            // Collections list
            Flexible(
              child: BlocConsumer<UserCollectionsCubit, UserCollectionsState>(
                listener: (context, state) {
                  final defaultCol = state.defaultCollection;
                  if (defaultCol != null) {
                    context.read<PostSaveCubit>().setDefaultCollection(
                          id: defaultCol.id,
                          title: defaultCol.title,
                        );
                  }
                },
                builder: (context, state) {
                  if (state.isLoadingCollections) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(36),
                        child: CircularProgressIndicator(
                          color: AppColorsFromTheme.primaryColor(context),
                        ),
                      ),
                    );
                  }

                  if (state.collectionsErrorMessage != null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.collectionsErrorMessage!,
                              style: AppTextStyle.interMedium12.copyWith(
                                color: AppColorsFromTheme.grayForText(context),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () {
                                context
                                    .read<UserCollectionsCubit>()
                                    .fetchCollections();
                              },
                              child: Text(
                                'Retry',
                                style: AppTextStyle.interSemiBold14.copyWith(
                                  color: AppColorsFromTheme.primaryColor(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state.collections.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 36),
                        child: Text(
                          'No collections found',
                          style: AppTextStyle.interMedium14.copyWith(
                            color: AppColorsFromTheme.grayForText(context),
                          ),
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    itemCount: state.collections.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final collection = state.collections[index];
                      return _CollectionItemTile(
                        collection: collection,
                        onTap: () {
                          Navigator.of(context).pop(collection);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectionItemTile extends StatelessWidget {
  final UserCollectionEntity collection;
  final VoidCallback onTap;

  const _CollectionItemTile({
    required this.collection,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final initialLetter =
        collection.title.isNotEmpty ? collection.title[0].toUpperCase() : '';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColorsFromTheme.secondaryColor(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColorsFromTheme.borderColor(context),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColorsFromTheme.primaryColor(context)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  initialLetter,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColorsFromTheme.primaryColor(context),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      collection.title,
                      style: AppTextStyle.interMedium14.copyWith(
                        color: AppColorsFromTheme.textColor(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (collection.isDefault) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColorsFromTheme.primaryColor(context)
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Default',
                          style: AppTextStyle.interMedium10.copyWith(
                            color: AppColorsFromTheme.primaryColor(context),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColorsFromTheme.grayForText(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

