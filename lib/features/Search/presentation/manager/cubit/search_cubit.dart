import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Search/domain/entity/user_entity.dart';
import 'package:archilink/features/Search/domain/repo/search_repo.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._searchRepo) : super(const SearchState());

  final SearchRepo _searchRepo;

  void toggleAccountTypeFocus() {
    final shouldFocus = !state.focusedOnAccountType;
    emit(
      state.copyWith(
        focusedOnAccountType: shouldFocus,
        focusedOnServices: false,
        focusedOnLocation: false,
      ),
    );
  }

  void toggleServicesFocus() {
    final shouldFocus = !state.focusedOnServices;
    emit(
      state.copyWith(
        focusedOnServices: shouldFocus,
        focusedOnAccountType: false,
        focusedOnLocation: false,
      ),
    );
  }

  void toggleLocationFocus() {
    final shouldFocus = !state.focusedOnLocation;
    emit(
      state.copyWith(
        focusedOnLocation: shouldFocus,
        focusedOnAccountType: false,
        focusedOnServices: false,
      ),
    );
  }

  void selectAccountType(String accountType) {
    if (!SearchState.accountTypeOptions.contains(accountType)) return;
    final nextSelection = state.selectedAccountType == accountType
        ? ''
        : accountType;
    emit(state.copyWith(selectedAccountType: nextSelection));
  }

  void selectLocation(String location) {
    if (!SearchState.locationOptions.contains(location)) return;
    final nextSelection = state.selectedLocation == location ? '' : location;
    emit(state.copyWith(selectedLocation: nextSelection));
  }

  void toggleServiceSelection(String service) {
    if (!SearchState.serviceOptions.contains(service)) return;
    final updated = List<String>.from(state.selectedServices);
    if (updated.contains(service)) {
      updated.remove(service);
    } else {
      updated.add(service);
    }
    emit(state.copyWith(selectedServices: updated));
  }

  void toggleTagSelection(String tag) {
    if (!SearchState.suggestedTags.contains(tag)) return;
    final updated = List<String>.from(state.selectedTags);
    if (updated.contains(tag)) {
      updated.remove(tag);
    } else {
      updated.add(tag);
    }
    emit(state.copyWith(selectedTags: updated));
  }

  void updateQuery(String query) {
    emit(state.copyWith(query: query));
  }

  void clearQuery() {
    emit(state.copyWith(query: ''));
  }

  Future<void> fetchSearchResults() async {
    if (state.isInitialLoading) return;
    emit(
      state.copyWith(
        isInitialLoading: true,
        posts: const [],
        users: const [],
        postsPage: 0,
        usersPage: 0,
        hasMorePosts: false,
        hasMoreUsers: false,
        clearErrorMessage: true,
      ),
    );

    final location = _splitLocation(state.selectedLocation);
    final result = await _searchRepo.searchResult(
      q: state.query.trim(),
      postsPage: 1,
      usersPage: 1,
      accountType: _mapAccountType(state.selectedAccountType),
      city: location.$1,
      country: location.$2,
      services: state.selectedServices.isEmpty ? null : state.selectedServices,
      tags: state.selectedTags.isEmpty ? null : state.selectedTags,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(isInitialLoading: false, errorMessage: failure.message),
      ),
      (data) => emit(
        state.copyWith(
          isInitialLoading: false,
          posts: data.posts,
          users: data.users,
          postsPage: data.postsPagination.currentPage,
          usersPage: data.usersPagination.currentPage,
          hasMorePosts: data.postsPagination.hasMore,
          hasMoreUsers: data.usersPagination.hasMore,
          clearErrorMessage: true,
        ),
      ),
    );
  }

  Future<void> loadMorePosts() async {
    if (state.isInitialLoading || state.isLoadingMorePosts || !state.hasMorePosts) {
      return;
    }
    final nextPostsPage = state.postsPage + 1;
    emit(state.copyWith(isLoadingMorePosts: true));

    final location = _splitLocation(state.selectedLocation);
    final result = await _searchRepo.searchResult(
      q: state.query.trim(),
      postsPage: nextPostsPage,
      usersPage: state.usersPage == 0 ? 1 : state.usersPage,
      accountType: _mapAccountType(state.selectedAccountType),
      city: location.$1,
      country: location.$2,
      services: state.selectedServices.isEmpty ? null : state.selectedServices,
      tags: state.selectedTags.isEmpty ? null : state.selectedTags,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoadingMorePosts: false,
          errorMessage: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          isLoadingMorePosts: false,
          posts: _mergePosts(state.posts, data.posts),
          postsPage: data.postsPagination.currentPage,
          hasMorePosts: data.postsPagination.hasMore,
          clearErrorMessage: true,
        ),
      ),
    );
  }

  Future<void> loadMoreUsers() async {
    if (state.isInitialLoading || state.isLoadingMoreUsers || !state.hasMoreUsers) {
      return;
    }
    final nextUsersPage = state.usersPage + 1;
    emit(state.copyWith(isLoadingMoreUsers: true));

    final location = _splitLocation(state.selectedLocation);
    final result = await _searchRepo.searchResult(
      q: state.query.trim(),
      postsPage: state.postsPage == 0 ? 1 : state.postsPage,
      usersPage: nextUsersPage,
      accountType: _mapAccountType(state.selectedAccountType),
      city: location.$1,
      country: location.$2,
      services: state.selectedServices.isEmpty ? null : state.selectedServices,
      tags: state.selectedTags.isEmpty ? null : state.selectedTags,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoadingMoreUsers: false,
          errorMessage: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          isLoadingMoreUsers: false,
          users: _mergeUsers(state.users, data.users),
          usersPage: data.usersPagination.currentPage,
          hasMoreUsers: data.usersPagination.hasMore,
          clearErrorMessage: true,
        ),
      ),
    );
  }

  String? _mapAccountType(String selectedAccountType) {
    switch (selectedAccountType) {
      case SearchState.studentAccountType:
        return 'student';
      case SearchState.mentorAccountType:
        return 'mentor';
      case SearchState.storeAccountTypes:
        return 'store';
      default:
        return null;
    }
  }

  (String?, String?) _splitLocation(String location) {
    if (location.trim().isEmpty) return (null, null);
    final parts = location.split(',').map((e) => e.trim()).toList();
    if (parts.length < 2) return (parts.first, null);
    return (parts.first, parts.sublist(1).join(', '));
  }

  List<PostEntity> _mergePosts(List<PostEntity> current, List<PostEntity> incoming) {
    final byId = {for (final post in current) post.id: post};
    for (final post in incoming) {
      byId[post.id] = post;
    }
    return byId.values.toList();
  }

  List<UserEntity> _mergeUsers(List<UserEntity> current, List<UserEntity> incoming) {
    final byId = {for (final user in current) user.id: user};
    for (final user in incoming) {
      byId[user.id] = user;
    }
    return byId.values.toList();
  }
}
