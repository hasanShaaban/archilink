import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/add_edit_product_cubit.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/add_edit_product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditProductActionButtons extends StatelessWidget {
  const AddEditProductActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddEditProductCubit, AddEditProductState>(
      builder: (context, state) {
        final cubit = context.read<AddEditProductCubit>();

        if (!state.isEditMode) {
          // Add Mode: Single "Add Product" button aligned to the right
          return Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 46,
              child: ElevatedButton(
                onPressed: state.isSubmitting ? null : () => cubit.submit(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6BBBAE),
                  foregroundColor: const Color(0xFF1E3A34),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: state.isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF1E3A34),
                          ),
                        ),
                      )
                    : Text(
                        'Add Product',
                        style: AppTextStyle.interSemiBold14.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E3A34),
                        ),
                      ),
              ),
            ),
          );
        }

        // Edit Mode: Two buttons: "Delete Product" and "Save Updates"
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Delete Product Button
            Expanded(
              child: SizedBox(
                height: 46,
                child: ElevatedButton(
                  onPressed: state.isDeleting ? null : () => _confirmDelete(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE58B88),
                    foregroundColor: const Color(0xFF4A1E1D),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: state.isDeleting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF4A1E1D),
                            ),
                          ),
                        )
                      : Text(
                          'Delete Product',
                          style: AppTextStyle.interSemiBold14.copyWith(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF4A1E1D),
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Save Updates Button
            Expanded(
              child: SizedBox(
                height: 46,
                child: ElevatedButton(
                  onPressed: state.isSubmitting ? null : () => cubit.submit(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6BBBAE),
                    foregroundColor: const Color(0xFF1E3A34),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: state.isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF1E3A34),
                            ),
                          ),
                        )
                      : Text(
                          'Save Updates',
                          style: AppTextStyle.interSemiBold14.copyWith(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E3A34),
                          ),
                        ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context) {
    final cubit = context.read<AddEditProductCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: const Text(
            'Are you sure you want to delete this product? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                cubit.delete();
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
