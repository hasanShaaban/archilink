import 'package:archilink/features/Post/domain/entity/pagination_entity.dart';
import 'package:archilink/features/Search/domain/entity/user_entity.dart';
import 'package:equatable/equatable.dart';

class FollowRequestsEntity extends Equatable {
  final List<FollowRequestItemEntity> requests;
  final PaginationEntity pagination;

  const FollowRequestsEntity({
    required this.requests,
    required this.pagination,
  });

  @override
  List<Object?> get props => [requests, pagination];
}

class FollowRequestItemEntity extends Equatable {
  final int id;
  final String name;
  final String username;
  final FollowRequestProfileEntity? profile;

  const FollowRequestItemEntity({
    required this.id,
    required this.name,
    required this.username,
    this.profile,
  });

  String? get profilePictureUrl => profile?.profilePictureUrl;
  String? get bio => profile?.bio;
  String? get aboutMe => profile?.aboutMe;
  String? get country => profile?.country;
  String? get city => profile?.city;
  String get privacySetting => profile?.privacySetting ?? 'public';

  UserEntity toUserEntity() {
    return UserEntity(
      id: id,
      name: name,
      username: username,
      isFollowing: false,
      userAvatar: profile?.profilePictureUrl,
      isVerified: false,
      country: profile?.country,
      city: profile?.city,
    );
  }

  @override
  List<Object?> get props => [id, name, username, profile];
}

class FollowRequestProfileEntity extends Equatable {
  final int id;
  final int userId;
  final String privacySetting;
  final String? bio;
  final String? aboutMe;
  final String? profilePictureUrl;
  final String? country;
  final String? city;

  const FollowRequestProfileEntity({
    required this.id,
    required this.userId,
    required this.privacySetting,
    this.bio,
    this.aboutMe,
    this.profilePictureUrl,
    this.country,
    this.city,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        privacySetting,
        bio,
        aboutMe,
        profilePictureUrl,
        country,
        city,
      ];
}
