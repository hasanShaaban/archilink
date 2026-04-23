import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Search/presentation/manager/cubit/search_cubit.dart';
import 'package:archilink/features/Search/presentation/views/widgets/filter_option_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class FitlersOptions extends StatelessWidget {
  const FitlersOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  spacing: 4,
                  runSpacing: 8,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4.0,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              Assets.assetsIconsFilters,
                              width: 20,
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    FilterOptionContainer(
                      title: 'Account Type',
                      onTap: () =>
                          context.read<SearchCubit>().toggleAccountTypeFocus(),
                      borderColor: state.focusedOnAccountType
                          ? Theme.of(context).colorScheme.primary
                          : AppColorsFromTheme.grayForText(context),
                      selectedOptionText: state.selectedAccountType,
                      backgroundColor: state.selectedAccountType.isNotEmpty
                          ? Theme.of(context).colorScheme.primary.withAlpha(65)
                          : Colors.transparent,
                    ),
                    FilterOptionContainer(
                      title: 'Services',
                      onTap: () =>
                          context.read<SearchCubit>().toggleServicesFocus(),
                      borderColor: state.focusedOnServices
                          ? Theme.of(context).colorScheme.primary
                          : AppColorsFromTheme.grayForText(context),
                      selectedOptionText: state.selectedServicesSummary,
                      backgroundColor: state.selectedServices.isNotEmpty
                          ? Theme.of(context).colorScheme.primary.withAlpha(65)
                          : Colors.transparent,
                    ),
                    FilterOptionContainer(
                      title: 'Location',
                      onTap: () =>
                          context.read<SearchCubit>().toggleLocationFocus(),
                      borderColor: state.focusedOnLocation
                          ? Theme.of(context).colorScheme.primary
                          : AppColorsFromTheme.grayForText(context),
                      selectedOptionText: state.selectedLocation,
                      backgroundColor: state.selectedLocation.isNotEmpty
                          ? Theme.of(context).colorScheme.primary.withAlpha(65)
                          : Colors.transparent,
                    ),
                  ],
                ),
              ),
              if (state.hasFocusedFilter) ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColorsFromTheme.grayForText(context),
                    ),
                  ),
                  child: state.focusedOnAccountType
                      ? Column(
                          children: SearchState.accountTypeOptions
                              .map(
                                (option) => _AccountTypeOptionTile(
                                  label: option,
                                  selected: state.selectedAccountType == option,
                                  onTap: () => context
                                      .read<SearchCubit>()
                                      .selectAccountType(option),
                                ),
                              )
                              .toList(),
                        )
                      : state.focusedOnServices
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: SearchState.serviceOptions
                                    .sublist(3)
                                    .map(
                                      (option) => _AccountTypeOptionTile(
                                        label: option,
                                        selected: state.selectedServices
                                            .contains(option),
                                        onTap: () => context
                                            .read<SearchCubit>()
                                            .toggleServiceSelection(option),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                children: SearchState.serviceOptions
                                    .sublist(0, 3)
                                    .map(
                                      (option) => _AccountTypeOptionTile(
                                        label: option,
                                        selected: state.selectedServices
                                            .contains(option),
                                        onTap: () => context
                                            .read<SearchCubit>()
                                            .toggleServiceSelection(option),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: SearchState.locationOptions
                              .map(
                                (option) => _AccountTypeOptionTile(
                                  label: option,
                                  selected: state.selectedLocation == option,
                                  onTap: () => context
                                      .read<SearchCubit>()
                                      .selectLocation(option),
                                ),
                              )
                              .toList(),
                        ),
                ),
              ],
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Suggested Tags',
                    style: AppTextStyle.interSemiBold16.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: SearchState.suggestedTags.map((tag) {
                      final isSelected = state.selectedTags.contains(tag);
                      return FilterChip(
                        label: Text(
                          tag,
                          style: AppTextStyle.interMedium12.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (_) =>
                            context.read<SearchCubit>().toggleTagSelection(tag),
                        showCheckmark: false,

                        backgroundColor: AppColorsFromTheme.grayForTheme(
                          context,
                        ),
                        selectedColor: Theme.of(context).colorScheme.primary,
                        deleteIcon: isSelected
                            ? Icon(
                                Icons.close_rounded,
                                size: 16,
                                color: Theme.of(context).colorScheme.onSurface,
                              )
                            : null,
                        onDeleted: isSelected
                            ? () => context
                                  .read<SearchCubit>()
                                  .toggleTagSelection(tag)
                            : null,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AccountTypeOptionTile extends StatelessWidget {
  const _AccountTypeOptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Checkbox(
              checkColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              value: selected,
              onChanged: (_) => onTap(),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }
}
