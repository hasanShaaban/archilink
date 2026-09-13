import 'package:archilink/features/Post/data/models/pagination_model.dart';
import 'package:archilink/features/Post/domain/entity/pagination_entity.dart';
import 'package:archilink/features/settings/domain/entity/follow_request_entity.dart';

class FollowRequestsModel extends FollowRequestsEntity {
  const FollowRequestsModel({
    required super.requests,
    required super.pagination,
  });

  factory FollowRequestsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;

    final requestsList = (data['requests'] as List<dynamic>? ?? [])
        .map((e) => FollowRequestItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final pagination = data['pagination'] != null
        ? PaginationModel.fromJson(
            data['pagination'] as Map<String, dynamic>,
          ).toEntity()
        : const PaginationEntity(
            currentPage: 1,
            perPage: 20,
            lastPage: 1,
            total: 0,
            hasMore: false,
          );

    return FollowRequestsModel(
      requests: requestsList,
      pagination: pagination,
    );
  }
}

class FollowRequestItemModel extends FollowRequestItemEntity {
  const FollowRequestItemModel({
    required super.id,
    required super.name,
    required super.username,
    super.profile,
  });

  factory FollowRequestItemModel.fromJson(Map<String, dynamic> json) {
    // In outgoing requests: { "followed": { "id": 2, "name": ..., "profile": ... } }
    // In incoming requests: { "follower": { ... } } or { "user": { ... } } or direct user map
    final userMap =
        (json['followed'] ?? json['follower'] ?? json['user'] ?? json)
            as Map<String, dynamic>;

    return FollowRequestItemModel(
      id: (userMap['id'] as num?)?.toInt() ?? 0,
      name: userMap['name'] as String? ?? '',
      username: userMap['username'] as String? ?? '',
      profile: userMap['profile'] != null
          ? FollowRequestProfileModel.fromJson(
              userMap['profile'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      if (profile != null)
        'profile': (profile as FollowRequestProfileModel).toJson(),
    };
  }
}

class FollowRequestProfileModel extends FollowRequestProfileEntity {
  const FollowRequestProfileModel({
    required super.id,
    required super.userId,
    required super.privacySetting,
    super.bio,
    super.aboutMe,
    super.profilePictureUrl,
    super.country,
    super.city,
  });

  factory FollowRequestProfileModel.fromJson(Map<String, dynamic> json) {
    return FollowRequestProfileModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: (json['user_id'] as num?)?.toInt() ?? 0,
      privacySetting: json['privacy_setting'] as String? ?? 'public',
      bio: json['bio'] as String?,
      aboutMe: json['about_me'] as String?,
      profilePictureUrl: json['profile_picture_url'] as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'privacy_setting': privacySetting,
      'bio': bio,
      'about_me': aboutMe,
      'profile_picture_url': profilePictureUrl,
      'country': country,
      'city': city,
    };
  }
}
