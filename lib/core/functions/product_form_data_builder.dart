import 'dart:io';

import 'package:archilink/features/Store/domain/entity/add_product_params.dart';
import 'package:archilink/features/Store/domain/entity/edit_product_params.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

Future<FormData> buildProductFormData(AddProductParams params) async {
  final mediaFiles = <MultipartFile>[];

  // Up to 5 images allowed
  final cappedImages = params.imagePaths.take(5);
  for (final path in cappedImages) {
    final file = File(path);
    if (!await file.exists()) continue;

    final mime = lookupMimeType(file.path)?.split('/') ?? ['image', 'jpeg'];
    final filename = file.path.split(RegExp(r'[\\/]')).last;

    mediaFiles.add(
      await MultipartFile.fromFile(
        file.path,
        filename: filename,
        contentType: MediaType(mime[0], mime[1]),
      ),
    );
  }

  final map = <String, dynamic>{
    'name': params.name,
    'price': params.price,
  };

  if (params.description != null && params.description!.trim().isNotEmpty) {
    map['description'] = params.description!.trim();
  }

  if (params.quantityInStock != null) {
    map['quantity_in_stock'] = params.quantityInStock;
  }

  if (params.status != null && params.status!.trim().isNotEmpty) {
    map['status'] = params.status!.trim();
  }

  if (params.categoryIds.isNotEmpty) {
    map['categories[]'] = params.categoryIds;
    map['category_ids[]'] = params.categoryIds;
  }

  if (mediaFiles.isNotEmpty) {
    map['media[]'] = mediaFiles;
  }

  return FormData.fromMap(map);
}

Future<dynamic> buildEditProductData(EditProductParams params) async {
  final mediaFiles = <MultipartFile>[];

  if (params.imagePaths != null && params.imagePaths!.isNotEmpty) {
    final cappedImages = params.imagePaths!.take(5);
    for (final path in cappedImages) {
      final file = File(path);
      if (!await file.exists()) continue;

      final mime = lookupMimeType(file.path)?.split('/') ?? ['image', 'jpeg'];
      final filename = file.path.split(RegExp(r'[\\/]')).last;

      mediaFiles.add(
        await MultipartFile.fromFile(
          file.path,
          filename: filename,
          contentType: MediaType(mime[0], mime[1]),
        ),
      );
    }
  }

  final map = <String, dynamic>{};

  if (params.name != null && params.name!.trim().isNotEmpty) {
    map['name'] = params.name!.trim();
  }

  if (params.price != null) {
    map['price'] = params.price;
  }

  if (params.description != null && params.description!.trim().isNotEmpty) {
    map['description'] = params.description!.trim();
  }

  if (params.quantityInStock != null) {
    map['quantity_in_stock'] = params.quantityInStock;
  }

  if (params.status != null && params.status!.trim().isNotEmpty) {
    map['status'] = params.status!.trim();
  }

  if (params.categoryIds != null && params.categoryIds!.isNotEmpty) {
    map['categories[]'] = params.categoryIds;
    map['category_ids[]'] = params.categoryIds;
    map['categories'] = params.categoryIds;
    map['category_ids'] = params.categoryIds;
  }

  if (mediaFiles.isNotEmpty) {
    map['media[]'] = mediaFiles;
    return FormData.fromMap(map);
  }

  return map;
}
