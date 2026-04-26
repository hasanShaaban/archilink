import 'package:archilink/features/Search/domain/entity/user_entity.dart';
import 'package:equatable/equatable.dart';

class FollowersAndFollowingState extends Equatable {
  static const Object _noChange = Object();

  const FollowersAndFollowingState({
    this.followers = const <UserEntity>[],
    this.following = const <UserEntity>[],
    this.followersPage = 0,
    this.followingPage = 0,
    this.hasMoreFollowers = true,
    this.hasMoreFollowing = true,
    this.isLoadingFollowers = false,
    this.isLoadingMoreFollowers = false,
    this.isLoadingFollowing = false,
    this.isLoadingMoreFollowing = false,
    this.followersErrorMessage,
    this.followingErrorMessage,
  });

  final List<UserEntity> followers;
  final List<UserEntity> following;
  final int followersPage;
  final int followingPage;
  final bool hasMoreFollowers;
  final bool hasMoreFollowing;
  final bool isLoadingFollowers;
  final bool isLoadingMoreFollowers;
  final bool isLoadingFollowing;
  final bool isLoadingMoreFollowing;
  final String? followersErrorMessage;
  final String? followingErrorMessage;

  bool get hasFollowersData => followers.isNotEmpty;
  bool get hasFollowingData => following.isNotEmpty;

  FollowersAndFollowingState copyWith({
    List<UserEntity>? followers,
    List<UserEntity>? following,
    int? followersPage,
    int? followingPage,
    bool? hasMoreFollowers,
    bool? hasMoreFollowing,
    bool? isLoadingFollowers,
    bool? isLoadingMoreFollowers,
    bool? isLoadingFollowing,
    bool? isLoadingMoreFollowing,
    Object? followersErrorMessage = _noChange,
    Object? followingErrorMessage = _noChange,
  }) {
    return FollowersAndFollowingState(
      followers: followers ?? this.followers,
      following: following ?? this.following,
      followersPage: followersPage ?? this.followersPage,
      followingPage: followingPage ?? this.followingPage,
      hasMoreFollowers: hasMoreFollowers ?? this.hasMoreFollowers,
      hasMoreFollowing: hasMoreFollowing ?? this.hasMoreFollowing,
      isLoadingFollowers: isLoadingFollowers ?? this.isLoadingFollowers,
      isLoadingMoreFollowers:
          isLoadingMoreFollowers ?? this.isLoadingMoreFollowers,
      isLoadingFollowing: isLoadingFollowing ?? this.isLoadingFollowing,
      isLoadingMoreFollowing:
          isLoadingMoreFollowing ?? this.isLoadingMoreFollowing,
      followersErrorMessage: followersErrorMessage == _noChange
          ? this.followersErrorMessage
          : followersErrorMessage as String?,
      followingErrorMessage: followingErrorMessage == _noChange
          ? this.followingErrorMessage
          : followingErrorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    followers,
    following,
    followersPage,
    followingPage,
    hasMoreFollowers,
    hasMoreFollowing,
    isLoadingFollowers,
    isLoadingMoreFollowers,
    isLoadingFollowing,
    isLoadingMoreFollowing,
    followersErrorMessage,
    followingErrorMessage,
  ];
}

final class FollowersAndFollowingInitial extends FollowersAndFollowingState {
  const FollowersAndFollowingInitial();
}
