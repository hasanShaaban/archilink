import 'package:archilink/core/services/media_picker_service.dart';
import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/features/Profile/presentation/views/crop_image_view.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

part 'update_profile_image_state.dart';

class UpdateProfileImageCubit extends Cubit<UpdateProfileImageState> {
  final MediaPickerService profileImagePicker;
  UpdateProfileImageCubit(this.profileImagePicker)
    : super(const UpdateProfileImageState());
  Future<void> pickImage(BuildContext context, {bool isStore = false}) async {
    final picked = await profileImagePicker.pickImage(
      context: context,
      previouslySelected: null,
      maxcount: 1,
    );
    if (picked == null || picked.isEmpty) return;
    final file = await picked.first.file;
    if (file == null) return;

    emit(state.copyWith(isProfileImageChnaged: true, selectedAsset: picked));

    if (context.mounted) {
      final updated =
          await Navigator.of(context, rootNavigator: true).pushNamed(
        CropImageView.name,
        arguments: {
          'imageFile': file,
          'cropType': CropImageType.profileImage,
          'isStore': isStore,
        },
      );

      if (updated == true && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isStore
                  ? 'Store logo updated successfully'
                  : 'Profile picture updated successfully',
            ),
            backgroundColor: AppColors.tael,
          ),
        );
      }
    }
  }
}
