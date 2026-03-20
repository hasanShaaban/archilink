part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final List<PostEntity> profilePosts;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final Failure? failure;
  final int currentPage;

  const ProfileState({
    this.profilePosts = const [],
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.failure,
    this.currentPage = 1,
  });

  ProfileState copyWith({
    List<PostEntity>? profilePosts,
    bool? isInitialLoading,
    bool? isLoadingMore,
    bool? hasReachedMax,
    Failure? failure,
    int? currentPage,
  }) {
    return ProfileState(
      profilePosts: profilePosts ?? this.profilePosts,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      failure: failure,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [
    profilePosts,
    isInitialLoading,
    isLoadingMore,
    hasReachedMax,
    failure,
    currentPage
  ];
}

