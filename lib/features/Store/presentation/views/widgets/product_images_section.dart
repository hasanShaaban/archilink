import 'dart:io';

import 'package:archilink/core/theme/app_theme.dart';
import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/add_edit_product_cubit.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/add_edit_product_state.dart';
import 'package:archilink/features/Store/presentation/views/widgets/product_image_item.dart';
import 'package:archilink/features/Store/presentation/views/widgets/product_page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ProductImagesSection extends StatefulWidget {
  const ProductImagesSection({super.key});

  @override
  State<ProductImagesSection> createState() => _ProductImagesSectionState();
}

class _ProductImagesSectionState extends State<ProductImagesSection> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.48);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _pickPhotos(BuildContext context) async {
    try {
      final List<AssetEntity>? assets = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          requestType: RequestType.image,
          maxAssets: 5,
          pickerTheme: AppTheme.darkMode,
        ),
      );

      if (assets != null && assets.isNotEmpty && context.mounted) {
        final List<String> paths = [];
        for (final asset in assets) {
          final file = await asset.file;
          if (file != null) {
            paths.add(file.path);
          }
        }
        if (paths.isNotEmpty && context.mounted) {
          context.read<AddEditProductCubit>().addImages(paths);
        }
      }
    } catch (_) {
      // Graceful fallback if asset picker fails or in headless test environment
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<AddEditProductCubit, AddEditProductState>(
      builder: (context, state) {
        final cubit = context.read<AddEditProductCubit>();
        final images = state.images;
        final itemCount = images.isNotEmpty ? images.length : 3;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Image Carousel
            SizedBox(
              height: 180,
              child: PageView.builder(
                controller: _pageController,
                itemCount: itemCount,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: _buildImageCard(
                      context,
                      images: images,
                      index: index,
                      isDark: isDark,
                      onDelete: () => cubit.removeImage(index),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Indicator Dots
            Center(
              child: ProductPageIndicator(
                itemCount: itemCount,
                currentIndex: _currentIndex.clamp(0, itemCount - 1),
                dotSize: 7,
                spacing: 3.5,
              ),
            ),
            const SizedBox(height: 14),

            // "Add Photos" Button
            _buildAddPhotosButton(context, isDark),
          ],
        );
      },
    );
  }

  Widget _buildImageCard(
    BuildContext context, {
    required List<String> images,
    required int index,
    required bool isDark,
    required VoidCallback onDelete,
  }) {
    final placeholderBg = isDark
        ? const Color(0xFF242527)
        : const Color(0xFFD9D9D9);

    if (images.isEmpty || index >= images.length) {
      // Empty placeholder card matching design
      return Container(
        decoration: BoxDecoration(
          color: placeholderBg,
          borderRadius: BorderRadius.circular(16),
        ),
      );
    }

    final imagePath = images[index];
    final isNetwork = imagePath.startsWith('http');
    final isFile = File(imagePath).existsSync();

    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: isNetwork
                ? ProductImageItem(
                    imageUrl: imagePath,
                    fit: BoxFit.cover,
                  )
                : isFile
                    ? Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                      )
                    : Container(color: placeholderBg),
          ),
        ),

        // Delete photo button
        Positioned(
          top: 6,
          right: 6,
          child: GestureDetector(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddPhotosButton(BuildContext context, bool isDark) {
    return InkWell(
      onTap: () => _pickPhotos(context),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF242527) : const Color(0xFFEFEFEF),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColorsFromTheme.borderColor(context).withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 18,
              color: isDark ? Colors.white : const Color(0xFF2B2C2E),
            ),
            const SizedBox(width: 6),
            Text(
              'Add Photos',
              style: AppTextStyle.interMedium12.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF2B2C2E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
