import 'dart:async';

import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Post/domain/entity/posts_entity.dart';
import 'package:archilink/features/Post/presentation/manager/cubit/post_like_cubit.dart';
import 'package:archilink/features/Profile/domain/repo/profile_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepo repo;
  late final StreamSubscription _postLikeSubscription;
  ProfileBloc(this.repo, PostLikeCubit postLikeCubit) : super(ProfileState()) {
    _postLikeSubscription = postLikeCubit.stream.listen((event) {
      if (event == null) return;
      add(UpdateProfilePostLike(event.postId, event.liked, event.likeCount));
    });

    on<UpdateProfilePostLike>(_onUpdateProfilePostLike);
    on<LoadInitialProfilePosts>(_onLoadInitialPosts);
    on<LoadMoreProfilePosts>(_onLoadMorePosts);
  }

  Future<void> _onLoadInitialPosts(
    LoadInitialProfilePosts event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isInitialLoading: true));
    late final Either<Failure, PostsEntity> result;
    if (event.username != null) {
      result = await repo.getProfilePosts(username: event.username!, page: 1);
    } else {
      result = await repo.getMyPosts(1);
    }
    result.fold(
      (failure) =>
          emit(state.copyWith(isInitialLoading: false, failure: failure)),
      (data) => emit(
        state.copyWith(
          profilePosts: data.posts,
          isInitialLoading: false,
          currentPage: 1,
          hasReachedMax: !data.pagination.hasMore,
        ),
      ),
    );
  }

  Future<void> _onLoadMorePosts(
    LoadMoreProfilePosts event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.isLoadingMore || state.hasReachedMax) return;
    emit(state.copyWith(isLoadingMore: true));
    final nextPage = state.currentPage + 1;
    late final Either<Failure, PostsEntity> result;
    if (event.username != null) {
      result = await repo.getProfilePosts(
        username: event.username!,
        page: nextPage,
      );
    } else {
      result = await repo.getMyPosts(nextPage);
    }

    result.fold((failure) => emit(state.copyWith(isLoadingMore: false)), (
      data,
    ) {
      final posts = List<PostEntity>.from(state.profilePosts)
        ..addAll(data.posts);
      emit(
        state.copyWith(
          profilePosts: posts,
          isLoadingMore: false,
          currentPage: nextPage,
          hasReachedMax: !data.pagination.hasMore,
        ),
      );
    });
  }

  void _onUpdateProfilePostLike(
    UpdateProfilePostLike event,
    Emitter<ProfileState> emit,
  ) {
    final updatePost = state.profilePosts.map((post) {
      if (post.id == event.postId) {
        return post.copyWith(
          likesCount: event.likesCount,
          likedByMe: event.liked,
        );
      }
      return post;
    }).toList();
    emit(state.copyWith(profilePosts: updatePost));
  }

  @override
  Future<void> close() {
    _postLikeSubscription.cancel();
    return super.close();
  }
}
