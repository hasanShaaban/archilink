import 'package:archilink/core/storage/local_storage.dart';
import 'package:hive/hive.dart';

class HiveStorage implements LocalStorage{
  final Box box;

  HiveStorage(this.box);
  @override
  Future<void> clear() async{
    await box.clear();
  }

  @override
  Future<void> delete(String key) async{
    await box.delete(key);
  }

  @override
  T? read<T>(String key) {
    return box.get(key);
  }

  @override
  Future<void> write<T>(String key, T value) async{
    await box.put(key, value);
  }
}