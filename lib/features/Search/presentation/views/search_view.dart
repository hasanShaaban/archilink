import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Search/presentation/manager/cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

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
      create: (_) => SearchCubit(),
      child: BlocListener<SearchCubit, SearchState>(
        listenWhen: (previous, current) => previous.query != current.query,
        listener: (context, state) {
          if (_searchController.text == state.query) return;
          _searchController.value = TextEditingValue(
            text: state.query,
            selection: TextSelection.collapsed(offset: state.query.length),
          );
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.close),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: BlocBuilder<SearchCubit, SearchState>(
                          builder: (context, state) {
                            return TextField(
                              
                              controller: _searchController,
                              onChanged: context
                                  .read<SearchCubit>()
                                  .updateQuery,
                              decoration: InputDecoration(
                              
                                hintText: 'Search',
                                hintStyle: AppTextStyle.manjariRegular16.copyWith(
                                  color: AppColorsFromTheme.grayForText(context),
                                ),
                                suffixIconConstraints: BoxConstraints(
                                  maxHeight: 24,
                                  maxWidth: 44,
                                ),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: SvgPicture.asset(
                                    Assets.assetsIconsSearch,
                                    width: 20,
                                    height: 20,
                                    color: AppColorsFromTheme.grayForText(context),
                                  ),
                                ),
                                filled: true,
                                fillColor: AppColorsFromTheme.grayForTheme(
                                  context,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
