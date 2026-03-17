part of 'post_details_bloc.dart';

class PostDetailsState extends Equatable {
  final PostEntity post;
  final List<CommentNode> comments;
  final bool isLoadingPost;
  final bool isLoadingComments;
  final bool isLoadingMoreComments;
  final bool hasReachedMax;
  final bool isAddingcomment;

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
    this.isLoadingPost = false,
    this.isAddingcomment = false
  });

  PostDetailsState copyWith({
    PostEntity? post,
    List<CommentNode>? comments,
    bool? isLoadingPost,
    bool? isLoadingComments,
    bool? isLoadingMoreComments,
    bool? hasReachedMax,
    bool? isAddingcomment,
    int? currentPage,
    Failure? failure,
  }) {
    return PostDetailsState(
      post: post ?? this.post,
      comments: comments ?? this.comments,
      isLoadingComments: isLoadingComments ?? this.isLoadingComments,
      isLoadingPost: isLoadingPost ?? this.isLoadingPost,
      isLoadingMoreComments:
          isLoadingMoreComments ?? this.isLoadingMoreComments,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isAddingcomment: isAddingcomment ?? this.isAddingcomment,
      currentPage: currentPage ?? this.currentPage,
      failure: failure,
    );
  }

  @override
  List<Object> get props => [
    post,
    comments,
    isLoadingComments,
    isLoadingPost,
    isLoadingMoreComments,
    hasReachedMax,
    currentPage,
    isAddingcomment
  ];
}
