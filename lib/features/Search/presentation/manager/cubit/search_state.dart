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
  final List<PostEntity> posts;
  final List<UserEntity> users;
  final bool isInitialLoading;
  final bool isLoadingMorePosts;
  final bool isLoadingMoreUsers;
  final bool hasMorePosts;
  final bool hasMoreUsers;
  final int postsPage;
  final int usersPage;
  final String? errorMessage;

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
    this.posts = const [],
    this.users = const [],
    this.isInitialLoading = false,
    this.isLoadingMorePosts = false,
    this.isLoadingMoreUsers = false,
    this.hasMorePosts = false,
    this.hasMoreUsers = false,
    this.postsPage = 0,
    this.usersPage = 0,
    this.errorMessage,
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
    List<PostEntity>? posts,
    List<UserEntity>? users,
    bool? isInitialLoading,
    bool? isLoadingMorePosts,
    bool? isLoadingMoreUsers,
    bool? hasMorePosts,
    bool? hasMoreUsers,
    int? postsPage,
    int? usersPage,
    String? errorMessage,
    bool clearErrorMessage = false,
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
      posts: posts ?? this.posts,
      users: users ?? this.users,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMorePosts: isLoadingMorePosts ?? this.isLoadingMorePosts,
      isLoadingMoreUsers: isLoadingMoreUsers ?? this.isLoadingMoreUsers,
      hasMorePosts: hasMorePosts ?? this.hasMorePosts,
      hasMoreUsers: hasMoreUsers ?? this.hasMoreUsers,
      postsPage: postsPage ?? this.postsPage,
      usersPage: usersPage ?? this.usersPage,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    query,
    focusedOnAccountType,
    focusedOnServices,
    focusedOnLocation,
    selectedAccountType,
    selectedServices,
    selectedLocation,
    selectedTags,
    posts,
    users,
    isInitialLoading,
    isLoadingMorePosts,
    isLoadingMoreUsers,
    hasMorePosts,
    hasMoreUsers,
    postsPage,
    usersPage,
    errorMessage,
  ];
}
