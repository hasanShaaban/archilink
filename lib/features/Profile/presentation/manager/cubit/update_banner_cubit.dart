import 'package:archilink/core/services/media_picker_service.dart';
import 'package:archilink/features/Profile/presentation/views/crop_image_view.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

part 'update_banner_state.dart';

class UpdateBannerCubit extends Cubit<UpdateBannerState> {
  final MediaPickerService bannerImagePicker;

  UpdateBannerCubit(this.bannerImagePicker)
      : super(const UpdateBannerState());

  Future<void> pickBanner(BuildContext context) async {
    final picked = await bannerImagePicker.pickImage(
      context: context,
      previouslySelected: null,
      maxcount: 1,
    );
    if (picked == null || picked.isEmpty) return;
    final file = await picked.first.file;
    if (file == null) return;

    emit(
      state.copyWith(
        isBannerChanged: true,
        selectedAsset: picked,
        status: BannerUploadStatus.success,
      ),
    );

    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pushNamed(
        CropImageView.name,
        arguments: {
          'imageFile': file,
          'cropType': CropImageType.bannerImage,
        },
      );
    }
  }
}
