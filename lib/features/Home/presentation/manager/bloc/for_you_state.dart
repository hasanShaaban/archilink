part of 'for_you_bloc.dart';

class ForYouState extends Equatable{
  final List<FeedItem> items;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final Failure? failure;
  final int currentPage;

  const ForYouState({
    this.items = const [],
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.failure,
    this.currentPage = 1,
  });

  ForYouState copyWith({
    List<FeedItem>? items,
    bool? isInitialLoading,
    bool? isLoadingMore,
    bool? hasReachedMax,
    Failure? failure,
    int? currentPage,
  }){
    return ForYouState(
      items: items ?? this.items,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      failure: failure,
      currentPage: currentPage ?? this.currentPage
    );
  }
  
  @override
  List<Object?> get props =>[
    items,
    isInitialLoading,
    isLoadingMore,
    hasReachedMax,
    failure,
    currentPage
  ];
}
