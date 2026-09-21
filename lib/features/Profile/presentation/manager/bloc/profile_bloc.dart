import 'dart:async';

import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Post/domain/entity/posts_entity.dart';
import 'package:archilink/features/Post/presentation/manager/cubit/post_like_cubit.dart';
import 'package:archilink/features/Post/presentation/manager/cubit/post_menu_cubit.dart';
import 'package:archilink/features/Post/presentation/view/post.dart';
import 'package:archilink/features/Profile/domain/repo/profile_repo.dart';
import 'package:archilink/features/Store/domain/entity/product_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepo repo;
  late final StreamSubscription _postLikeSubscription;
  StreamSubscription? _postMenuSubscription;

  ProfileBloc(
    this.repo,
    PostLikeCubit postLikeCubit, [
    PostMenuCubit? postMenuCubit,
  ]) : super(ProfileState()) {
    _postLikeSubscription = postLikeCubit.stream.listen((event) {
      if (event == null) return;
      add(UpdateProfilePostLike(event.postId, event.liked, event.likeCount));
    });

    _postMenuSubscription = postMenuCubit?.stream.listen((event) {
      if (event is PostMenuSuccess && event.action == PostMenuAction.delete) {
        add(DeleteProfilePost(postId: event.postId));
      }
    });

    on<UpdateProfilePostLike>(_onUpdateProfilePostLike);
    on<DeleteProfilePost>(_onDeleteProfilePost);
    on<UpdateProfilePostContent>(_onUpdateProfilePostContent);
    on<LoadInitialProfilePosts>(_onLoadInitialPosts);
    on<LoadMoreProfilePosts>(_onLoadMorePosts);
    on<LoadInitialProfileProducts>(_onLoadInitialProducts);
    on<LoadMoreProfileProducts>(_onLoadMoreProducts);
    on<DeleteProfileProduct>(_onDeleteProduct);
  }

  Future<void> _onLoadInitialPosts(
    LoadInitialProfilePosts event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        profilePosts: const [],
        isInitialLoading: true,
        isLoadingMore: false,
        hasReachedMax: false,
        failure: null,
        currentPage: 1,
        activeUsername: event.username,
      ),
    );
    late final Either<Failure, PostsEntity> result;
    final username = event.username;
    if (username != null) {
      result = await repo.getProfilePosts(username: username, page: 1);
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
    final username = state.activeUsername;
    if (username != null) {
      result = await repo.getProfilePosts(
        username: username,
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

  Future<void> _onLoadInitialProducts(
    LoadInitialProfileProducts event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        profileProducts: const [],
        isInitialLoading: true,
        isLoadingMore: false,
        hasReachedMax: false,
        failure: null,
        currentPage: 1,
        activeStoreId: event.storeId,
      ),
    );
    final result = await repo.getStoreProducts(
      storeId: event.storeId,
      page: 1,
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(isInitialLoading: false, failure: failure)),
      (data) => emit(
        state.copyWith(
          profileProducts: data.products,
          isInitialLoading: false,
          currentPage: 1,
          hasReachedMax: !data.pagination.hasMore,
        ),
      ),
    );
  }

  Future<void> _onLoadMoreProducts(
    LoadMoreProfileProducts event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.isLoadingMore || state.hasReachedMax || state.activeStoreId == null) {
      return;
    }
    emit(state.copyWith(isLoadingMore: true));
    final nextPage = state.currentPage + 1;
    final result = await repo.getStoreProducts(
      storeId: state.activeStoreId!,
      page: nextPage,
    );
    result.fold(
      (failure) => emit(state.copyWith(isLoadingMore: false)),
      (data) {
        final products = List<ProductEntity>.from(state.profileProducts)
          ..addAll(data.products);
        emit(
          state.copyWith(
            profileProducts: products,
            isLoadingMore: false,
            currentPage: nextPage,
            hasReachedMax: !data.pagination.hasMore,
          ),
        );
      },
    );
  }

  Future<void> _onDeleteProduct(
    DeleteProfileProduct event,
    Emitter<ProfileState> emit,
  ) async {
    final previousProducts = state.profileProducts;
    final updated =
        state.profileProducts.where((p) => p.id != event.productId).toList();
    emit(state.copyWith(profileProducts: updated));

    final result = await repo.deleteProduct(event.productId);
    result.fold(
      (failure) {
        emit(state.copyWith(
          profileProducts: previousProducts,
          failure: failure,
        ));
      },
      (_) {},
    );
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

  void _onDeleteProfilePost(
    DeleteProfilePost event,
    Emitter<ProfileState> emit,
  ) {
    final updated =
        state.profilePosts.where((p) => p.id != event.postId).toList();
    emit(state.copyWith(profilePosts: updated));
  }

  void _onUpdateProfilePostContent(
    UpdateProfilePostContent event,
    Emitter<ProfileState> emit,
  ) {
    final updated = state.profilePosts.map((post) {
      if (post.id == event.postId) {
        return post.copyWith(
          body: event.body,
          privacy: event.privacy ?? post.privacy,
        );
      }
      return post;
    }).toList();
    emit(state.copyWith(profilePosts: updated));
  }

  @override
  Future<void> close() {
    _postLikeSubscription.cancel();
    _postMenuSubscription?.cancel();
    return super.close();
  }
}
