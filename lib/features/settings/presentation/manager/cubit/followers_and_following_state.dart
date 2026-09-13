import 'package:archilink/features/Search/domain/entity/user_entity.dart';
import 'package:archilink/features/settings/domain/entity/follow_request_entity.dart';
import 'package:equatable/equatable.dart';

class FollowersAndFollowingState extends Equatable {
  static const Object _noChange = Object();

  const FollowersAndFollowingState({
    this.followers = const <UserEntity>[],
    this.following = const <UserEntity>[],
    this.outgoingRequests = const <FollowRequestItemEntity>[],
    this.incomingRequests = const <FollowRequestItemEntity>[],
    this.followersPage = 0,
    this.followingPage = 0,
    this.outgoingRequestsPage = 0,
    this.incomingRequestsPage = 0,
    this.hasMoreFollowers = true,
    this.hasMoreFollowing = true,
    this.hasMoreOutgoingRequests = true,
    this.hasMoreIncomingRequests = true,
    this.isLoadingFollowers = false,
    this.isLoadingMoreFollowers = false,
    this.isLoadingFollowing = false,
    this.isLoadingMoreFollowing = false,
    this.isLoadingOutgoingRequests = false,
    this.isLoadingMoreOutgoingRequests = false,
    this.isLoadingIncomingRequests = false,
    this.isLoadingMoreIncomingRequests = false,
    this.followersErrorMessage,
    this.followingErrorMessage,
    this.outgoingRequestsErrorMessage,
    this.incomingRequestsErrorMessage,
  });

  final List<UserEntity> followers;
  final List<UserEntity> following;
  final List<FollowRequestItemEntity> outgoingRequests;
  final List<FollowRequestItemEntity> incomingRequests;
  final int followersPage;
  final int followingPage;
  final int outgoingRequestsPage;
  final int incomingRequestsPage;
  final bool hasMoreFollowers;
  final bool hasMoreFollowing;
  final bool hasMoreOutgoingRequests;
  final bool hasMoreIncomingRequests;
  final bool isLoadingFollowers;
  final bool isLoadingMoreFollowers;
  final bool isLoadingFollowing;
  final bool isLoadingMoreFollowing;
  final bool isLoadingOutgoingRequests;
  final bool isLoadingMoreOutgoingRequests;
  final bool isLoadingIncomingRequests;
  final bool isLoadingMoreIncomingRequests;
  final String? followersErrorMessage;
  final String? followingErrorMessage;
  final String? outgoingRequestsErrorMessage;
  final String? incomingRequestsErrorMessage;

  bool get hasFollowersData => followers.isNotEmpty;
  bool get hasFollowingData => following.isNotEmpty;
  bool get hasOutgoingRequestsData => outgoingRequests.isNotEmpty;
  bool get hasIncomingRequestsData => incomingRequests.isNotEmpty;

  FollowersAndFollowingState copyWith({
    List<UserEntity>? followers,
    List<UserEntity>? following,
    List<FollowRequestItemEntity>? outgoingRequests,
    List<FollowRequestItemEntity>? incomingRequests,
    int? followersPage,
    int? followingPage,
    int? outgoingRequestsPage,
    int? incomingRequestsPage,
    bool? hasMoreFollowers,
    bool? hasMoreFollowing,
    bool? hasMoreOutgoingRequests,
    bool? hasMoreIncomingRequests,
    bool? isLoadingFollowers,
    bool? isLoadingMoreFollowers,
    bool? isLoadingFollowing,
    bool? isLoadingMoreFollowing,
    bool? isLoadingOutgoingRequests,
    bool? isLoadingMoreOutgoingRequests,
    bool? isLoadingIncomingRequests,
    bool? isLoadingMoreIncomingRequests,
    Object? followersErrorMessage = _noChange,
    Object? followingErrorMessage = _noChange,
    Object? outgoingRequestsErrorMessage = _noChange,
    Object? incomingRequestsErrorMessage = _noChange,
  }) {
    return FollowersAndFollowingState(
      followers: followers ?? this.followers,
      following: following ?? this.following,
      outgoingRequests: outgoingRequests ?? this.outgoingRequests,
      incomingRequests: incomingRequests ?? this.incomingRequests,
      followersPage: followersPage ?? this.followersPage,
      followingPage: followingPage ?? this.followingPage,
      outgoingRequestsPage: outgoingRequestsPage ?? this.outgoingRequestsPage,
      incomingRequestsPage: incomingRequestsPage ?? this.incomingRequestsPage,
      hasMoreFollowers: hasMoreFollowers ?? this.hasMoreFollowers,
      hasMoreFollowing: hasMoreFollowing ?? this.hasMoreFollowing,
      hasMoreOutgoingRequests:
          hasMoreOutgoingRequests ?? this.hasMoreOutgoingRequests,
      hasMoreIncomingRequests:
          hasMoreIncomingRequests ?? this.hasMoreIncomingRequests,
      isLoadingFollowers: isLoadingFollowers ?? this.isLoadingFollowers,
      isLoadingMoreFollowers:
          isLoadingMoreFollowers ?? this.isLoadingMoreFollowers,
      isLoadingFollowing: isLoadingFollowing ?? this.isLoadingFollowing,
      isLoadingMoreFollowing:
          isLoadingMoreFollowing ?? this.isLoadingMoreFollowing,
      isLoadingOutgoingRequests:
          isLoadingOutgoingRequests ?? this.isLoadingOutgoingRequests,
      isLoadingMoreOutgoingRequests:
          isLoadingMoreOutgoingRequests ?? this.isLoadingMoreOutgoingRequests,
      isLoadingIncomingRequests:
          isLoadingIncomingRequests ?? this.isLoadingIncomingRequests,
      isLoadingMoreIncomingRequests:
          isLoadingMoreIncomingRequests ?? this.isLoadingMoreIncomingRequests,
      followersErrorMessage: followersErrorMessage == _noChange
          ? this.followersErrorMessage
          : followersErrorMessage as String?,
      followingErrorMessage: followingErrorMessage == _noChange
          ? this.followingErrorMessage
          : followingErrorMessage as String?,
      outgoingRequestsErrorMessage: outgoingRequestsErrorMessage == _noChange
          ? this.outgoingRequestsErrorMessage
          : outgoingRequestsErrorMessage as String?,
      incomingRequestsErrorMessage: incomingRequestsErrorMessage == _noChange
          ? this.incomingRequestsErrorMessage
          : incomingRequestsErrorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    followers,
    following,
    outgoingRequests,
    incomingRequests,
    followersPage,
    followingPage,
    outgoingRequestsPage,
    incomingRequestsPage,
    hasMoreFollowers,
    hasMoreFollowing,
    hasMoreOutgoingRequests,
    hasMoreIncomingRequests,
    isLoadingFollowers,
    isLoadingMoreFollowers,
    isLoadingFollowing,
    isLoadingMoreFollowing,
    isLoadingOutgoingRequests,
    isLoadingMoreOutgoingRequests,
    isLoadingIncomingRequests,
    isLoadingMoreIncomingRequests,
    followersErrorMessage,
    followingErrorMessage,
    outgoingRequestsErrorMessage,
    incomingRequestsErrorMessage,
  ];
}

final class FollowersAndFollowingInitial extends FollowersAndFollowingState {
  const FollowersAndFollowingInitial();
}
