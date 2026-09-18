import 'dart:io';

import 'package:archilink/features/Post/data/models/posts_model.dart';
import 'package:archilink/features/Profile/data/model/profile_model.dart';
import 'package:archilink/features/Profile/domain/entity/follow_status.dart';
import 'package:archilink/features/Store/data/models/product_feed_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile({required String username});
  Future<ProfileModel> getPersonalStoreProfile();
  Future<ProfileModel> getStoreProfile({required int id, String? handle});
  Future<ProductFeedModel> getStoreProducts({
    required int storeId,
    int page = 1,
  });
  Future<PostsModel> getMyPosts(int page);
  Future<PostsModel> getProfilePosts({
    required String username,
    required int page,
  });
  Future<FollowStatus> follow(String username);
  Future<bool> unfollow(String username);
  Future<bool> updateProfilePicture(File imageFile);
  Future<bool> updateStoreLogo(File imageFile);
  Future<bool> updateStoreBanner(File imageFile);
  Future<bool> deleteProduct(int productId);
}

