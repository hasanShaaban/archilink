import 'package:archilink/features/Profile/domain/repo/profile_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'follow_cubit_state.dart';

class FollowCubit extends Cubit<FollowState> {
  final ProfileRepo profileRepo;
  FollowCubit(this.profileRepo) : super(const FollowState());

  Future<void> follow(String username) async {
    if (state.isSubmitting) return;
    // Optimistic UI: show followed state immediately.
    emit(state.copyWith(isFollowing: true, isSubmitting: true, errorMessage: null));
    final result = await profileRepo.follow(username);
    result.fold(
      (failure) => emit(
        state.copyWith(
          isFollowing: false,
          isSubmitting: false,
          errorMessage: failure.message,
        ),
      ),
      (success) => emit(
        state.copyWith(
          isFollowing: success,
          isSubmitting: false,
          errorMessage: null,
        ),
      ),
    );
  }
}
