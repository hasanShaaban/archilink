import 'package:equatable/equatable.dart';

class ProductCategoryEntity extends Equatable {
  final int id;
  final String name;
  final String slug;
  final int productsCount;
  final String? description;
  final bool isActive;

  const ProductCategoryEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.productsCount = 0,
    this.description,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    productsCount,
    description,
    isActive,
  ];
}
