import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/add_edit_product_cubit.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/add_edit_product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductQuantityStepper extends StatefulWidget {
  const ProductQuantityStepper({super.key});

  @override
  State<ProductQuantityStepper> createState() => _ProductQuantityStepperState();
}

class _ProductQuantityStepperState extends State<ProductQuantityStepper> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<AddEditProductCubit>();
    final isEditMode = cubit.state.isEditMode;
    final initialQty = cubit.state.quantity;
    _controller = TextEditingController(
      text: initialQty == 0 && !isEditMode ? '' : '$initialQty',
    );
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      final text = _controller.text.trim();
      final cubit = context.read<AddEditProductCubit>();
      if (text.isEmpty) {
        if (cubit.state.isEditMode) {
          _controller.text = '0';
        }
        cubit.setQuantity(0);
      } else {
        final parsed = int.tryParse(text) ?? 0;
        _controller.text = '$parsed';
        cubit.setQuantity(parsed);
      }
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocConsumer<AddEditProductCubit, AddEditProductState>(
      listenWhen: (prev, curr) => prev.quantity != curr.quantity,
      listener: (context, state) {
        final text = _controller.text.trim();
        // If the user is currently typing and the field is temporarily empty while quantity is 0,
        // do not force text so they can type freely.
        if (text.isEmpty && state.quantity == 0 && _focusNode.hasFocus) {
          return;
        }
        final currentTextQty = int.tryParse(text);
        if (currentTextQty != state.quantity) {
          final newText = state.quantity == 0 && !state.isEditMode && text.isEmpty
              ? ''
              : '${state.quantity}';
          _controller.value = TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(offset: newText.length),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<AddEditProductCubit>();

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

                  // Center Quantity Display / Keyboard Editable Input Segment
                  Expanded(
                    child: Center(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textAlign: TextAlign.center,
                        style: AppTextStyle.interMedium14.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          hintText: state.quantity == 0 && !state.isEditMode ? '.' : null,
                          hintStyle: AppTextStyle.interMedium14.copyWith(
                            color: isDark ? const Color(0xFF8E8E93) : const Color(0xFFA0A0A0),
                            fontWeight: FontWeight.w600,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                        ),
                        onChanged: (val) {
                          if (val.trim().isEmpty) {
                            cubit.setQuantity(0);
                          } else {
                            final parsed = int.tryParse(val.trim()) ?? 0;
                            cubit.setQuantity(parsed);
                          }
                        },
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
