import 'package:archilink/features/Create_Post/domain/repo/create_post_repo.dart';
import 'package:archilink/features/Profile/domain/data_source/profile_local_data_source.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';

class CreatePostRepoImpl extends CreatePostRepo {
  final ProfileLocalDataSource profileLocalDataSource;

  CreatePostRepoImpl(this.profileLocalDataSource);
  @override
  ProfileEntity? getPosterProfileData() {
    return profileLocalDataSource.getCachedProfile();
  }
}
