import 'package:archilink/features/Home/data/model/global_feed_model.dart';

abstract class HomeRemoteDataSource {
  Future<GlobalFeedModel> getGlobalFeed({required int page});
}