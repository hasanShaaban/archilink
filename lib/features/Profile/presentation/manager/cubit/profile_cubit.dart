import 'package:archilink/features/Profile/domain/entity/user_profile_entity.dart';
import 'package:archilink/features/Profile/domain/repo/profile_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  ProfileCubit(this.profileRepo) : super(ProfileInitial());

  Future<void> getProfile({required String username}) async{
    emit(ProfileLoading());
    final result = await profileRepo.getProfile(username: username);

    result.fold(
      (failuer) => emit(ProfileFailuer(failuer.message)),
      (data) => emit(ProfileSuccess(data)));
  }
}
