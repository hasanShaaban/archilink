part of 'search_cubit.dart';

class SearchState extends Equatable {
  final String query;
  final bool focusedOnAccountType;
  final bool focusedOnServices;
  final bool focusedOnLocation;
  final String selectedAccountType;
  final List<String> selectedServices;
  final String selectedLocation;
  final List<String> selectedTags;

  static const String storeAccountTypes = 'Store Account';
  static const String studentAccountType = 'Student Account';
  static const String mentorAccountType = 'Mentor Account';
  static const List<String> accountTypeOptions = [
    studentAccountType,
    mentorAccountType,
    storeAccountTypes,
  ];
  static const List<String> serviceOptions = [
    'interior design',
    'exterior design',
    'Web Development',
    '3D Modeling',
    'Digital Marketing',
    'Content Creation',
  ];

  static const List<String> locationOptions = [
    'Homs,Syria',
    'Damascus,Syria',
    'Aleppo,Syria',
    'Tartous,Syria',
    'Latakia,Syria',
    'Hama,Syria',
  ];
  static const List<String> suggestedTags = [
    'Modern',
    'Minimal',
    'Landscape',
    'Interior',
    'Sustainable',
    'Residential',
    'Commercial',
    '3D',
  ];

  const SearchState({
    this.query = '',
    this.focusedOnAccountType = false,
    this.focusedOnServices = false,
    this.focusedOnLocation = false,
    this.selectedAccountType = '',
    this.selectedLocation = '',
    this.selectedServices = const [],
    this.selectedTags = const [],
  });

  bool get hasActiveFilters =>
      query.trim().isNotEmpty ||
      selectedAccountType.trim().isNotEmpty ||
      selectedServices.isNotEmpty ||
      selectedLocation.trim().isNotEmpty ||
      selectedTags.isNotEmpty;

  String get selectedServicesSummary {
    if (selectedServices.isEmpty) return '';
    final firstTwo = selectedServices.take(2).join(', ');
    return selectedServices.length > 2 ? '$firstTwo...' : firstTwo;
  }

  bool get hasFocusedFilter =>
      focusedOnAccountType || focusedOnServices || focusedOnLocation;

  SearchState copyWith({
    String? query,
    bool? focusedOnAccountType,
    bool? focusedOnServices,
    bool? focusedOnLocation,
    String? selectedAccountType,
    List<String>? selectedServices,
    String? selectedLocation,
    List<String>? selectedTags,
  }) {
    return SearchState(
      query: query ?? this.query,
      focusedOnAccountType: focusedOnAccountType ?? this.focusedOnAccountType,
      focusedOnServices: focusedOnServices ?? this.focusedOnServices,
      focusedOnLocation: focusedOnLocation ?? this.focusedOnLocation,
      selectedAccountType: selectedAccountType ?? this.selectedAccountType,
      selectedServices: selectedServices ?? this.selectedServices,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      selectedTags: selectedTags ?? this.selectedTags,
    );
  }

  @override
  List<Object> get props => [
    query,
    focusedOnAccountType,
    focusedOnServices,
    focusedOnLocation,
    selectedAccountType,
    selectedServices,
    selectedLocation,
    selectedTags,
  ];
}
