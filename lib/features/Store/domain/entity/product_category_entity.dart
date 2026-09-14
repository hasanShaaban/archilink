import 'package:equatable/equatable.dart';

class ProductCategoryEntity extends Equatable {
  final int id;
  final String name;
  final String slug;

  const ProductCategoryEntity({
    required this.id,
    required this.name,
    required this.slug,
  });

  @override
  List<Object?> get props => [id, name, slug];
}
