import 'package:archilink/features/settings/domain/entity/followers_and_followings_entity.dart';

abstract class SettingRemoteDataSource {
  Future<bool> logOut();
  Future<FollowersAndFollowingsEntity> getFollowers({required String username, required int page});
  Future<FollowersAndFollowingsEntity> getFollowing({required String username, required int page});
}
