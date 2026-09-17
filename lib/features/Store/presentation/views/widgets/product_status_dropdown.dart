import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/add_edit_product_cubit.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/add_edit_product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductStatusDropdown extends StatelessWidget {
  const ProductStatusDropdown({super.key});

  static const List<Map<String, String>> _statusOptions = [
    {'value': 'available', 'label': 'Available'},
    {'value': 'out_of_stock', 'label': 'Out of Stock'},
    {'value': 'coming_soon', 'label': 'Coming Soon'},
    {'value': 'pending', 'label': 'Pending'},
  ];

  String _formatStatus(String status) {
    if (status.isEmpty) return 'Select status';
    for (final opt in _statusOptions) {
      if (opt['value']?.toLowerCase() == status.toLowerCase()) {
        return opt['label']!;
      }
    }
    return status
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
        .join(' ');
  }

  void _showStatusPicker(BuildContext context, String currentStatus) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF4A4A4A) : const Color(0xFFCCCCCC),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Select Status',
                      style: AppTextStyle.interSemiBold16.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                const Divider(),
                ..._statusOptions.map((opt) {
                  final isSelected =
                      opt['value']?.toLowerCase() == currentStatus.toLowerCase();
                  return ListTile(
                    title: Text(
                      opt['label']!,
                      style: AppTextStyle.interMedium14.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Color(0xFF6BBBAE))
                        : null,
                    onTap: () {
                      context
                          .read<AddEditProductCubit>()
                          .updateStatus(opt['value']!);
                      Navigator.of(sheetContext).pop();
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<AddEditProductCubit, AddEditProductState>(
      builder: (context, state) {
        final hasSelection = state.status.isNotEmpty;
        final displayText = _formatStatus(state.status);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status',
              style: AppTextStyle.interSemiBold14.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _showStatusPicker(context, state.status),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF242527) : const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColorsFromTheme.borderColor(context).withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        displayText,
                        style: AppTextStyle.interRegular14.copyWith(
                          color: hasSelection
                              ? theme.colorScheme.onSurface
                              : (isDark
                                  ? const Color(0xFF8E8E93)
                                  : const Color(0xFFA0A0A0)),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: isDark
                          ? const Color(0xFF8E8E93)
                          : const Color(0xFF636363),
                    ),
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
