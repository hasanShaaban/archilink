part of 'create_post_cubit.dart';

class CreatePostState extends Equatable {
  final String postText;
  final List<AssetEntity> selectedAssets;
  final bool isSubmitting;
  const CreatePostState({
    this.postText = '',
    this.selectedAssets = const [],
    this.isSubmitting = false,
  });

  bool get canPost => postText.trim().isNotEmpty || selectedAssets.isNotEmpty;

  CreatePostState copyWith({
    String? postText,
    List<AssetEntity>? selectedAssets,
    bool? isSubmitting,
  }) {
    return CreatePostState(
      postText: postText ?? this.postText,
      selectedAssets: selectedAssets ?? this.selectedAssets,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object> get props => [postText, selectedAssets, isSubmitting];
}
