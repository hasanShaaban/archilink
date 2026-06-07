import 'package:archilink/features/settings/domain/entity/user_collection_entity.dart';
import 'package:equatable/equatable.dart';

class UserCollectionsState extends Equatable {
  static const Object _noChange = Object();

  const UserCollectionsState({
    this.collections = const <UserCollectionEntity>[],
    this.isLoadingCollections = false,
    this.collectionsErrorMessage,
  });

  final List<UserCollectionEntity> collections;
  final bool isLoadingCollections;
  final String? collectionsErrorMessage;

  bool get hasCollectionsData => collections.isNotEmpty;

  UserCollectionsState copyWith({
    List<UserCollectionEntity>? collections,
    bool? isLoadingCollections,
    Object? collectionsErrorMessage = _noChange,
  }) {
    return UserCollectionsState(
      collections: collections ?? this.collections,
      isLoadingCollections: isLoadingCollections ?? this.isLoadingCollections,
      collectionsErrorMessage: collectionsErrorMessage == _noChange
          ? this.collectionsErrorMessage
          : collectionsErrorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
        collections,
        isLoadingCollections,
        collectionsErrorMessage,
      ];
}

final class UserCollectionsInitial extends UserCollectionsState {
  const UserCollectionsInitial();
}
