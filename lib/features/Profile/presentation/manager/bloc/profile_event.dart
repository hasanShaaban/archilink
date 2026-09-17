part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadInitialProfilePosts extends ProfileEvent {
  final String? username;

  const LoadInitialProfilePosts({this.username});
}

class LoadMoreProfilePosts extends ProfileEvent {
  final String? username;

  const LoadMoreProfilePosts({this.username});
}

class RefreshProfilePosts extends ProfileEvent {}

class UpdateProfilePostLike extends ProfileEvent {
  final int postId;
  final bool liked;
  final int likesCount;
  const UpdateProfilePostLike(this.postId, this.liked, this.likesCount);

  @override
  List<Object> get props => [postId, liked, likesCount];
}

class LoadInitialProfileProducts extends ProfileEvent {
  final int storeId;
  const LoadInitialProfileProducts({required this.storeId});

  @override
  List<Object> get props => [storeId];
}

class LoadMoreProfileProducts extends ProfileEvent {
  const LoadMoreProfileProducts();
}

class DeleteProfileProduct extends ProfileEvent {
  final int productId;
  const DeleteProfileProduct({required this.productId});

  @override
  List<Object> get props => [productId];
}

