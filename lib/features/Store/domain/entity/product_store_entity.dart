import 'package:equatable/equatable.dart';

class ProductStoreEntity extends Equatable {
  final int id;
  final String name;
  final String username;
  final String? role;
  final bool? isVerified;
  final String? avatar;
  final String? country;
  final String? city;

  const ProductStoreEntity({
    required this.id,
    required this.name,
    required this.username,
    this.role,
    this.isVerified,
    this.avatar,
    this.country,
    this.city,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    username,
    role,
    isVerified,
    avatar,
    country,
    city,
  ];
}
