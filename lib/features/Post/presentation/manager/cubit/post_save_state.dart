part of 'post_save_cubit.dart';

sealed class PostSaveState extends Equatable {
  const PostSaveState();

  @override
  List<Object?> get props => [];
}

final class PostSaveInitial extends PostSaveState {
  const PostSaveInitial();
}

final class PostSaveLoading extends PostSaveState {
  final int postId;

  const PostSaveLoading({required this.postId});

  @override
  List<Object?> get props => [postId];
}

final class PostSaveSuccess extends PostSaveState {
  final int postId;
  final int collectionId;
  final String collectionTitle;
  final String message;

  const PostSaveSuccess({
    required this.postId,
    required this.collectionId,
    required this.collectionTitle,
    this.message = 'Post saved successfully',
  });

  @override
  List<Object?> get props => [postId, collectionId, collectionTitle, message];
}

final class PostUnsaveSuccess extends PostSaveState {
  final int postId;
  final String message;

  const PostUnsaveSuccess({
    required this.postId,
    this.message = 'Post removed from saved',
  });

  @override
  List<Object?> get props => [postId, message];
}

final class PostSaveFailure extends PostSaveState {
  final int postId;
  final String message;

  const PostSaveFailure({
    required this.postId,
    required this.message,
  });

  @override
  List<Object?> get props => [postId, message];
}
