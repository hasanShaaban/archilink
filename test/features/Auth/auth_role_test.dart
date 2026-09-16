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
  group('AuthTokenModel role parsing', () {
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

    test('parses role from login response and converts to entity', () {
      final decoded = jsonDecode(loginJson) as Map<String, dynamic>;
      final data = decoded['data'] as Map<String, dynamic>;
      final model = AuthTokenModel.fromJson(data);

      expect(model.username, 'testUser1');
      expect(model.accessToken, '26|EjmF0iOr2Gg2zxezRiP3WJmOp1V6JHLqpRisffxy48b93567');
      expect(model.tokenType, 'Bearer');
      expect(model.role, 'mentor');

      final entity = model.toEntity();
      expect(entity.username, 'testUser1');
      expect(entity.accessToken, '26|EjmF0iOr2Gg2zxezRiP3WJmOp1V6JHLqpRisffxy48b93567');
      expect(entity.role, 'mentor');
    });
  });

  group('AuthLocalDataSource role caching', () {
    test('saves, reads, and clears role', () async {
      final fakeStorage = FakeLocalStorage();
      final localDataSource = AuthLocalDataSourceImpl(fakeStorage);

      expect(localDataSource.getRole(), isNull);

      await localDataSource.saveRole('mentor');
      expect(localDataSource.getRole(), 'mentor');

      await localDataSource.clearRole();
      expect(localDataSource.getRole(), isNull);
    });
  });

  group('CurrentUserCubit role handling', () {
    test('loadFromCache loads role and setUser updates role', () async {
      final fakeStorage = FakeLocalStorage();
      final localDataSource = AuthLocalDataSourceImpl(fakeStorage);
      await localDataSource.saveUsername('testUser1');
      await localDataSource.saveToken('test_token');
      await localDataSource.saveRole('mentor');

      final cubit = CurrentUserCubit(localDataSource);
      cubit.loadFromCache();

      expect(cubit.state.username, 'testUser1');
      expect(cubit.state.token, 'test_token');
      expect(cubit.state.role, 'mentor');

      cubit.setUser(username: 'newUser', token: 'newToken', role: 'student');
      expect(cubit.state.username, 'newUser');
      expect(cubit.state.token, 'newToken');
      expect(cubit.state.role, 'student');

      cubit.setRole('store');
      expect(cubit.state.role, 'store');

      cubit.clear();
      expect(cubit.state.role, isNull);
      expect(cubit.state.username, isNull);
      expect(cubit.state.token, isNull);

      await cubit.close();
    });
  });
}
