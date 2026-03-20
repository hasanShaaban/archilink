import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Post/domain/entity/posts_entity.dart';
import 'package:dartz/dartz.dart';

abstract class HomeRepo {
  Future<Either<Failure, PostsEntity>> getGlobalFeed({required int page});
}