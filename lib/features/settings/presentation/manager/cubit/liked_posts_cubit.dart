import 'package:archilink/features/settings/domain/entity/liked_posts_entity.dart';
import 'package:archilink/features/settings/domain/repo/setting_repo.dart';
import 'package:bloc/bloc.dart';

import 'liked_posts_state.dart';

class LikedPostsCubit extends Cubit<LikedPostsState> {
  LikedPostsCubit(this._settingRepo) : super(const LikedPostsInitial());

  final SettingRepo _settingRepo;

  Future<void> fetchLikedPosts({bool refresh = false}) async {
    if (state.isLoadingLikedPosts || state.isLoadingMoreLikedPosts) return;

    if (!refresh && state.likedPostsPage > 0 && !state.hasMoreLikedPosts) return;

    final nextPage = refresh ? 1 : (state.likedPostsPage + 1);
    final isFirstPage = nextPage == 1;

    emit(
      state.copyWith(
        isLoadingLikedPosts: isFirstPage,
        isLoadingMoreLikedPosts: !isFirstPage,
        likedPostsErrorMessage: null,
      ),
    );

    final result = await _settingRepo.getLikedPosts(page: nextPage);
    if (isClosed) return;

    result.fold((failure) {
      emit(
        state.copyWith(
          isLoadingLikedPosts: false,
          isLoadingMoreLikedPosts: false,
          likedPostsErrorMessage: failure.message,
        ),
      );
    }, (likedPostsData) {
      final posts = isFirstPage
          ? likedPostsData.likes
          : _mergePosts(state.likedPosts, likedPostsData.likes);

      emit(
        state.copyWith(
          isLoadingLikedPosts: false,
          isLoadingMoreLikedPosts: false,
          likedPostsErrorMessage: null,
          likedPosts: posts,
          likedPostsPage: likedPostsData.pagination.currentPage,
          hasMoreLikedPosts: likedPostsData.pagination.hasMore,
        ),
      );
    });
  }

  List<LikedPostItemEntity> _mergePosts(
    List<LikedPostItemEntity> currentPosts,
    List<LikedPostItemEntity> incomingPosts,
  ) {
    final merged = <LikedPostItemEntity>[...currentPosts];
    final ids = currentPosts.map((e) => e.entity.id).toSet();

    for (final post in incomingPosts) {
      if (ids.add(post.entity.id)) {
        merged.add(post);
      }
    }

    return merged;
  }
}
