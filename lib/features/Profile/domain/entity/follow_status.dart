enum FollowStatus {
  /// The target user has a public profile; follow was accepted immediately.
  followed,

  /// The target user has a private profile; a follow request was sent.
  requested,
}
