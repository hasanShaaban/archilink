import 'package:equatable/equatable.dart';

class EditProductParams extends Equatable {
  final int id;
  final String? name;
  final String? description;
  final double? price;
  final List<int>? categoryIds;
  final int? quantityInStock;
  final String? status;
  final List<String>? imagePaths;

  const EditProductParams({
    required this.id,
    this.name,
    this.description,
    this.price,
    this.categoryIds,
    this.quantityInStock,
    this.status,
    this.imagePaths,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    categoryIds,
    quantityInStock,
    status,
    imagePaths,
  ];
}
