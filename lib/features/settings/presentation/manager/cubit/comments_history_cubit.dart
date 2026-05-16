import 'package:archilink/features/settings/domain/entity/comments_history_entity.dart';
import 'package:archilink/features/settings/domain/repo/setting_repo.dart';
import 'package:bloc/bloc.dart';

import 'comments_history_state.dart';

class CommentsHistoryCubit extends Cubit<CommentsHistoryState> {
  CommentsHistoryCubit(this._settingRepo) : super(const CommentsHistoryInitial());

  final SettingRepo _settingRepo;

  Future<void> fetchCommentsHistory({bool refresh = false}) async {
    if (state.isLoadingComments || state.isLoadingMoreComments) return;

    if (!refresh && state.commentsPage > 0 && !state.hasMoreComments) return;

    final nextPage = refresh ? 1 : (state.commentsPage + 1);
    final isFirstPage = nextPage == 1;

    emit(
      state.copyWith(
        isLoadingComments: isFirstPage,
        isLoadingMoreComments: !isFirstPage,
        commentsErrorMessage: null,
      ),
    );

    final result = await _settingRepo.getCommentsHistory(page: nextPage);
    if (isClosed) return;

    result.fold((failure) {
      emit(
        state.copyWith(
          isLoadingComments: false,
          isLoadingMoreComments: false,
          commentsErrorMessage: failure.message,
        ),
      );
    }, (commentsHistoryData) {
      final comments = isFirstPage
          ? commentsHistoryData.comments
          : _mergeComments(state.comments, commentsHistoryData.comments);

      emit(
        state.copyWith(
          isLoadingComments: false,
          isLoadingMoreComments: false,
          commentsErrorMessage: null,
          comments: comments,
          commentsPage: commentsHistoryData.pagination.currentPage,
          hasMoreComments: commentsHistoryData.pagination.hasMore,
        ),
      );
    });
  }

  List<CommentHistoryItemEntity> _mergeComments(
    List<CommentHistoryItemEntity> currentComments,
    List<CommentHistoryItemEntity> incomingComments,
  ) {
    final merged = <CommentHistoryItemEntity>[...currentComments];
    final ids = currentComments.map((e) => e.id).toSet();

    for (final comment in incomingComments) {
      if (ids.add(comment.id)) {
        merged.add(comment);
      }
    }

    return merged;
  }
}
