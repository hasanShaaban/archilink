part of 'create_post_cubit.dart';

class CreatePostState extends Equatable {
  final String postText;
  final List<AssetEntity> selectedAssets;
  final bool isSubmitting;
  final ProfileEntity? profileData;
  final List<String> tags;
  final bool isAddingTag;
  final bool showTagsInPost;
  const CreatePostState({
    this.postText = '',
    this.selectedAssets = const [],
    this.tags = const [],
    this.isSubmitting = false,
    this.isAddingTag = false,
    this.profileData,
    this.showTagsInPost = false,
  });

  bool get canPost => postText.trim().isNotEmpty || selectedAssets.isNotEmpty;

  CreatePostState copyWith({
    String? postText,
    List<AssetEntity>? selectedAssets,
    bool? isSubmitting,
    ProfileEntity? profileData,
    List<String>? tags,
    bool? isAddingTag,
    bool? showTagsInPost,
  }) {
    return CreatePostState(
      postText: postText ?? this.postText,
      selectedAssets: selectedAssets ?? this.selectedAssets,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      profileData: profileData ?? this.profileData,
      tags: tags ?? this.tags,
      isAddingTag: isAddingTag ?? this.isAddingTag,
      showTagsInPost: showTagsInPost ?? this.showTagsInPost,
    );
  }

  @override
  List<Object?> get props => [
    postText,
    selectedAssets,
    isSubmitting,
    isAddingTag,
    profileData,
    tags,
    showTagsInPost,
  ];
}
