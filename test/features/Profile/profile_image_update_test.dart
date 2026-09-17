import 'dart:io';
import 'package:archilink/core/error/failure.dart';
import 'package:archilink/core/network/api_service.dart';
import 'package:archilink/features/Profile/data/data_source/profile_remote_data_source_impl.dart';
import 'package:archilink/features/Profile/data/repo/profile_repo_impl.dart';
import 'package:archilink/features/Profile/domain/data_source/profile_local_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeApiService implements ApiService {
  final Map<String, dynamic> responses = {};
  String? lastPostFormPath;
  FormData? lastPostFormData;

  @override
  Dio get dio => Dio();

  @override
  Future<Response<T>> postForm<T>(String path, {required FormData formData}) async {
    lastPostFormPath = path;
    lastPostFormData = formData;

    if (responses.containsKey(path)) {
      return Response<T>(
        data: responses[path] as T,
        statusCode: 200,
        requestOptions: RequestOptions(path: path),
      );
    }

    throw DioException(
      requestOptions: RequestOptions(path: path),
      type: DioExceptionType.badResponse,
      response: Response(
        statusCode: 400,
        requestOptions: RequestOptions(path: path),
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeProfileLocalDataSource implements ProfileLocalDataSource {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeApiService fakeApi;
  late ProfileRemoteDataSourceImpl remoteDataSource;
  late ProfileRepoImpl profileRepo;
  late File dummyFile;

  setUpAll(() {
    final tempDir = Directory.systemTemp.createTempSync('image_update_test');
    dummyFile = File('${tempDir.path}/avatar.jpg')..createSync();
    dummyFile.writeAsBytesSync([1, 2, 3, 4]);
  });

  tearDownAll(() {
    try {
      if (dummyFile.existsSync()) dummyFile.deleteSync();
    } catch (_) {}
  });

  setUp(() {
    fakeApi = FakeApiService();
    remoteDataSource = ProfileRemoteDataSourceImpl(fakeApi);
    profileRepo = ProfileRepoImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: FakeProfileLocalDataSource(),
    );
  });

  group('ProfileRemoteDataSourceImpl image uploads', () {
    test('updateProfilePicture sends form data to profile/update-profile-picture with picture field', () async {
      fakeApi.responses['profile/update-profile-picture'] = {
        'status': 'success',
        'message': 'Profile picture updated successfully',
      };

      final result = await remoteDataSource.updateProfilePicture(dummyFile);

      expect(result, isTrue);
      expect(fakeApi.lastPostFormPath, 'profile/update-profile-picture');
      expect(fakeApi.lastPostFormData?.files.first.key, 'picture');
    });

    test('updateStoreLogo sends form data to store/profile/logo with logo field', () async {
      fakeApi.responses['store/profile/logo'] = {
        'status': 'success',
        'message': 'Store logo updated successfully',
      };

      final result = await remoteDataSource.updateStoreLogo(dummyFile);

      expect(result, isTrue);
      expect(fakeApi.lastPostFormPath, 'store/profile/logo');
      expect(fakeApi.lastPostFormData?.files.first.key, 'logo');
    });

    test('updateStoreBanner sends form data to store/profile/banner with banner field', () async {
      fakeApi.responses['store/profile/banner'] = {
        'status': 'success',
        'message': 'Store banner updated successfully',
      };

      final result = await remoteDataSource.updateStoreBanner(dummyFile);

      expect(result, isTrue);
      expect(fakeApi.lastPostFormPath, 'store/profile/banner');
      expect(fakeApi.lastPostFormData?.files.first.key, 'banner');
    });
  });

  group('ProfileRepoImpl image uploads', () {
    test('updateProfilePicture returns Right(true) on success', () async {
      fakeApi.responses['profile/update-profile-picture'] = {
        'status': 'success',
        'message': 'Profile picture updated successfully',
      };

      final result = await profileRepo.updateProfilePicture(dummyFile);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should succeed'),
        (status) => expect(status, isTrue),
      );
    });

    test('updateStoreLogo returns Right(true) on success', () async {
      fakeApi.responses['store/profile/logo'] = {
        'status': 'success',
        'message': 'Store logo updated successfully',
      };

      final result = await profileRepo.updateStoreLogo(dummyFile);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should succeed'),
        (status) => expect(status, isTrue),
      );
    });

    test('updateStoreBanner returns Right(true) on success', () async {
      fakeApi.responses['store/profile/banner'] = {
        'status': 'success',
        'message': 'Store banner updated successfully',
      };

      final result = await profileRepo.updateStoreBanner(dummyFile);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should succeed'),
        (status) => expect(status, isTrue),
      );
    });

    test('returns Left(ServerFailure) when API fails', () async {
      // Path not registered in fakeApi -> will throw DioException 400
      final result = await profileRepo.updateProfilePicture(dummyFile);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (status) => fail('Should fail'),
      );
    });
  });
}
