part of 'post_menu_cubit.dart';

sealed class PostMenuState extends Equatable {
  const PostMenuState();

  @override
  List<Object?> get props => [];
}

/// Nothing has happened yet.
class PostMenuInitial extends PostMenuState {
  const PostMenuInitial();
}

/// A menu action is being processed.
class PostMenuLoading extends PostMenuState {
  final PostMenuAction action;
  final int postId;

  const PostMenuLoading({required this.action, required this.postId});

  @override
  List<Object?> get props => [action, postId];
}

/// A menu action completed successfully.
class PostMenuSuccess extends PostMenuState {
  final PostMenuAction action;
  final int postId;
  final String message;

  const PostMenuSuccess({
    required this.action,
    required this.postId,
    this.message = '',
  });

  @override
  List<Object?> get props => [action, postId, message];
}

/// A menu action failed.
class PostMenuFailure extends PostMenuState {
  final PostMenuAction action;
  final int postId;
  final String message;

  const PostMenuFailure({
    required this.action,
    required this.postId,
    this.message = '',
  });

  @override
  List<Object?> get props => [action, postId, message];
}
