import 'package:equatable/equatable.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class CreatePostParms extends Equatable{
  final String text;
  final List<String>tags;
  final List<AssetEntity> assetIds;
  final String privacy;

  const CreatePostParms({
    required this.text,
    required this.tags,
    required this.assetIds,
    required this.privacy,
  });

  @override
  List<Object?> get props => [text, tags, assetIds, privacy];
}