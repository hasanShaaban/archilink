part of 'profile_cubit.dart';

sealed class ProfileCubitState extends Equatable {
  const ProfileCubitState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileCubitState {}
final class ProfileLoading extends ProfileCubitState {}
final class ProfileSuccess extends ProfileCubitState {
  final ProfileEntity profileData;

  const ProfileSuccess(this.profileData);
}
final class ProfileFailuer extends ProfileCubitState {
  final String errorMessage;

  const ProfileFailuer(this.errorMessage);
}
