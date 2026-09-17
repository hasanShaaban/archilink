import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/add_edit_product_cubit.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/add_edit_product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductQuantityStepper extends StatelessWidget {
  const ProductQuantityStepper({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<AddEditProductCubit, AddEditProductState>(
      builder: (context, state) {
        final cubit = context.read<AddEditProductCubit>();
        final displayQuantity = state.quantity == 0 && !state.isEditMode
            ? '.'
            : '${state.quantity}';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quantity',
              style: AppTextStyle.interSemiBold14.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF242527) : const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColorsFromTheme.borderColor(context).withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  // Minus Button Segment
                  SizedBox(
                    width: 54,
                    height: double.infinity,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(10),
                        ),
                        onTap: state.quantity > 0
                            ? () => cubit.decrementQuantity()
                            : null,
                        child: Center(
                          child: Icon(
                            Icons.remove,
                            size: 18,
                            color: state.quantity > 0
                                ? theme.colorScheme.onSurface
                                : (isDark
                                    ? const Color(0xFF636363)
                                    : const Color(0xFFB5B6B8)),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Divider
                  Container(
                    width: 1,
                    height: double.infinity,
                    color: AppColorsFromTheme.borderColor(context).withValues(alpha: 0.5),
                  ),

                  // Center Quantity Display Segment
                  Expanded(
                    child: Center(
                      child: Text(
                        displayQuantity,
                        style: AppTextStyle.interMedium14.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // Divider
                  Container(
                    width: 1,
                    height: double.infinity,
                    color: AppColorsFromTheme.borderColor(context).withValues(alpha: 0.5),
                  ),

                  // Plus Button Segment
                  SizedBox(
                    width: 54,
                    height: double.infinity,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(10),
                        ),
                        onTap: () => cubit.incrementQuantity(),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            size: 18,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
