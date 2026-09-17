import 'package:equatable/equatable.dart';

class AddProductParams extends Equatable {
  final String name;
  final String? description;
  final double price;
  final List<int> categoryIds;
  final int? quantityInStock;
  final String? status;
  final List<String> imagePaths;

  const AddProductParams({
    required this.name,
    this.description,
    required this.price,
    this.categoryIds = const [],
    this.quantityInStock,
    this.status,
    this.imagePaths = const [],
  });

  @override
  List<Object?> get props => [
    name,
    description,
    price,
    categoryIds,
    quantityInStock,
    status,
    imagePaths,
  ];
}
