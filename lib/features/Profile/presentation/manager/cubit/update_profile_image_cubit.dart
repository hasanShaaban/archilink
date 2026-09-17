import 'package:archilink/core/services/media_picker_service.dart';
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
  Future<void> pickImage(BuildContext context) async {
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
      Navigator.of(context, rootNavigator: true).pushNamed(
        CropImageView.name,
        arguments: {
          'imageFile': file,
          'cropType': CropImageType.profileImage,
        },
      );
    }
  }
}
