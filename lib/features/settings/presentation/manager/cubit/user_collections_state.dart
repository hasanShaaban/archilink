import 'package:archilink/features/settings/domain/entity/user_collection_entity.dart';
import 'package:equatable/equatable.dart';

class UserCollectionsState extends Equatable {
  static const Object _noChange = Object();

  const UserCollectionsState({
    this.collections = const <UserCollectionEntity>[],
    this.isLoadingCollections = false,
    this.collectionsErrorMessage,
    this.isCreatingCollection = false,
    this.createCollectionErrorMessage,
    this.isEditingCollection = false,
    this.editCollectionErrorMessage,
  });

  final List<UserCollectionEntity> collections;
  final bool isLoadingCollections;
  final String? collectionsErrorMessage;
  final bool isCreatingCollection;
  final String? createCollectionErrorMessage;
  final bool isEditingCollection;
  final String? editCollectionErrorMessage;

  bool get hasCollectionsData => collections.isNotEmpty;

  UserCollectionEntity? get defaultCollection {
    try {
      return collections.firstWhere((c) => c.isDefault);
    } catch (_) {
      return collections.isNotEmpty ? collections.first : null;
    }
  }

  UserCollectionsState copyWith({
    List<UserCollectionEntity>? collections,
    bool? isLoadingCollections,
    Object? collectionsErrorMessage = _noChange,
    bool? isCreatingCollection,
    Object? createCollectionErrorMessage = _noChange,
    bool? isEditingCollection,
    Object? editCollectionErrorMessage = _noChange,
  }) {
    return UserCollectionsState(
      collections: collections ?? this.collections,
      isLoadingCollections: isLoadingCollections ?? this.isLoadingCollections,
      collectionsErrorMessage: collectionsErrorMessage == _noChange
          ? this.collectionsErrorMessage
          : collectionsErrorMessage as String?,
      isCreatingCollection: isCreatingCollection ?? this.isCreatingCollection,
      createCollectionErrorMessage: createCollectionErrorMessage == _noChange
          ? this.createCollectionErrorMessage
          : createCollectionErrorMessage as String?,
      isEditingCollection: isEditingCollection ?? this.isEditingCollection,
      editCollectionErrorMessage: editCollectionErrorMessage == _noChange
          ? this.editCollectionErrorMessage
          : editCollectionErrorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
        collections,
        isLoadingCollections,
        collectionsErrorMessage,
        isCreatingCollection,
        createCollectionErrorMessage,
        isEditingCollection,
        editCollectionErrorMessage,
      ];
}

final class UserCollectionsInitial extends UserCollectionsState {
  const UserCollectionsInitial();
}
