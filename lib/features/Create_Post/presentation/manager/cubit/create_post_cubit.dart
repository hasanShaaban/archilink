import 'package:archilink/core/services/media_picker_service.dart';
import 'package:archilink/features/Create_Post/domain/repo/create_post_repo.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
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

  void removeAsset(AssetEntity asset) {
    final updated = state.selectedAssets
        .where((a) => a.id != asset.id)
        .toList();
    emit(state.copyWith(selectedAssets: updated));
  }

  Future<void> submitPost() async {
    if (!state.canPost) return;
    emit(state.copyWith(isSubmitting: true));
    // TODO: create post logic
    emit(state.copyWith(isSubmitting: false));
  }
}
