import 'dart:async';

import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Home/domain/entity/feed_item.dart';
import 'package:archilink/features/Home/domain/entity/feed_type.dart';
import 'package:archilink/features/Post/domain/entity/posts_entity.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Home/domain/repo/home_repo.dart';
import 'package:archilink/features/Post/presentation/manager/cubit/post_like_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'for_you_event.dart';
part 'for_you_state.dart';

class ForYouBloc extends Bloc<ForYouEvent, ForYouState> {
  final HomeRepo repo;
  final FeedType feedType;
  late final StreamSubscription _likeSubscription;
  ForYouBloc(this.repo, PostLikeCubit interactions, this.feedType)
    : super(ForYouState()) {
    _likeSubscription = interactions.stream.listen((event) {
      if (event == null) return;
      add(UpdatePostLike(event.postId, event.liked, event.likeCount));
    });
    on<UpdatePostLike>(_onUpdatePostLike);
    on<LoadInitital>(_onLoadInitial);
    on<LoadMore>(_onLoadMore);
    on<RefreshFeed>(_onRefresh);
  }

  Future<void> _onLoadInitial(
    LoadInitital event,
    Emitter<ForYouState> emit,
  ) async {
    emit(state.copyWith(isInitialLoading: true));

    final result = await _fetchFeed(page: 1);

    result.fold(
      (failure) =>
          emit(state.copyWith(isInitialLoading: false, failure: failure)),
      (data) {
        final items = _buildFeedItem(data);

        emit(
          state.copyWith(
            items: items,
            isInitialLoading: false,
            currentPage: 1,
            hasReachedMax: data.posts.isEmpty,
          ),
        );
      },
    );
  }

  Future<void> _onLoadMore(LoadMore event, Emitter<ForYouState> emit) async {
    if (state.isLoadingMore || state.hasReachedMax) return;
    emit(state.copyWith(isLoadingMore: true));
    final nextPage = state.currentPage + 1;
    final result = await _fetchFeed(page: nextPage);

    result.fold((failure) => emit(state.copyWith(isLoadingMore: false)), (
      data,
    ) {
      if (data.posts.isEmpty) {
        emit(state.copyWith(isLoadingMore: false, hasReachedMax: true));
      } else {
        final newItems = _injectPosts(
          existing: state.items,
          newPosts: data.posts,
        );

        emit(
          state.copyWith(
            items: newItems,
            isLoadingMore: false,
            currentPage: nextPage,
          ),
        );
      }
    });
  }

  Future<Either<Failure, PostsEntity>> _fetchFeed({required int page}) {
    return switch (feedType) {
      FeedType.forYou => repo.getGlobalFeed(page: page),
      FeedType.following => repo.getFollowingFeed(page: page),
    };
  }

  Future<void> _onRefresh(RefreshFeed event, Emitter<ForYouState> emit) async {
    emit(ForYouState());
    add(LoadInitital());
  }

  List<FeedItem> _buildFeedItem(PostsEntity data) {
    return data.posts.map((post) => PostItem(post)).toList();
  }

  List<FeedItem> _injectPosts({
    required List<FeedItem> existing,
    required List<PostEntity> newPosts,
  }) {
    final updatedList = List<FeedItem>.from(existing);
    final wrappedPosts = newPosts.map((post) => PostItem(post)).toList();

    updatedList.addAll(wrappedPosts);

    return updatedList;
  }

  void _onUpdatePostLike(UpdatePostLike event, Emitter<ForYouState> emit) {
    final updatedItems = state.items.map((item) {
      if (item is PostItem && item.post.id == event.postId) {
        return PostItem(
          item.post.copyWith(
            likedByMe: event.liked,
            likesCount: event.likesCount,
          ),
        );
      }
      return item;
    }).toList();
    emit(state.copyWith(items: updatedItems));
  }

  @override
  Future<void> close() {
    _likeSubscription.cancel();
    return super.close();
  }
}
