part of 'profile_cubit.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}
final class ProfileLoading extends ProfileState {}
final class ProfileSuccess extends ProfileState {
  final UserProfileEntity profileData;

  const ProfileSuccess(this.profileData);
}
final class ProfileFailuer extends ProfileState {
  final String errorMessage;

  const ProfileFailuer(this.errorMessage);
}
