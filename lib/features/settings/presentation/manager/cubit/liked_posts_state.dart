import 'package:archilink/features/settings/domain/entity/liked_posts_entity.dart';
import 'package:equatable/equatable.dart';

class LikedPostsState extends Equatable {
  static const Object _noChange = Object();

  const LikedPostsState({
    this.likedPosts = const <LikedPostItemEntity>[],
    this.likedPostsPage = 0,
    this.hasMoreLikedPosts = true,
    this.isLoadingLikedPosts = false,
    this.isLoadingMoreLikedPosts = false,
    this.likedPostsErrorMessage,
  });

  final List<LikedPostItemEntity> likedPosts;
  final int likedPostsPage;
  final bool hasMoreLikedPosts;
  final bool isLoadingLikedPosts;
  final bool isLoadingMoreLikedPosts;
  final String? likedPostsErrorMessage;

  bool get hasLikedPostsData => likedPosts.isNotEmpty;

  LikedPostsState copyWith({
    List<LikedPostItemEntity>? likedPosts,
    int? likedPostsPage,
    bool? hasMoreLikedPosts,
    bool? isLoadingLikedPosts,
    bool? isLoadingMoreLikedPosts,
    Object? likedPostsErrorMessage = _noChange,
  }) {
    return LikedPostsState(
      likedPosts: likedPosts ?? this.likedPosts,
      likedPostsPage: likedPostsPage ?? this.likedPostsPage,
      hasMoreLikedPosts: hasMoreLikedPosts ?? this.hasMoreLikedPosts,
      isLoadingLikedPosts: isLoadingLikedPosts ?? this.isLoadingLikedPosts,
      isLoadingMoreLikedPosts:
          isLoadingMoreLikedPosts ?? this.isLoadingMoreLikedPosts,
      likedPostsErrorMessage: likedPostsErrorMessage == _noChange
          ? this.likedPostsErrorMessage
          : likedPostsErrorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    likedPosts,
    likedPostsPage,
    hasMoreLikedPosts,
    isLoadingLikedPosts,
    isLoadingMoreLikedPosts,
    likedPostsErrorMessage,
  ];
}

final class LikedPostsInitial extends LikedPostsState {
  const LikedPostsInitial();
}
