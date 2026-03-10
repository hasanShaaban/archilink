import 'package:archilink/core/network/api_service.dart';
import 'package:archilink/core/network/dio_client.dart';
import 'package:archilink/core/network/interceptors/auth_interceptor.dart';
import 'package:archilink/core/network/interceptors/error_interceptor.dart';
import 'package:archilink/core/network/interceptors/log_interceptor.dart';
import 'package:archilink/core/storage/hive_storage.dart';
import 'package:archilink/core/storage/local_storage.dart';
import 'package:archilink/core/utils/constants.dart';
import 'package:archilink/features/Auth/data/data_source/auth_local_data_source_impl.dart';
import 'package:archilink/features/Auth/data/data_source/auth_remote_data_source_impl.dart';
import 'package:archilink/features/Auth/data/repo/auth_repo_impl.dart';
import 'package:archilink/features/Auth/domain/data_source/auth_local_data_source.dart';
import 'package:archilink/features/Auth/domain/data_source/auth_remote_data_source.dart';
import 'package:archilink/features/Auth/domain/repo/auth_repo.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/auth_cubit.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/check_username_cubit.dart';
import 'package:archilink/features/Home/data/data_source/home_remote_data_source_impl.dart';
import 'package:archilink/features/Home/data/repo/home_repo_impl.dart';
import 'package:archilink/features/Home/domain/data_source/home_remote_data_source.dart';
import 'package:archilink/features/Home/domain/repo/home_repo.dart';
import 'package:archilink/features/Home/presentation/manager/bloc/for_you_bloc.dart';
import 'package:archilink/features/Post/data/data_source/post_remote_data_source_impl.dart';
import 'package:archilink/features/Post/data/repo/post_repo_impl.dart';
import 'package:archilink/features/Post/domain/data_soource/post_remote_data_source.dart';
import 'package:archilink/features/Post/domain/repo/post_repo.dart';
import 'package:archilink/features/Post/presentation/manager/cubit/post_like_cubit.dart';
import 'package:archilink/features/Profile/data/data_source/profile_local_data_source_impl.dart';
import 'package:archilink/features/Profile/data/data_source/profile_remote_data_source_impl.dart';
import 'package:archilink/features/Profile/data/repo/profile_repo_impl.dart';
import 'package:archilink/features/Profile/domain/data_source/profile_local_data_source.dart';
import 'package:archilink/features/Profile/domain/data_source/profile_remote_data_source.dart';
import 'package:archilink/features/Profile/domain/repo/profile_repo.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

final GetIt sl = GetIt.instance;

Future<void> initServiceLocator({
  required Box authBox,
  required Box profileBox,
}) async {
  ///----------
  ///Storage
  ///----------
  sl.registerLazySingleton<LocalStorage>(
    () => HiveStorage(authBox),
    instanceName: kAuthStorage,
  );
  sl.registerLazySingleton<LocalStorage>(
    () => HiveStorage(profileBox),
    instanceName: kProfileStorage,
  );

  ///---------
  ///Local data source
  ///---------
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl<LocalStorage>(instanceName: kAuthStorage)),
  );

  sl.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(
      sl<LocalStorage>(instanceName: kProfileStorage),
    ),
  );

  ///---------
  ///remote data sources
  ///---------
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(sl()),
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

  sl.registerLazySingleton<ProfileRepo>(
    () => ProfileRepoImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton<HomeRepo>(() => HomeRepoImpl(sl()));
  sl.registerLazySingleton<PostRepo>(() => PostRepoImpl(sl()));

  ///---------
  ///Bloc
  ///---------
  sl.registerLazySingleton(() => AuthCubit(sl()));
  sl.registerLazySingleton(() => CheckUsernameCubit(sl()));
  sl.registerLazySingleton(() => PostLikeCubit(sl()));
  sl.registerLazySingleton(() => ForYouBloc(sl<HomeRepo>(),sl<PostLikeCubit>()));
}
