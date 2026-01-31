import 'package:archilink/core/network/api_service.dart';
import 'package:archilink/core/network/dio_client.dart';
import 'package:archilink/core/network/interceptors/auth_interceptor.dart';
import 'package:archilink/core/network/interceptors/error_interceptor.dart';
import 'package:archilink/core/network/interceptors/log_interceptor.dart';
import 'package:archilink/core/storage/hive_storage.dart';
import 'package:archilink/core/storage/local_storage.dart';
import 'package:archilink/features/Auth/data/data_source/auth_local_data_source_impl.dart';
import 'package:archilink/features/Auth/data/data_source/auth_remote_data_source_impl.dart';
import 'package:archilink/features/Auth/data/repo/auth_repo_impl.dart';
import 'package:archilink/features/Auth/domain/data_source/auth_local_data_source.dart';
import 'package:archilink/features/Auth/domain/data_source/auth_remote_data_source.dart';
import 'package:archilink/features/Auth/domain/repo/auth_repo.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/auth_cubit.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/check_username_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

final GetIt sl = GetIt.instance;

Future<void> initServiceLocator(Box authBox) async {
  ///----------
  ///Storage
  ///----------
  sl.registerLazySingleton<LocalStorage>(() => HiveStorage(authBox));

  ///---------
  ///Local data source
  ///---------
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );

  ///---------
  ///remote data sources
  ///---------
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  ///----------
  ///Interceptor
  ///----------
  sl.registerLazySingleton<AuthInterceptor>(() => AuthInterceptor(sl()));
  sl.registerLazySingleton<ErrorInterceptor>(() => ErrorInterceptor());
  sl.registerLazySingleton<LogInterseptor>(() => LogInterseptor());

  ///----------
  ///Dio client
  ///----------
  sl.registerLazySingleton<DioClient>(
    () => DioClient(
      authInterceptor: sl(),
      errorInterceptor: sl(),
      logInterceptor: sl(),
    ),
  );

  ///---------
  ///Dio
  ///---------
  sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);

  ///---------
  ///Api Service
  ///---------
  sl.registerLazySingleton<ApiService>(() => ApiService(sl()));

  ///---------
  ///Repositories
  ///---------
  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(localDataSource: sl(), remoteDataSource: sl()),
  );

  ///---------
  ///Bloc
  ///---------
  sl.registerLazySingleton(() => AuthCubit(sl()));
  sl.registerLazySingleton(() => CheckUsernameCubit(sl()));
}
