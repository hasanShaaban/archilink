import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/error/failure.dart';
import 'package:archilink/core/network/api_service.dart';
import 'package:archilink/core/utils/fakers.dart';
import 'package:archilink/features/Post/data/data_source/post_remote_data_source_impl.dart';
import 'package:archilink/features/Post/data/repo/post_repo_impl.dart';
import 'package:archilink/features/Post/domain/data_soource/post_remote_data_source.dart';
import 'package:archilink/features/Post/domain/repo/post_repo.dart';
import 'package:archilink/features/Post/presentation/manager/cubit/post_like_cubit.dart';
import 'package:archilink/features/Post/presentation/manager/cubit/post_menu_cubit.dart';
import 'package:archilink/features/Post/presentation/view/post.dart';
import 'package:archilink/features/Profile/domain/repo/profile_repo.dart';
import 'package:archilink/features/Profile/presentation/manager/bloc/profile_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class MockApiService implements ApiService {
  String? lastDeletedPath;
  Response<dynamic>? deleteResponse;
  DioException? deleteException;

  @override
  Dio get dio => throw UnimplementedError();

  @override
  Future<Response<T>> delete<T>(String path) async {
    lastDeletedPath = path;
    if (deleteException != null) {
      throw deleteException!;
    }
    return deleteResponse as Response<T>;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakePostRemoteDataSource implements PostRemoteDataSource {
  int? lastDeletedId;
  bool shouldThrow = false;

  @override
  Future<bool> deletePost({required int postId}) async {
    lastDeletedId = postId;
    if (shouldThrow) {
      throw ServerException(message: 'Server error');
    }
    return true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockPostRepoForDelete implements PostRepo {
  int? lastDeletedId;
  Either<Failure, bool>? deleteResponse;

  @override
  Future<Either<Failure, bool>> deletePost({required int postId}) async {
    lastDeletedId = postId;
    return deleteResponse ?? right(true);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakePostLikeCubit extends PostLikeCubit {
  FakePostLikeCubit() : super(MockPostRepoForDelete());
}

class MockProfileRepo implements ProfileRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('PostRemoteDataSourceImpl.deletePost', () {
    late MockApiService mockApiService;
    late PostRemoteDataSourceImpl dataSource;

    setUp(() {
      mockApiService = MockApiService();
      dataSource = PostRemoteDataSourceImpl(mockApiService);
    });

    test('calls post-center/delete-post/{postId} with DELETE method and returns true on success', () async {
      mockApiService.deleteResponse = Response(
        requestOptions: RequestOptions(path: 'post-center/delete-post/20'),
        statusCode: 200,
        data: {
          'status': 'success',
          'message': null,
          'data': 'Post deleted successfully',
        },
      );

      final result = await dataSource.deletePost(postId: 20);

      expect(result, isTrue);
      expect(mockApiService.lastDeletedPath, equals('post-center/delete-post/20'));
    });

    test('throws ServerException if status is fail', () async {
      mockApiService.deleteResponse = Response(
        requestOptions: RequestOptions(path: 'post-center/delete-post/20'),
        statusCode: 200,
        data: {
          'status': 'fail',
          'message': 'You do not own this post',
          'data': null,
        },
      );

      expect(
        () => dataSource.deletePost(postId: 20),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('PostRepoImpl.deletePost', () {
    late FakePostRemoteDataSource fakeRemoteDataSource;
    late PostRepoImpl repo;

    setUp(() {
      fakeRemoteDataSource = FakePostRemoteDataSource();
      repo = PostRepoImpl(fakeRemoteDataSource);
    });

    test('returns Right(true) on successful delete', () async {
      final result = await repo.deletePost(postId: 20);

      expect(result, equals(right(true)));
      expect(fakeRemoteDataSource.lastDeletedId, equals(20));
    });

    test('returns Left(Failure) when remote data source throws', () async {
      fakeRemoteDataSource.shouldThrow = true;

      final result = await repo.deletePost(postId: 20);

      expect(result.isLeft(), isTrue);
    });
  });

  group('PostMenuCubit.deletePost', () {
    late MockPostRepoForDelete mockRepo;
    late PostMenuCubit cubit;

    setUp(() {
      mockRepo = MockPostRepoForDelete();
      cubit = PostMenuCubit(mockRepo);
    });

    tearDown(() async {
      await cubit.close();
    });

    test('emits [PostMenuLoading, PostMenuSuccess] and adds postId to deletedPostIds', () async {
      final expectedStates = [
        const PostMenuLoading(action: PostMenuAction.delete, postId: 20),
        const PostMenuSuccess(
          action: PostMenuAction.delete,
          postId: 20,
          message: 'Post deleted successfully',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.deletePost(postId: 20);

      expect(cubit.deletedPostIds.contains(20), isTrue);
      expect(mockRepo.lastDeletedId, equals(20));
    });

    test('emits [PostMenuLoading, PostMenuFailure] on repo failure', () async {
      mockRepo.deleteResponse = left(const ServerFailure(message: 'Unauthorized'));

      final expectedStates = [
        const PostMenuLoading(action: PostMenuAction.delete, postId: 20),
        const PostMenuFailure(
          action: PostMenuAction.delete,
          postId: 20,
          message: 'Unauthorized',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.deletePost(postId: 20);

      expect(cubit.deletedPostIds.contains(20), isFalse);
    });
  });

  group('ProfileBloc and PostMenuCubit delete coordination', () {
    late MockProfileRepo mockProfileRepo;
    late FakePostLikeCubit fakePostLikeCubit;
    late MockPostRepoForDelete mockPostRepo;
    late PostMenuCubit postMenuCubit;
    late ProfileBloc profileBloc;

    setUp(() {
      mockProfileRepo = MockProfileRepo();
      fakePostLikeCubit = FakePostLikeCubit();
      mockPostRepo = MockPostRepoForDelete();
      postMenuCubit = PostMenuCubit(mockPostRepo);
      profileBloc = ProfileBloc(mockProfileRepo, fakePostLikeCubit, postMenuCubit);
    });

    tearDown(() async {
      await profileBloc.close();
      await postMenuCubit.close();
      await fakePostLikeCubit.close();
    });

    test('ProfileBloc removes post when DeleteProfilePost event is added', () async {
      profileBloc.emit(
        ProfileState(
          profilePosts: [
            fakePostEntity(id: 10),
            fakePostEntity(id: 20),
            fakePostEntity(id: 30),
          ],
        ),
      );

      profileBloc.add(const DeleteProfilePost(postId: 20));

      await expectLater(
        profileBloc.stream,
        emits(
          predicate<ProfileState>(
            (state) =>
                state.profilePosts.length == 2 &&
                !state.profilePosts.any((p) => p.id == 20),
          ),
        ),
      );
    });

    test('ProfileBloc automatically removes post when PostMenuCubit deletes post successfully', () async {
      profileBloc.emit(
        ProfileState(
          profilePosts: [
            fakePostEntity(id: 10),
            fakePostEntity(id: 20),
            fakePostEntity(id: 30),
          ],
        ),
      );

      await postMenuCubit.deletePost(postId: 20);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(
        profileBloc.state.profilePosts.map((p) => p.id),
        equals([10, 30]),
      );
    });
  });
}
