import 'package:archilink/features/Store/presentation/manager/cubit/add_edit_product_cubit.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/add_edit_product_state.dart';
import 'package:archilink/features/Store/presentation/views/widgets/add_edit_product_action_buttons.dart';
import 'package:archilink/features/Store/presentation/views/widgets/product_category_field.dart';
import 'package:archilink/features/Store/presentation/views/widgets/product_form_field.dart';
import 'package:archilink/features/Store/presentation/views/widgets/product_images_section.dart';
import 'package:archilink/features/Store/presentation/views/widgets/product_quantity_stepper.dart';
import 'package:archilink/features/Store/presentation/views/widgets/product_status_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditProductViewBody extends StatefulWidget {
  const AddEditProductViewBody({super.key});

  @override
  State<AddEditProductViewBody> createState() => _AddEditProductViewBodyState();
}

class _AddEditProductViewBodyState extends State<AddEditProductViewBody> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<AddEditProductCubit>();
    _nameController = TextEditingController(text: cubit.state.name);
    _descriptionController = TextEditingController(text: cubit.state.description);
    _priceController = TextEditingController(
      text: cubit.state.price.isNotEmpty
          ? (cubit.state.isEditMode ? '${cubit.state.price} \$' : cubit.state.price)
          : '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddEditProductCubit>();

    return BlocListener<AddEditProductCubit, AddEditProductState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.isEditMode
                    ? 'Product updated successfully'
                    : 'Product added successfully',
              ),
              backgroundColor: const Color(0xFF008080),
            ),
          );
          Navigator.of(context).pop(true);
        }
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image Carousel Section
            const ProductImagesSection(),
            const SizedBox(height: 16),

            // Product Name
            ProductFormField(
              label: 'Name',
              hintText: 'Product Name',
              controller: _nameController,
              onChanged: cubit.updateName,
            ),
            const SizedBox(height: 14),

            // Product Description
            ProductFormField(
              label: 'Description',
              hintText: 'Describe your product',
              controller: _descriptionController,
              minLines: 3,
              maxLines: 6,
              onChanged: cubit.updateDescription,
            ),
            const SizedBox(height: 14),

            // Price Field
            ProductFormField(
              label: 'Price',
              hintText: '--- \$',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              controller: _priceController,
              onChanged: (val) {
                final cleaned = val.replaceAll('\$', '').trim();
                cubit.updatePrice(cleaned);
              },
            ),
            const SizedBox(height: 14),

            // Status Dropdown
            const ProductStatusDropdown(),

            // Quantity Stepper (conditionally displayed based on status)
            BlocBuilder<AddEditProductCubit, AddEditProductState>(
              buildWhen: (prev, curr) =>
                  prev.status != curr.status ||
                  prev.isQuantityVisible != curr.isQuantityVisible,
              builder: (context, state) {
                if (!state.isQuantityVisible) {
                  return const SizedBox.shrink();
                }
                return const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 14),
                    ProductQuantityStepper(),
                  ],
                );
              },
            ),
            const SizedBox(height: 14),

            // Category Field & Chips
            const ProductCategoryField(),
            const SizedBox(height: 24),

            // Action Buttons
            const AddEditProductActionButtons(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
