import 'package:archilink/features/Profile/domain/repo/profile_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'follow_cubit_state.dart';

class FollowCubit extends Cubit<FollowState> {
  final ProfileRepo profileRepo;
  FollowCubit(this.profileRepo) : super(const FollowState());

  void _safeEmit(FollowState nextState) {
    if (isClosed) return;
    emit(nextState);
  }

  void setInitial({
    required bool isFollowing,
    bool force = false,
  }) {
    if (isClosed || (state.isInitialized && !force)) return;
    _safeEmit(
      state.copyWith(
        isFollowing: isFollowing,
        isInitialized: true,
        errorMessage: null,
      ),
    );
  }

  Future<void> follow(String username) async {
    if (isClosed || state.isSubmitting) return;
    // Optimistic UI: show followed state immediately.
    _safeEmit(
      state.copyWith(
        isFollowing: true,
        isSubmitting: true,
        errorMessage: null,
      ),
    );
    final result = await profileRepo.follow(username);
    if (isClosed) return;
    result.fold(
      (failure) => _safeEmit(
        state.copyWith(
          isFollowing: false,
          isSubmitting: false,
          errorMessage: failure.message,
        ),
      ),
      (success) => _safeEmit(
        state.copyWith(
          isFollowing: success,
          isSubmitting: false,
          errorMessage: null,
        ),
      ),
    );
  }
  Future<void> unfollow(String username) async {
    if (isClosed || state.isSubmitting) return;
    // Optimistic UI: show followed state immediately.
    _safeEmit(
      state.copyWith(
        isFollowing: false,
        isSubmitting: true,
        errorMessage: null,
      ),
    );
    final result = await profileRepo.unfollow(username);
    if (isClosed) return;
    result.fold(
      (failure) => _safeEmit(
        state.copyWith(
          isFollowing: true,
          isSubmitting: false,
          errorMessage: failure.message,
        ),
      ),
      (success) => _safeEmit(
        state.copyWith(
          isFollowing: !success,
          isSubmitting: false,
          errorMessage: null,
        ),
      ),
    );
  }
}
