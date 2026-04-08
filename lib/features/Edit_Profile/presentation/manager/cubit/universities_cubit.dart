import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Edit_Profile/domain/entity/university_entity.dart';
import 'package:archilink/features/Edit_Profile/domain/repo/edit_profile_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'universities_state.dart';

class UniversitiesCubit extends Cubit<UniversitiesState> {
  UniversitiesCubit(this.repo) : super(const UniversitiesState());

  final EditProfileRepo repo;

  Future<void> loadUniversities({bool force = false}) async {
    if (state.isLoading) return;
    if (!force && state.hasLoaded) return;

    emit(state.copyWith(isLoading: true, failure: null));

    final result = await repo.getUniversities();
    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, failure: failure, hasLoaded: false),
      ),
      (response) => emit(
        state.copyWith(
          isLoading: false,
          failure: null,
          universities: response.universities,
          hasLoaded: true,
        ),
      ),
    );
  }
}
