part of 'follow_cubit.dart';

class FollowState extends Equatable {
  final bool isFollowing;
  final bool isSubmitting;
  final String? errorMessage;

  const FollowState({
    this.isFollowing = false,
    this.isSubmitting = false,
    this.errorMessage,
  });

  FollowState copyWith({
    bool? isFollowing,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return FollowState(
      isFollowing: isFollowing ?? this.isFollowing,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isFollowing, isSubmitting, errorMessage];
}
