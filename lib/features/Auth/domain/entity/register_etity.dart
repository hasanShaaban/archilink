import 'package:archilink/features/Auth/domain/entity/profile_entity.dart';
import 'package:archilink/features/Auth/domain/entity/user_entity.dart';

class RegisterEntity {
  final UserEntity user;
  final ProfileEntity profile;
  final String token;

  const RegisterEntity({
    required this.user,
    required this.profile,
    required this.token,
  });
}
