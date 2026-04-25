import 'package:archilink/features/Search/presentation/manager/cubit/search_cubit.dart';
import 'package:archilink/features/Search/presentation/views/widgets/posts_results_tab.dart';
import 'package:archilink/features/Search/presentation/views/widgets/profile_grid_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchResultsView extends StatelessWidget {
  const SearchResultsView({super.key});
  static const String name = 'SearchResultsView';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search Results'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kTextTabBarHeight),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                labelColor: Theme.of(context).colorScheme.primary,
                indicatorColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 2,
                labelPadding: const EdgeInsets.only(right: 20),
                tabs: [
                  SizedBox(
                    width: width * 120 / 402,
                    child: Tab(text: 'Profiles'),
                  ),
                  SizedBox(
                    width: width * 120 / 402,
                    child: Tab(text: 'Posts'),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            if (state.isInitialLoading &&
                state.posts.isEmpty &&
                state.users.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null &&
                state.posts.isEmpty &&
                state.users.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(state.errorMessage!),
                ),
              );
            }

            return SafeArea(
              child: TabBarView(
                children: [
                  state.users.isEmpty
                      ? const Center(child: Text('No profiles found'))
                      : ProfilesGridTab(
                          users: state.users,
                          isLoadingMore: state.isLoadingMoreUsers,
                          onLoadMore: context.read<SearchCubit>().loadMoreUsers,
                        ),
                  state.posts.isEmpty
                      ? const Center(child: Text('No profiles found'))
                      : PostsResultsTab(width: width),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
