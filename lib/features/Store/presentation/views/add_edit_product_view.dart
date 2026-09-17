import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Store/domain/entity/product_entity.dart';
import 'package:archilink/features/Store/domain/repo/store_repo.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/add_edit_product_cubit.dart';
import 'package:archilink/features/Store/presentation/views/widgets/add_edit_product_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditProductView extends StatelessWidget {
  const AddEditProductView({super.key, this.product});

  final ProductEntity? product;

  static const String name = '/addEditProduct';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditMode = product != null;
    final title = isEditMode ? "${product!.name}'s Details" : 'New Product';

    return BlocProvider(
      create: (_) => AddEditProductCubit(
        storeRepo: sl.isRegistered<StoreRepo>() ? sl<StoreRepo>() : null,
        initialProduct: product,
      )..fetchCategories(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            title,
            style: AppTextStyle.interSemiBold16.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          titleSpacing: 0,
          centerTitle: false,
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: const SafeArea(
          child: AddEditProductViewBody(),
        ),
      ),
    );
  }
}
