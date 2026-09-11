import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/settings/domain/entity/user_collection_entity.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/collection_posts_cubit.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/user_collections_cubit.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/user_collections_state.dart';
import 'package:archilink/features/settings/presentation/views/widgets/sliding_collections_section.dart';
import 'package:archilink/features/settings/presentation/views/widgets/saved_posts_list_view.dart';
import 'package:archilink/features/settings/presentation/views/widgets/collection_title_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SavedCollecationView extends StatefulWidget {
  const SavedCollecationView({super.key});
  static const String name = 'SavedCollecationView';

  @override
  State<SavedCollecationView> createState() => _SavedCollecationViewState();
}

class _SavedCollecationViewState extends State<SavedCollecationView> {
  late final PageController _pageController;
  int _currentPage = 0;
  int? _selectedCollectionId;

  static final _dummyCollections = List.generate(
    4,
    (i) => UserCollectionEntity(
      id: -(i + 1),
      userId: 0,
      title: 'Loading ${i + 1}',
      isDefault: i == 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  );

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialDefaultCollectionPosts();
    });
  }

  void _fetchInitialDefaultCollectionPosts() {
    final collectionsState = context.read<UserCollectionsCubit>().state;
    if (collectionsState.hasCollectionsData && _selectedCollectionId == null) {
      final defaultCol = collectionsState.defaultCollection;
      if (defaultCol != null) {
        setState(() => _selectedCollectionId = defaultCol.id);
        context.read<CollectionPostsCubit>().fetchCollectionPosts(
              collectionId: defaultCol.id,
            );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _showEditCollectionDialog(
    UserCollectionEntity collection,
  ) async {
    final success = await CollectionTitleDialog.show(
      context,
      collection: collection,
    );

    if (success == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Collection updated successfully'),
        ),
      );
    }
  }

  Future<void> _confirmDeleteCollection(UserCollectionEntity collection) async {
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        bool isDeleting = false;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return PopScope(
              canPop: !isDeleting,
              child: AlertDialog(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: AppColorsFromTheme.borderColor(context),
                  ),
                ),
                title: Text(
                  'Delete Collection',
                  style: AppTextStyle.interSemiBold16.copyWith(
                    color: AppColorsFromTheme.textColor(context),
                  ),
                ),
                content: Text(
                  'Are you sure you want to delete "${collection.title}"? All saved items in this collection will be removed.',
                  style: AppTextStyle.interMedium14.copyWith(
                    color: AppColorsFromTheme.grayForText(context),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: isDeleting
                        ? null
                        : () => Navigator.pop(dialogContext, false),
                    child: Text(
                      'Cancel',
                      style: AppTextStyle.interSemiBold14.copyWith(
                        color: AppColorsFromTheme.grayForText(context),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: isDeleting
                        ? null
                        : () async {
                            setDialogState(() => isDeleting = true);
                            final result = await this
                                .context
                                .read<UserCollectionsCubit>()
                                .removeCollection(collectionId: collection.id);

                            if (!mounted) return;

                            result.fold(
                              (failure) {
                                Navigator.pop(dialogContext, false);
                                ScaffoldMessenger.of(this.context).showSnackBar(
                                  SnackBar(content: Text(failure.message)),
                                );
                              },
                              (success) {
                                Navigator.pop(dialogContext, true);
                                ScaffoldMessenger.of(this.context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Collection deleted successfully',
                                    ),
                                  ),
                                );

                                final remainingCollections = this
                                    .context
                                    .read<UserCollectionsCubit>()
                                    .state
                                    .collections;

                                if (_selectedCollectionId == collection.id) {
                                  if (remainingCollections.isNotEmpty) {
                                    final nextCollection =
                                        remainingCollections.firstWhere(
                                      (c) => c.isDefault,
                                      orElse: () => remainingCollections.first,
                                    );
                                    setState(() {
                                      _selectedCollectionId =
                                          nextCollection.id;
                                    });
                                    this
                                        .context
                                        .read<CollectionPostsCubit>()
                                        .fetchCollectionPosts(
                                          collectionId: nextCollection.id,
                                          forceRefresh: true,
                                        );
                                  } else {
                                    setState(() {
                                      _selectedCollectionId = null;
                                    });
                                  }
                                }

                                final maxPage =
                                    (remainingCollections.length / 4).ceil();
                                if (_currentPage >= maxPage && maxPage > 0) {
                                  final newPage = maxPage - 1;
                                  _pageController.jumpToPage(newPage);
                                  setState(() => _currentPage = newPage);
                                }
                              },
                            );
                          },
                    child: isDeleting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.red,
                            ),
                          )
                        : Text(
                            'Delete',
                            style: AppTextStyle.interSemiBold14.copyWith(
                              color: AppColors.red,
                            ),
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saved Collection',
          style: AppTextStyle.interSemiBold16,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Collections', style: AppTextStyle.interSemiBold16),
              ),
              const Divider(thickness: 1),
              const SizedBox(height: 8),
              BlocConsumer<UserCollectionsCubit, UserCollectionsState>(
                listener: (context, state) {
                  if (state.hasCollectionsData && _selectedCollectionId == null) {
                    final defaultCol = state.defaultCollection;
                    if (defaultCol != null) {
                      setState(() => _selectedCollectionId = defaultCol.id);
                      context.read<CollectionPostsCubit>().fetchCollectionPosts(
                            collectionId: defaultCol.id,
                          );
                    }
                  }
                },
                builder: (context, state) {
                  final isLoading = state.isLoadingCollections;
                  final collectionsList = isLoading
                      ? _dummyCollections
                      : state.collections;

                  if (state.collectionsErrorMessage != null) {
                    return Center(
                      child: Text(
                        state.collectionsErrorMessage!,
                        style: AppTextStyle.interMedium12,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  if (!isLoading && state.collections.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No collections found',
                          style: AppTextStyle.interMedium12,
                        ),
                      ),
                    );
                  }
                  return Skeletonizer(
                    effect: ShimmerEffect(
                      highlightColor: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.5),
                      baseColor: AppColorsFromTheme.grayForTheme(
                        context,
                      ).withValues(alpha: 0.5),
                    ),
                    enabled: isLoading,
                    child: SlidingCollectionsSection(
                      pageController: _pageController,
                      currentPage: _currentPage,
                      collections: collectionsList,
                      selectedCollectionId: _selectedCollectionId,
                      onCollectionSelected: (collection) {
                        if (_selectedCollectionId != collection.id) {
                          setState(() => _selectedCollectionId = collection.id);
                          context
                              .read<CollectionPostsCubit>()
                              .fetchCollectionPosts(
                                collectionId: collection.id,
                              );
                        }
                      },
                      onDeleteCollection: _confirmDeleteCollection,
                      onEditCollection: _showEditCollectionDialog,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                    ),
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Posts', style: AppTextStyle.interSemiBold16),
              ),
              const Divider(thickness: 1),
              const Expanded(child: SavedPostsListView()),
            ],
          ),
        ),
      ),
    );
  }
}

