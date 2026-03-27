import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

abstract class MediaPickerService {
  Future<List<AssetEntity>?> pickImage({
    required BuildContext context,
    required int maxcount,
  });
}
