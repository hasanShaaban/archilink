import 'dart:developer';

import 'package:archilink/core/services/media_picker_service.dart';
import 'package:archilink/core/utils/fakers.dart';
import 'package:archilink/features/Create_Post/domain/entity/create_post_parms.dart';
import 'package:archilink/features/Create_Post/domain/repo/create_post_repo.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Post/domain/entity/post_owner_entity.dart';
import 'package:archilink/features/Post/domain/entity/tag_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final MediaPickerService mediaPickerService;
  final CreatePostRepo createPostRepo;
  CreatePostCubit({
    required this.mediaPickerService,
    required this.createPostRepo,
  }) : super(const CreatePostState()) {
    loadPosterProfile();
  }

  void loadPosterProfile() {
    final ProfileEntity? profile = createPostRepo.getPosterProfileData();
    if (profile == null) return;
    emit(state.copyWith(profileData: profile));
  }

  void onTextChanged(String text) {
    emit(state.copyWith(postText: text));
  }

  Future<void> pickImages(BuildContext context) async {
    final picked = await mediaPickerService.pickImage(
      previouslySelected: state.selectedAssets,
      context: context,
      maxcount: 9,
    );
    if (picked == null) return;
    emit(state.copyWith(selectedAssets: picked));
  }

  void addTag(String tag) {
    final cleaned = tag.trim();
    if (cleaned.isEmpty) return;
    final exists = state.tags.any(
      (t) => t.trim().toLowerCase() == cleaned.toLowerCase(),
    );
    if (exists) return;
    final updated = List<String>.from(state.tags)..add(cleaned);
    emit(state.copyWith(tags: updated));
  }

  void removeTag(int index) {
    final updated = List<String>.from(state.tags)..removeAt(index);
    emit(state.copyWith(tags: updated));
  }

  void removeAsset(AssetEntity asset) {
    final updated = state.selectedAssets
        .where((a) => a.id != asset.id)
        .toList();
    emit(state.copyWith(selectedAssets: updated));
  }

  void toggleAddingTag(bool isAdding) {
    emit(state.copyWith(isAddingTag: isAdding));
  }

  void setShowTagsInPost(bool show) {
    emit(state.copyWith(showTagsInPost: show, isAddingTag: false));
  }

  void togglePrivacy() {
    final next = state.privacy == 'public' ? 'private' : 'public';
    emit(state.copyWith(privacy: next));
  }

  PostEntity buildPreviewPost() {
    final fallbackOwner = fakePostEntity(id: 0).owner;
    final owner = state.profileData == null
        ? fallbackOwner
        : PostOwnerEntity(
            id: 0,
            name: state.profileData!.name,
            username: state.profileData!.username,
            profilePictureUrl: state.profileData!.profilePictureUrl,
          );

    final tags = List<TagEntity>.generate(
      state.tags.length,
      (index) => TagEntity(name: state.tags[index], id: index),
    );

    return PostEntity(
      id: 0,
      body: state.postText,
      createdAt: DateTime.now(),
      owner: owner,
      tags: tags,
      likesCount: 0,
      commentsCount: 0,
      likedByMe: false,
      mediaItems: const [],
    );
  }

  Future<void> submitPost() async {
    if (!state.canPost) return;
    emit(state.copyWith(isSubmitting: true));
    final parms = CreatePostParms(
      text: state.postText,
      tags: state.tags,
      assetIds: state.selectedAssets,
      privacy: state.privacy,
    );
    final result = await createPostRepo.createPost(parms);
    result.fold(
      (failure) {
        log('Failed to create post: ${failure.message}');
        emit(state.copyWith(isSubmitting: false));
      },
      (response) {
        log('Post created successfully');
        emit(state.copyWith(isSubmitting: false));
        resetDraft();
      },
    );
  }

  void resetDraft() {
    emit(
      state.copyWith(
        postText: '',
        selectedAssets: const [],
        tags: const [],
        isAddingTag: false,
        showTagsInPost: false,
        privacy: 'public',
      ),
    );
  }
}
