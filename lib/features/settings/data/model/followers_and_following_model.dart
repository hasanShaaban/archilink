import 'package:archilink/features/Post/data/models/pagination_model.dart';
import 'package:archilink/features/Search/data/model/user_model.dart';
import 'package:archilink/features/settings/domain/entity/followers_and_followings_entity.dart';

class FollowersAndFollowingModel extends FollowersAndFollowingsEntity {
  const FollowersAndFollowingModel({
    required super.users,
    required super.pagination,
  });

  factory FollowersAndFollowingModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return FollowersAndFollowingModel(
      users: (data['users'] as List<dynamic>)
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),

      pagination: PaginationModel.fromJson(
        data['pagination'] as Map<String, dynamic>,
      ).toEntity(),
    );
  }
}
