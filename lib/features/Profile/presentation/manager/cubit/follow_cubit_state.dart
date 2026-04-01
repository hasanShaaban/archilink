part of 'follow_cubit.dart';

class FollowState extends Equatable {
  final bool isFollowing;
  final bool isSubmitting;
  final String? errorMessage;
  final bool isInitialized;

  const FollowState({
    this.isFollowing = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.isInitialized = false,
  });

  FollowState copyWith({
    bool? isFollowing,
    bool? isSubmitting,
    String? errorMessage,
    bool? isInitialized,
  }) {
    return FollowState(
      isFollowing: isFollowing ?? this.isFollowing,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  @override
  List<Object?> get props => [
        isFollowing,
        isSubmitting,
        errorMessage,
        isInitialized,
      ];
}
