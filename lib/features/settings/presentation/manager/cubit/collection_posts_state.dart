import 'package:archilink/features/settings/domain/entity/collection_posts_entity.dart';
import 'package:equatable/equatable.dart';

class CollectionPostsState extends Equatable {
  static const Object _noChange = Object();

  final List<CollectionItemEntity> items;
  final bool isLoading;
  final String? errorMessage;
  final int? currentCollectionId;

  const CollectionPostsState({
    this.items = const <CollectionItemEntity>[],
    this.isLoading = false,
    this.errorMessage,
    this.currentCollectionId,
  });

  bool get hasData => items.isNotEmpty;

  CollectionPostsState copyWith({
    List<CollectionItemEntity>? items,
    bool? isLoading,
    Object? errorMessage = _noChange,
    Object? currentCollectionId = _noChange,
  }) {
    return CollectionPostsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage == _noChange
          ? this.errorMessage
          : errorMessage as String?,
      currentCollectionId: currentCollectionId == _noChange
          ? this.currentCollectionId
          : currentCollectionId as int?,
    );
  }

  @override
  List<Object?> get props => [
        items,
        isLoading,
        errorMessage,
        currentCollectionId,
      ];
}

final class CollectionPostsInitial extends CollectionPostsState {
  const CollectionPostsInitial();
}
