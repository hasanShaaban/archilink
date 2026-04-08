part of 'universities_cubit.dart';

class UniversitiesState extends Equatable {
  const UniversitiesState({
    this.isLoading = false,
    this.hasLoaded = false,
    this.universities = const [],
    this.failure,
  });

  final bool isLoading;
  final bool hasLoaded;
  final List<UniversityEntity> universities;
  final Failure? failure;

  UniversitiesState copyWith({
    bool? isLoading,
    bool? hasLoaded,
    List<UniversityEntity>? universities,
    Failure? failure,
  }) {
    return UniversitiesState(
      isLoading: isLoading ?? this.isLoading,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      universities: universities ?? this.universities,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    hasLoaded,
    universities,
    failure,
  ];
}
