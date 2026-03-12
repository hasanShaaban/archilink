part of 'post_details_bloc.dart';

class PostDetailsState extends Equatable {
  final PostEntity post;
  final List<CommentEntity> comments;

  final bool isLoadingComments;
  final bool isLoadingMoreComments;
  final bool hasReachedMax;

  final int currentPage;

  final Failure? failure;

  const PostDetailsState({
    required this.post,
    this.comments = const [],
    this.isLoadingComments = false,
    this.isLoadingMoreComments = false,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.failure,
  });

  PostDetailsState copyWith({
    PostEntity? post,
    List<CommentEntity>? comments,
    bool? isLoadingComments,
    bool? isLoadingMoreComments,
    bool? hasReachedMax,
    int? currentPage,
    Failure? failure,
  }) {
    return PostDetailsState(
      post: post ?? this.post,
      comments: comments ?? this.comments,
      isLoadingComments: isLoadingComments ?? this.isLoadingComments,
      isLoadingMoreComments:
          isLoadingMoreComments ?? this.isLoadingMoreComments,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      failure: failure,
    );
  }

  @override
  List<Object> get props => [
    post,
    comments,
    isLoadingComments,
    isLoadingMoreComments,
    hasReachedMax,
    currentPage,
  ];
}
