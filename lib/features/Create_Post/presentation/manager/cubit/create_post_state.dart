part of 'create_post_cubit.dart';

class CreatePostState extends Equatable {
  final String postText;
  final List<AssetEntity> selectedAssets;
  final bool isSubmitting;
  final ProfileEntity? profileData;
  final List<String> tags;
  final bool isAddingTag;
  final bool showTagsInPost;
  final String privacy;
  final Failure? failure;
  final bool isEditMode;
  final int? editingPostId;
  final List<MediaItemEntity> existingMediaItems;
  final bool updateSuccess;

  const CreatePostState({
    this.postText = '',
    this.selectedAssets = const [],
    this.tags = const [],
    this.isSubmitting = false,
    this.isAddingTag = false,
    this.profileData,
    this.showTagsInPost = false,
    this.privacy = 'public',
    this.failure,
    this.isEditMode = false,
    this.editingPostId,
    this.existingMediaItems = const [],
    this.updateSuccess = false,
  });

  bool get canPost => postText.trim().isNotEmpty;

  CreatePostState copyWith({
    String? postText,
    List<AssetEntity>? selectedAssets,
    bool? isSubmitting,
    ProfileEntity? profileData,
    List<String>? tags,
    bool? isAddingTag,
    bool? showTagsInPost,
    String? privacy,
    Failure? failure,
    bool? isEditMode,
    int? editingPostId,
    List<MediaItemEntity>? existingMediaItems,
    bool? updateSuccess,
  }) {
    return CreatePostState(
      postText: postText ?? this.postText,
      selectedAssets: selectedAssets ?? this.selectedAssets,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      profileData: profileData ?? this.profileData,
      tags: tags ?? this.tags,
      isAddingTag: isAddingTag ?? this.isAddingTag,
      showTagsInPost: showTagsInPost ?? this.showTagsInPost,
      privacy: privacy ?? this.privacy,
      failure: failure,
      isEditMode: isEditMode ?? this.isEditMode,
      editingPostId: editingPostId ?? this.editingPostId,
      existingMediaItems: existingMediaItems ?? this.existingMediaItems,
      updateSuccess: updateSuccess ?? this.updateSuccess,
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
    privacy,
    failure,
    isEditMode,
    editingPostId,
    existingMediaItems,
    updateSuccess,
  ];
}
