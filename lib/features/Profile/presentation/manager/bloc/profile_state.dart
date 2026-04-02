part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final List<PostEntity> profilePosts;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final Failure? failure;
  final int currentPage;
  final String? activeUsername;

  const ProfileState({
    this.profilePosts = const [],
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.failure,
    this.currentPage = 1,
    this.activeUsername,
  });

  ProfileState copyWith({
    List<PostEntity>? profilePosts,
    bool? isInitialLoading,
    bool? isLoadingMore,
    bool? hasReachedMax,
    Failure? failure,
    int? currentPage,
    String? activeUsername,
  }) {
    return ProfileState(
      profilePosts: profilePosts ?? this.profilePosts,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      failure: failure,
      currentPage: currentPage ?? this.currentPage,
      activeUsername: activeUsername ?? this.activeUsername,
    );
  }

  @override
  List<Object?> get props => [
    profilePosts,
    isInitialLoading,
    isLoadingMore,
    hasReachedMax,
    failure,
    currentPage,
    activeUsername
  ];
}
