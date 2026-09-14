import 'package:archilink/features/Store/domain/entity/product_entity.dart';
import 'package:equatable/equatable.dart';

class StoreFeedState extends Equatable {
  static const Object _noChange = Object();

  const StoreFeedState({
    this.products = const <ProductEntity>[],
    this.currentPage = 0,
    this.hasMore = true,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  final List<ProductEntity> products;
  final int currentPage;
  final bool hasMore;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;

  bool get hasProducts => products.isNotEmpty;

  StoreFeedState copyWith({
    List<ProductEntity>? products,
    int? currentPage,
    bool? hasMore,
    bool? isLoading,
    bool? isLoadingMore,
    Object? errorMessage = _noChange,
  }) {
    return StoreFeedState(
      products: products ?? this.products,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage == _noChange
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    products,
    currentPage,
    hasMore,
    isLoading,
    isLoadingMore,
    errorMessage,
  ];
}

final class StoreFeedInitial extends StoreFeedState {
  const StoreFeedInitial();
}
