import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/settings/domain/entity/user_collection_entity.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/user_collections_cubit.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/user_collections_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollectionTitleDialog extends StatefulWidget {
  const CollectionTitleDialog({
    super.key,
    this.collection,
  });

  final UserCollectionEntity? collection;

  bool get isEdit => collection != null;

  static Future<bool?> show(
    BuildContext context, {
    UserCollectionEntity? collection,
  }) {
    final cubit = context.read<UserCollectionsCubit>();
    if (collection != null) {
      cubit.clearEditCollectionError();
    } else {
      cubit.clearCreateCollectionError();
    }

    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: cubit,
          child: CollectionTitleDialog(collection: collection),
        );
      },
    );
  }

  @override
  State<CollectionTitleDialog> createState() => _CollectionTitleDialogState();
}

class _CollectionTitleDialogState extends State<CollectionTitleDialog> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.collection?.title ?? '');
    if (_controller.text.isNotEmpty) {
      _controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _controller.text.length,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final text = _controller.text.trim();

    if (widget.isEdit) {
      if (text == widget.collection!.title.trim()) {
        Navigator.of(context).pop(false);
        return;
      }
      final success =
          await context.read<UserCollectionsCubit>().editCollectionName(
                id: widget.collection!.id,
                name: text,
              );

      if (success && mounted) {
        Navigator.of(context).pop(true);
      }
    } else {
      final success =
          await context.read<UserCollectionsCubit>().createCollection(
                title: text,
              );

      if (success && mounted) {
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCollectionsCubit, UserCollectionsState>(
      builder: (context, state) {
        final isLoading = widget.isEdit
            ? state.isEditingCollection
            : state.isCreatingCollection;

        final errorMessage = widget.isEdit
            ? state.editCollectionErrorMessage
            : state.createCollectionErrorMessage;

        return PopScope(
          canPop: !isLoading,
          child: AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: AppColorsFromTheme.borderColor(context),
              ),
            ),
            title: Text(
              widget.isEdit ? 'Edit collection' : 'New collection',
              style: AppTextStyle.interSemiBold16.copyWith(
                color: AppColorsFromTheme.textColor(context),
              ),
            ),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _controller,
                    autofocus: true,
                    enabled: !isLoading,
                    style: AppTextStyle.interMedium14.copyWith(
                      color: AppColorsFromTheme.textColor(context),
                    ),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a collection title';
                      }
                      if (value.trim().length > 50) {
                        return 'Title must be 50 characters or less';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Collection title',
                      hintStyle: AppTextStyle.interMedium12.copyWith(
                        color: AppColorsFromTheme.grayForText(context),
                      ),
                      filled: true,
                      fillColor: AppColorsFromTheme.secondaryColor(context),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColorsFromTheme.borderColor(context),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColorsFromTheme.primaryColor(context),
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.red,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.red,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  if (errorMessage != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      errorMessage,
                      style: AppTextStyle.interMedium12.copyWith(
                        color: AppColors.red,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actionsPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            actions: [
              TextButton(
                onPressed:
                    isLoading ? null : () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancel',
                  style: AppTextStyle.interSemiBold14.copyWith(
                    color: AppColorsFromTheme.grayForText(context),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorsFromTheme.primaryColor(context),
                  disabledBackgroundColor:
                      AppColorsFromTheme.primaryColor(context)
                          .withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  elevation: 0,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        widget.isEdit ? 'Save' : 'Confirm',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
