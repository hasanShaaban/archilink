import 'package:archilink/core/services/media_picker_service.dart';
import 'package:archilink/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PostImagesPicker extends MediaPickerService {
  @override
  Future<List<AssetEntity>?> pickImage({
    required BuildContext context,
    required int maxcount,
  }) async {
    
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        requestType: RequestType.image,
        maxAssets: maxcount,
        pickerTheme: AppTheme.darkMode,
      ),
    );
    return result;
  }
}
