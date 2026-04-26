import 'package:archilink/features/Auth/domain/entity/profile_record_entity.dart';
import 'package:archilink/features/Auth/domain/entity/auth_user_entity.dart';

class RegisterEntity {
  final AuthUserEntity user;
  final ProfileRecordEntity profile;
  final String token;

  const RegisterEntity({
    required this.user,
    required this.profile,
    required this.token,
  });
}
