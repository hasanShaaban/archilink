import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Home/domain/entity/global_feed_entity.dart';
import 'package:dartz/dartz.dart';

abstract class HomeRepo {
  Future<Either<Failure, GlobalFeedEntity>> getGlobalFeed({required int page});
}