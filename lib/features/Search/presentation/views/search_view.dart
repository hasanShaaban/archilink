import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Search/domain/repo/search_repo.dart';
import 'package:archilink/features/Search/presentation/manager/cubit/search_cubit.dart';
import 'package:archilink/features/Search/presentation/views/search_results_view.dart';
import 'package:archilink/features/Search/presentation/views/widgets/filter_options.dart';
import 'package:archilink/features/Search/presentation/views/widgets/search_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  static const String name = 'SearchView';

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(sl<SearchRepo>()),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: SearchViewBody(searchController: _searchController),
          ),
        ),
      ),
    );
  }
}

class SearchViewBody extends StatelessWidget {
  const SearchViewBody({
    super.key,
    required TextEditingController searchController,
  }) : _searchController = searchController;

  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchCubit, SearchState>(
      listenWhen: (previous, current) => previous.query != current.query,
      listener: (context, state) {
        if (_searchController.text == state.query) return;
        _searchController.value = TextEditingValue(
          text: state.query,
          selection: TextSelection.collapsed(offset: state.query.length),
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: SearchAppBar(searchController: _searchController),
          ),
          FitlersOptions(),
          const SizedBox(height: 16),
          Divider(),
          TextButton(
            onPressed: () {
              final cubit = context.read<SearchCubit>();
              cubit.fetchSearchResults();
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: cubit,
                    child: const SearchResultsView(),
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              'show results',
              style: AppTextStyle.interMedium16.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
