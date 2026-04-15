part of 'update_profile_image_cubit.dart';

class UpdateProfileImageState extends Equatable {
  final List<AssetEntity>? selectedAsset;
  final bool isProfileImageChnaged;
  const UpdateProfileImageState({
    this.selectedAsset = const [],
    this.isProfileImageChnaged = false,
  });

  UpdateProfileImageState copyWith({
    List<AssetEntity>? selectedAsset,
    bool? isProfileImageChnaged,
  }) {
    return UpdateProfileImageState(
      selectedAsset: selectedAsset ?? this.selectedAsset,
      isProfileImageChnaged:
          isProfileImageChnaged ?? this.isProfileImageChnaged,
    );
  }

  @override
  List<Object?> get props => [selectedAsset, isProfileImageChnaged];
}
