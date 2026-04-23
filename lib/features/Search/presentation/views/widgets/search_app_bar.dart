import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Search/presentation/manager/cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SearchAppBar extends StatelessWidget {
  const SearchAppBar({
    super.key,
    required TextEditingController searchController,
  }) : _searchController = searchController;

  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return Row(
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
                  hintStyle: AppTextStyle.manjariRegular16
                      .copyWith(
                        color: AppColorsFromTheme.grayForText(
                          context,
                        ),
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
                      color: AppColorsFromTheme.grayForText(
                        context,
                      ),
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
                    borderSide: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: AppColorsFromTheme.grayForText(
                        context,
                      ),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
