part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final List<PostEntity> profilePosts;
  final List<ProductEntity> profileProducts;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final Failure? failure;
  final int currentPage;
  final String? activeUsername;
  final int? activeStoreId;

  const ProfileState({
    this.profilePosts = const [],
    this.profileProducts = const [],
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.failure,
    this.currentPage = 1,
    this.activeUsername,
    this.activeStoreId,
  });

  ProfileState copyWith({
    List<PostEntity>? profilePosts,
    List<ProductEntity>? profileProducts,
    bool? isInitialLoading,
    bool? isLoadingMore,
    bool? hasReachedMax,
    Failure? failure,
    int? currentPage,
    String? activeUsername,
    int? activeStoreId,
  }) {
    return ProfileState(
      profilePosts: profilePosts ?? this.profilePosts,
      profileProducts: profileProducts ?? this.profileProducts,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      failure: failure,
      currentPage: currentPage ?? this.currentPage,
      activeUsername: activeUsername ?? this.activeUsername,
      activeStoreId: activeStoreId ?? this.activeStoreId,
    );
  }

  @override
  List<Object?> get props => [
    profilePosts,
    profileProducts,
    isInitialLoading,
    isLoadingMore,
    hasReachedMax,
    failure,
    currentPage,
    activeUsername,
    activeStoreId,
  ];
}
