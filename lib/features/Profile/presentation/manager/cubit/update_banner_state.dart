part of 'update_banner_cubit.dart';

enum BannerUploadStatus { initial, loading, success, failure }

class UpdateBannerState extends Equatable {
  final List<AssetEntity>? selectedAsset;
  final bool isBannerChanged;
  final BannerUploadStatus status;
  final String? errorMessage;

  const UpdateBannerState({
    this.selectedAsset = const [],
    this.isBannerChanged = false,
    this.status = BannerUploadStatus.initial,
    this.errorMessage,
  });

  UpdateBannerState copyWith({
    List<AssetEntity>? selectedAsset,
    bool? isBannerChanged,
    BannerUploadStatus? status,
    String? errorMessage,
  }) {
    return UpdateBannerState(
      selectedAsset: selectedAsset ?? this.selectedAsset,
      isBannerChanged: isBannerChanged ?? this.isBannerChanged,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    selectedAsset,
    isBannerChanged,
    status,
    errorMessage,
  ];
}
