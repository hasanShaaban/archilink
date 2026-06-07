part of 'follow_cubit.dart';

class FollowState extends Equatable {
  final bool isFollowing;
  final bool isSubmitting;
  final String? errorMessage;
  final bool isInitialized;
  final FollowStatus? followStatus;

  const FollowState({
    this.isFollowing = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.isInitialized = false,
    this.followStatus,
  });

  FollowState copyWith({
    bool? isFollowing,
    bool? isSubmitting,
    String? errorMessage,
    bool? isInitialized,
    FollowStatus? followStatus,
    bool clearFollowStatus = false,
  }) {
    return FollowState(
      isFollowing: isFollowing ?? this.isFollowing,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      isInitialized: isInitialized ?? this.isInitialized,
      followStatus: clearFollowStatus ? null : (followStatus ?? this.followStatus),
    );
  }

  @override
  List<Object?> get props => [
    isFollowing,
    isSubmitting,
    errorMessage,
    isInitialized,
    followStatus,
  ];
}
