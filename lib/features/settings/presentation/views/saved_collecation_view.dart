import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/user_collections_cubit.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/user_collections_state.dart';
import 'package:archilink/features/settings/presentation/views/widgets/sliding_collections_section.dart';
import 'package:archilink/features/settings/presentation/views/widgets/saved_posts_list_view.dart';
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

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
              BlocBuilder<UserCollectionsCubit, UserCollectionsState>(
                builder: (context, state) {
                  final isLoading = state.isLoadingCollections;
                  final collectionNames = isLoading
                      ? const ['Loading 1', 'Loading 2', 'Loading 3', 'Loading 4']
                      : state.collections.map((e) => e.title).toList();

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
                      ).colorScheme.primary.withOpacity(0.5),
                      baseColor: AppColorsFromTheme.grayForTheme(
                        context,
                      ).withOpacity(0.5),
                    ),
                    enabled: isLoading,
                    child: SlidingCollectionsSection(
                      pageController: _pageController,
                      currentPage: _currentPage,
                      collections: collectionNames,
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
