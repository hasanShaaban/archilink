import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/current_user_cubit.dart';
import 'package:archilink/features/Search/domain/entity/user_entity.dart';
import 'package:archilink/features/settings/domain/repo/setting_repo.dart';
import 'package:bloc/bloc.dart';

import 'followers_and_following_state.dart';

class FollowersAndFollowingCubit extends Cubit<FollowersAndFollowingState> {
  FollowersAndFollowingCubit(this._settingRepo, this._currentUserCubit)
    : super(const FollowersAndFollowingInitial());

  final SettingRepo _settingRepo;
  final CurrentUserCubit _currentUserCubit;

  Future<void> fetchFollowers({bool refresh = false}) async {
    if (state.isLoadingFollowers || state.isLoadingMoreFollowers) return;

    if (!refresh && state.followersPage > 0 && !state.hasMoreFollowers) return;

    final username = _resolveUsername();
    if (username == null) {
      emit(state.copyWith(followersErrorMessage: _missingUsernameMessage));
      return;
    }

    final nextPage = refresh ? 1 : (state.followersPage + 1);
    final isFirstPage = nextPage == 1;
    emit(
      state.copyWith(
        isLoadingFollowers: isFirstPage,
        isLoadingMoreFollowers: !isFirstPage,
        followersErrorMessage: null,
      ),
    );

    final result = await _settingRepo.getFollowers(username: username, page: nextPage);
    if (isClosed) return;

    result.fold((failure) {
      emit(
        state.copyWith(
          isLoadingFollowers: false,
          isLoadingMoreFollowers: false,
          followersErrorMessage: failure.message,
        ),
      );
    }, (followersData) {
      final users = isFirstPage
          ? followersData.users
          : _mergeUsers(state.followers, followersData.users);
      emit(
        state.copyWith(
          isLoadingFollowers: false,
          isLoadingMoreFollowers: false,
          followersErrorMessage: null,
          followers: users,
          followersPage: followersData.pagination.currentPage,
          hasMoreFollowers: followersData.pagination.hasMore,
        ),
      );
    });
  }

  Future<void> fetchFollowing({bool refresh = false}) async {
    if (state.isLoadingFollowing || state.isLoadingMoreFollowing) return;

    if (!refresh && state.followingPage > 0 && !state.hasMoreFollowing) return;

    final username = _resolveUsername();
    if (username == null) {
      emit(state.copyWith(followingErrorMessage: _missingUsernameMessage));
      return;
    }

    final nextPage = refresh ? 1 : (state.followingPage + 1);
    final isFirstPage = nextPage == 1;
    emit(
      state.copyWith(
        isLoadingFollowing: isFirstPage,
        isLoadingMoreFollowing: !isFirstPage,
        followingErrorMessage: null,
      ),
    );

    final result = await _settingRepo.getFollowing(username: username, page: nextPage);
    if (isClosed) return;

    result.fold((failure) {
      emit(
        state.copyWith(
          isLoadingFollowing: false,
          isLoadingMoreFollowing: false,
          followingErrorMessage: failure.message,
        ),
      );
    }, (followingData) {
      final users = isFirstPage
          ? followingData.users
          : _mergeUsers(state.following, followingData.users);
      emit(
        state.copyWith(
          isLoadingFollowing: false,
          isLoadingMoreFollowing: false,
          followingErrorMessage: null,
          following: users,
          followingPage: followingData.pagination.currentPage,
          hasMoreFollowing: followingData.pagination.hasMore,
        ),
      );
    });
  }

  String? _resolveUsername() {
    final username = _currentUserCubit.state.username;
    if (username == null || username.isEmpty) return null;
    return username;
  }

  List<UserEntity> _mergeUsers(
    List<UserEntity> currentUsers,
    List<UserEntity> incomingUsers,
  ) {
    final merged = <UserEntity>[...currentUsers];
    final ids = currentUsers.map((e) => e.id).toSet();
    for (final user in incomingUsers) {
      if (ids.add(user.id)) {
        merged.add(user);
      }
    }
    return merged;
  }

  static const String _missingUsernameMessage =
      'Missing username, please login again.';
}
