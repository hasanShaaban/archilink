import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/error/failure.dart';
import 'package:archilink/core/network/api_service.dart';
import 'package:archilink/core/services/media_picker_service.dart';
import 'package:archilink/core/utils/fakers.dart';
import 'package:archilink/features/Create_Post/data/data_source/create_post_remote_date_source_impl.dart';
import 'package:archilink/features/Create_Post/data/repo/create_post_repo_impl.dart';
import 'package:archilink/features/Create_Post/domain/data_source/create_post_remote_data_source.dart';
import 'package:archilink/features/Create_Post/domain/entity/create_post_parms.dart';
import 'package:archilink/features/Create_Post/domain/entity/create_post_response_entity.dart';
import 'package:archilink/features/Create_Post/domain/repo/create_post_repo.dart';
import 'package:archilink/features/Create_Post/presentation/manager/cubit/create_post_cubit.dart';
import 'package:archilink/features/Post/domain/repo/post_repo.dart';
import 'package:archilink/features/Post/presentation/manager/cubit/post_like_cubit.dart';
import 'package:archilink/features/Profile/data/model/profile_model.dart';
import 'package:archilink/features/Profile/domain/data_source/profile_local_data_source.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:archilink/features/Profile/domain/repo/profile_repo.dart';
import 'package:archilink/features/Profile/presentation/manager/bloc/profile_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class MockApiService implements ApiService {
  String? lastPatchPath;
  dynamic lastPatchBody;
  Response<dynamic>? patchResponse;
  DioException? patchException;

  @override
  Dio get dio => throw UnimplementedError();

  @override
  Future<Response<T>> patch<T>(String path, {dynamic body}) async {
    lastPatchPath = path;
    lastPatchBody = body;
    if (patchException != null) {
      throw patchException!;
    }
    return patchResponse as Response<T>;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeCreatePostRemoteDataSource implements CreatePostRemoteDataSource {
  int? lastPostId;
  String? lastBody;
  String? lastPrivacy;
  bool shouldThrow = false;

  @override
  Future<bool> updatePost({
    required int postId,
    required String body,
    required String privacy,
  }) async {
    lastPostId = postId;
    lastBody = body;
    lastPrivacy = privacy;
    if (shouldThrow) {
      throw ServerException(message: 'Server error');
    }
    return true;
  }

  @override
  Future<CreatePostResponseEntity> createPost(CreatePostParms parms) =>
      throw UnimplementedError();
}

class MockCreatePostRepo implements CreatePostRepo {
  int? lastPostId;
  String? lastBody;
  String? lastPrivacy;
  Either<Failure, bool>? updateResult;

  @override
  Future<Either<Failure, bool>> updatePost({
    required int postId,
    required String body,
    required String privacy,
  }) async {
    lastPostId = postId;
    lastBody = body;
    lastPrivacy = privacy;
    return updateResult ?? const Right(true);
  }

  @override
  ProfileEntity? getPosterProfileData() => null;

  @override
  Future<Either<Failure, CreatePostResponseEntity>> createPost(
    CreatePostParms parms,
  ) => throw UnimplementedError();
}

class FakeProfileLocalDataSource implements ProfileLocalDataSource {
  @override
  ProfileModel? getCachedProfile() => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeMediaPickerService implements MediaPickerService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeProfileRepo implements ProfileRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakePostRepo implements PostRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('CreatePostRemoteDateSourceImpl - updatePost', () {
    late MockApiService mockApi;
    late CreatePostRemoteDateSourceImpl dataSource;

    setUp(() {
      mockApi = MockApiService();
      dataSource = CreatePostRemoteDateSourceImpl(mockApi);
    });

    test('issues PATCH request to post-center/update-post/{id} and returns true on success', () async {
      mockApi.patchResponse = Response(
        requestOptions: RequestOptions(path: ''),
        data: {
          'status': 'success',
          'message': {
            'id': 78,
            'body': 'swan song',
            'privacy': 'public',
          },
          'data': 'Post updated successfully',
        },
      );

      final result = await dataSource.updatePost(
        postId: 78,
        body: 'swan song',
        privacy: 'public',
      );

      expect(result, isTrue);
      expect(mockApi.lastPatchPath, 'post-center/update-post/78');
      expect(mockApi.lastPatchBody, {
        'body': 'swan song',
        'privacy': 'public',
      });
    });

    test('throws ServerException when status is not success', () async {
      mockApi.patchResponse = Response(
        requestOptions: RequestOptions(path: ''),
        data: {
          'status': 'error',
          'message': 'Unauthorized',
        },
      );

      expect(
        () => dataSource.updatePost(
          postId: 78,
          body: 'swan song',
          privacy: 'public',
        ),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('CreatePostRepoImpl - updatePost', () {
    late FakeCreatePostRemoteDataSource fakeRemote;
    late CreatePostRepoImpl repo;

    setUp(() {
      fakeRemote = FakeCreatePostRemoteDataSource();
      repo = CreatePostRepoImpl(
        FakeProfileLocalDataSource(),
        remoteDataSource: fakeRemote,
      );
    });

    test('returns Right(true) on successful update', () async {
      final result = await repo.updatePost(
        postId: 78,
        body: 'updated body',
        privacy: 'private',
      );

      expect(result.isRight(), isTrue);
      expect(fakeRemote.lastPostId, 78);
      expect(fakeRemote.lastBody, 'updated body');
      expect(fakeRemote.lastPrivacy, 'private');
    });

    test('returns Left(Failure) when remote throws exception', () async {
      fakeRemote.shouldThrow = true;
      final result = await repo.updatePost(
        postId: 78,
        body: 'updated body',
        privacy: 'public',
      );

      expect(result.isLeft(), isTrue);
    });
  });

  group('CreatePostCubit - edit mode & updatePost', () {
    late MockCreatePostRepo mockRepo;
    late CreatePostCubit cubit;

    setUp(() {
      mockRepo = MockCreatePostRepo();
      cubit = CreatePostCubit(
        mediaPickerService: FakeMediaPickerService(),
        createPostRepo: mockRepo,
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('initForEdit correctly populates state for edit mode', () {
      final post = fakePostEntity(id: 78).copyWith(
        body: 'original body',
        privacy: 'public',
      );

      cubit.initForEdit(post);

      expect(cubit.state.isEditMode, isTrue);
      expect(cubit.state.editingPostId, 78);
      expect(cubit.state.postText, 'original body');
      expect(cubit.state.privacy, 'public');
      expect(cubit.state.canPost, isTrue);
    });

    test('updatePost calls repo and updates state to updateSuccess', () async {
      final post = fakePostEntity(id: 78).copyWith(
        body: 'original body',
        privacy: 'public',
      );

      cubit.initForEdit(post);
      cubit.onTextChanged('updated text');
      cubit.togglePrivacy(); // flips to 'private'

      await cubit.updatePost();

      expect(mockRepo.lastPostId, 78);
      expect(mockRepo.lastBody, 'updated text');
      expect(mockRepo.lastPrivacy, 'private');
      expect(cubit.state.updateSuccess, isTrue);
      expect(cubit.state.isSubmitting, isFalse);
    });
  });

  group('ProfileBloc - UpdateProfilePostContent', () {
    late ProfileBloc profileBloc;

    setUp(() {
      profileBloc = ProfileBloc(
        FakeProfileRepo(),
        PostLikeCubit(FakePostRepo()),
      );
    });

    tearDown(() {
      profileBloc.close();
    });

    test('updates post body and privacy in memory when UpdateProfilePostContent is added', () async {
      final post1 = fakePostEntity(id: 1).copyWith(body: 'post 1 body', privacy: 'public');
      final post2 = fakePostEntity(id: 2).copyWith(body: 'post 2 body', privacy: 'public');

      profileBloc.emit(profileBloc.state.copyWith(profilePosts: [post1, post2]));

      profileBloc.add(
        const UpdateProfilePostContent(
          postId: 1,
          body: 'post 1 new updated body',
          privacy: 'private',
        ),
      );

      await expectLater(
        profileBloc.stream,
        emits(predicate<ProfileState>((state) {
          final updated = state.profilePosts.firstWhere((p) => p.id == 1);
          return updated.body == 'post 1 new updated body' && updated.privacy == 'private';
        })),
      );
    });
  });
}
