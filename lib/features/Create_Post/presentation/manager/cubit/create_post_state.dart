part of 'create_post_cubit.dart';

class CreatePostState extends Equatable {
  final String postText;
  final List<AssetEntity> selectedAssets;
  final bool isSubmitting;
  final ProfileEntity? profileData;
  const CreatePostState({
    this.postText = '',
    this.selectedAssets = const [],
    this.isSubmitting = false,
    this.profileData,
  });

  bool get canPost => postText.trim().isNotEmpty || selectedAssets.isNotEmpty;

  CreatePostState copyWith({
    String? postText,
    List<AssetEntity>? selectedAssets,
    bool? isSubmitting,
    ProfileEntity? profileData,
  }) {
    return CreatePostState(
      postText: postText ?? this.postText,
      selectedAssets: selectedAssets ?? this.selectedAssets,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      profileData: profileData ?? this.profileData,
    );
  }

  @override
  List<Object?> get props => [postText, selectedAssets, isSubmitting, profileData];
}
