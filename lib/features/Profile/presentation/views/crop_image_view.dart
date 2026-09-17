import 'dart:io';

import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

enum CropImageType { profileImage, bannerImage }

class CropImageView extends StatefulWidget {
  const CropImageView({
    super.key,
    required this.imageFile,
    this.cropType = CropImageType.profileImage,
    this.cropper,
    this.onConfirm,
  });

  final File imageFile;
  final CropImageType cropType;
  final ImageCropper? cropper;
  final void Function(File file)? onConfirm;

  static const String name = '/cropImage';

  @override
  State<CropImageView> createState() => _CropImageViewState();
}

class _CropImageViewState extends State<CropImageView> {
  late File _currentFile;
  CroppedFile? _croppedFile;
  bool _isCropping = false;

  ImageCropper get _cropper => widget.cropper ?? ImageCropper();

  bool get _isProfile => widget.cropType == CropImageType.profileImage;

  @override
  void initState() {
    super.initState();
    _currentFile = widget.imageFile;
  }

  Future<void> _cropImage() async {
    if (_isCropping) return;
    setState(() => _isCropping = true);

    try {
      final uiSettings = [
        AndroidUiSettings(
          toolbarTitle:
              _isProfile ? 'Crop Profile Picture' : 'Crop Banner Image',
          toolbarColor: AppColors.tael,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: AppColors.tael,
          initAspectRatio: _isProfile
              ? CropAspectRatioPreset.square
              : CropAspectRatioPreset.ratio16x9,
          lockAspectRatio: false,
          aspectRatioPresets: _isProfile
              ? [
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.original,
                ]
              : [
                  CropAspectRatioPreset.ratio16x9,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.original,
                ],
          cropStyle:
              _isProfile ? CropStyle.circle : CropStyle.rectangle,
        ),
        IOSUiSettings(
          title: _isProfile ? 'Crop Profile Picture' : 'Crop Banner Image',
          aspectRatioLockEnabled: false,
          aspectRatioPresets: _isProfile
              ? [
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.original,
                ]
              : [
                  CropAspectRatioPreset.ratio16x9,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.original,
                ],
          cropStyle:
              _isProfile ? CropStyle.circle : CropStyle.rectangle,
        ),
        WebUiSettings(
          context: context,
          presentStyle: WebPresentStyle.dialog,
          size: const CropperSize(width: 520, height: 520),
        ),
      ];

      final cropped = await _cropper.cropImage(
        sourcePath: _currentFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 95,
        aspectRatio: _isProfile
            ? const CropAspectRatio(ratioX: 1, ratioY: 1)
            : const CropAspectRatio(ratioX: 16, ratioY: 9),
        uiSettings: uiSettings,
      );

      if (cropped != null && mounted) {
        setState(() {
          _croppedFile = cropped;
          _currentFile = File(cropped.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to crop image: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCropping = false);
      }
    }
  }

  void _resetImage() {
    setState(() {
      _croppedFile = null;
      _currentFile = widget.imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    final title = _isProfile ? 'Edit Profile Picture' : 'Edit Banner Image';
    final confirmButtonText =
        _isProfile ? 'Confirm Profile Picture' : 'Confirm Banner Image';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          title,
          style: AppTextStyle.interSemiBold16.copyWith(
            fontSize: 18,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _croppedFile != null
                              ? AppColors.tael.withValues(alpha: 0.15)
                              : AppColorsFromTheme.secondaryColor(context),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _croppedFile != null
                                ? AppColors.tael
                                : AppColorsFromTheme.borderColor(context)
                                    .withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _croppedFile != null
                                  ? Icons.check_circle_outline
                                  : Icons.info_outline,
                              size: 16,
                              color: _croppedFile != null
                                  ? AppColors.tael
                                  : AppColorsFromTheme.grayForText(context),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _croppedFile != null
                                  ? 'Cropped & Resized'
                                  : 'Original Image',
                              style: AppTextStyle.interMedium12.copyWith(
                                color: _croppedFile != null
                                    ? AppColors.tael
                                    : AppColorsFromTheme.grayForText(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Image Preview Frame
                      Center(
                        child: _isProfile
                            ? _buildAvatarPreview(screenWidth, isDark)
                            : _buildBannerPreview(screenWidth, isDark),
                      ),

                      const SizedBox(height: 28),

                      // Action buttons: Crop/Resize and Reset
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _isCropping ? null : _cropImage,
                            icon: _isCropping
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.crop, size: 20),
                            label: Text(
                              _croppedFile != null ? 'Re-crop' : 'Crop & Resize',
                              style: AppTextStyle.interSemiBold14.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.tael,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          if (_croppedFile != null) ...[
                            const SizedBox(width: 14),
                            OutlinedButton.icon(
                              onPressed: _resetImage,
                              icon: const Icon(Icons.refresh, size: 18),
                              label: const Text('Reset'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor:
                                    Theme.of(context).colorScheme.onSurface,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 12,
                                ),
                                side: BorderSide(
                                  color: AppColorsFromTheme.borderColor(context),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _isProfile
                            ? 'Recommended aspect ratio: 1:1 (Square)'
                            : 'Recommended aspect ratio: 16:9 (Banner)',
                        style: AppTextStyle.interRegular12.copyWith(
                          color: AppColorsFromTheme.grayForText(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Confirm button (action left empty for upcoming request implementation)
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Empty callback placeholder for upcoming update request implementation
                      widget.onConfirm?.call(_currentFile);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tael,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      confirmButtonText,
                      style: AppTextStyle.interBold20.copyWith(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarPreview(double screenWidth, bool isDark) {
    final avatarSize = screenWidth * 0.65;

    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.tael,
          width: 3.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipOval(
        child: kIsWeb
            ? Image.network(
                _currentFile.path,
                fit: BoxFit.cover,
                width: avatarSize,
                height: avatarSize,
              )
            : Image.file(
                _currentFile,
                fit: BoxFit.cover,
                width: avatarSize,
                height: avatarSize,
              ),
      ),
    );
  }

  Widget _buildBannerPreview(double screenWidth, bool isDark) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 220),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.tael,
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13.5),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: kIsWeb
              ? Image.network(
                  _currentFile.path,
                  fit: BoxFit.cover,
                )
              : Image.file(
                  _currentFile,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
