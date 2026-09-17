import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/add_edit_product_cubit.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/add_edit_product_state.dart';
import 'package:archilink/features/Store/presentation/views/widgets/category_search_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCategoryField extends StatelessWidget {
  const ProductCategoryField({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<AddEditProductCubit, AddEditProductState>(
      builder: (context, state) {
        final cubit = context.read<AddEditProductCubit>();
        final hasSelected = state.selectedCategories.isNotEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category',
              style: AppTextStyle.interSemiBold14.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => CategorySearchBottomSheet.show(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF242527) : const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColorsFromTheme.borderColor(context).withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search trigger text / placeholder
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Search for Category',
                            style: AppTextStyle.interRegular14.copyWith(
                              color: isDark
                                  ? const Color(0xFF8E8E93)
                                  : const Color(0xFFA0A0A0),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.search,
                          size: 20,
                          color: isDark
                              ? const Color(0xFF8E8E93)
                              : const Color(0xFFA0A0A0),
                        ),
                      ],
                    ),

                    // Selected Category Chips
                    if (hasSelected) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: state.selectedCategories.map((category) {
                          return Container(
                            padding: const EdgeInsets.fromLTRB(12, 6, 8, 6),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF333538)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF4A4D52)
                                    : const Color(0xFFD4D4D4),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  category.name,
                                  style: AppTextStyle.interMedium12.copyWith(
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () => cubit.removeCategory(category),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(
                                      Icons.close,
                                      size: 14,
                                      color: isDark
                                          ? const Color(0xFF8E8E93)
                                          : const Color(0xFF636363),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
