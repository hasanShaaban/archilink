import 'dart:convert';
import 'package:archilink/core/storage/local_storage.dart';
import 'package:archilink/features/Auth/data/data_source/auth_local_data_source_impl.dart';
import 'package:archilink/features/Auth/data/models/auth_token_model.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/current_user_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeLocalStorage implements LocalStorage {
  final Map<String, dynamic> _data = {};

  @override
  Future<void> clear() async {
    _data.clear();
  }

  @override
  Future<void> delete(String key) async {
    _data.remove(key);
  }

  @override
  T? read<T>(String key) {
    return _data[key] as T?;
  }

  @override
  Future<void> write<T>(String key, T value) async {
    _data[key] = value;
  }
}

void main() {
  group('AuthTokenModel parsing', () {
    const loginJson = '''{
	"status": "success",
	"message": "Login successful",
	"data": {
		"id": 1,
		"username": "testUser1",
		"role": "mentor",
		"access_token": "26|EjmF0iOr2Gg2zxezRiP3WJmOp1V6JHLqpRisffxy48b93567",
		"token_type": "Bearer"
	}
}''';

    test('parses full login response and converts to entity', () {
      final decoded = jsonDecode(loginJson) as Map<String, dynamic>;
      final model = AuthTokenModel.fromJson(decoded);

      expect(model.id, 1);
      expect(model.username, 'testUser1');
      expect(model.accessToken, '26|EjmF0iOr2Gg2zxezRiP3WJmOp1V6JHLqpRisffxy48b93567');
      expect(model.tokenType, 'Bearer');
      expect(model.role, 'mentor');
      expect(model.status, 'success');
      expect(model.message, 'Login successful');

      final entity = model.toEntity();
      expect(entity.id, 1);
      expect(entity.username, 'testUser1');
      expect(entity.accessToken, '26|EjmF0iOr2Gg2zxezRiP3WJmOp1V6JHLqpRisffxy48b93567');
      expect(entity.tokenType, 'Bearer');
      expect(entity.role, 'mentor');
      expect(entity.authorizationHeader, 'Bearer 26|EjmF0iOr2Gg2zxezRiP3WJmOp1V6JHLqpRisffxy48b93567');
    });

    test('parses inner data map directly', () {
      final decoded = jsonDecode(loginJson) as Map<String, dynamic>;
      final data = decoded['data'] as Map<String, dynamic>;
      final model = AuthTokenModel.fromJson(data);

      expect(model.id, 1);
      expect(model.username, 'testUser1');
      expect(model.role, 'mentor');
      expect(model.accessToken, '26|EjmF0iOr2Gg2zxezRiP3WJmOp1V6JHLqpRisffxy48b93567');
      expect(model.tokenType, 'Bearer');
    });
  });

  group('AuthLocalDataSource caching', () {
    test('saves, reads, and clears userId and role', () async {
      final fakeStorage = FakeLocalStorage();
      final localDataSource = AuthLocalDataSourceImpl(fakeStorage);

      expect(localDataSource.getUserId(), isNull);
      expect(localDataSource.getRole(), isNull);

      await localDataSource.saveUserId(1);
      await localDataSource.saveRole('mentor');
      expect(localDataSource.getUserId(), 1);
      expect(localDataSource.getRole(), 'mentor');

      await localDataSource.clearUserId();
      await localDataSource.clearRole();
      expect(localDataSource.getUserId(), isNull);
      expect(localDataSource.getRole(), isNull);
    });
  });

  group('CurrentUserCubit handling', () {
    test('loadFromCache loads id, username, token, role and setUser updates them', () async {
      final fakeStorage = FakeLocalStorage();
      final localDataSource = AuthLocalDataSourceImpl(fakeStorage);
      await localDataSource.saveUserId(1);
      await localDataSource.saveUsername('testUser1');
      await localDataSource.saveToken('test_token');
      await localDataSource.saveRole('mentor');

      final cubit = CurrentUserCubit(localDataSource);
      cubit.loadFromCache();

      expect(cubit.state.id, 1);
      expect(cubit.state.username, 'testUser1');
      expect(cubit.state.token, 'test_token');
      expect(cubit.state.role, 'mentor');

      cubit.setUser(id: 2, username: 'newUser', token: 'newToken', role: 'student');
      expect(cubit.state.id, 2);
      expect(cubit.state.username, 'newUser');
      expect(cubit.state.token, 'newToken');
      expect(cubit.state.role, 'student');

      cubit.setRole('store');
      expect(cubit.state.role, 'store');

      cubit.clear();
      expect(cubit.state.id, isNull);
      expect(cubit.state.role, isNull);
      expect(cubit.state.username, isNull);
      expect(cubit.state.token, isNull);

      await cubit.close();
    });
  });
}
