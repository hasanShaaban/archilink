
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:archilink/features/Profile/domain/repo/profile_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_cubit_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  ProfileCubit(this.profileRepo) : super(ProfileInitial());

  Future<void> getPersonlProfile() async{
    emit(ProfileLoading());
    final result = await profileRepo.getPersonalProfile();

    result.fold(
      (failuer) => emit(ProfileFailuer(failuer.message)),
      (data) => emit(ProfileSuccess(data)));
  }

  Future<void> getUserProfile(String username)async{
    emit(ProfileLoading());
    final result = await profileRepo.getUserProfile(username: username);

    result.fold(
      (failure) =>  emit(ProfileFailuer(failure.message)),
      (data) => emit(ProfileSuccess(data)));
  }
}
