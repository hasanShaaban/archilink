import 'package:archilink/features/Auth/data/models/profile_model.dart';
import 'package:archilink/features/Auth/data/models/user_model.dart';
import 'package:archilink/features/Auth/domain/entity/register_etity.dart';

class RegisterModel {
  final UserModel user;
  final ProfileModel profile;
  final String token;

  RegisterModel({
    required this.user,
    required this.profile,
    required this.token,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return RegisterModel(
      user: UserModel.fromJson(data['user']),
      profile: ProfileModel.fromJson(data['profile']),
      token: data['token'],
    );
  }

  RegisterEntity toEntity() {
    return RegisterEntity(
      user: user.toEntity(),
      profile: profile.toEntity(),
      token: token,
    );
  }
}