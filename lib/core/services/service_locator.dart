import 'package:archilink/core/network/api_service.dart';
import 'package:archilink/core/network/dio_client.dart';
import 'package:archilink/core/network/interceptors/auth_interceptor.dart';
import 'package:archilink/core/network/interceptors/error_interceptor.dart';
import 'package:archilink/core/network/interceptors/log_interceptor.dart';
import 'package:archilink/core/network/network_config.dart';
import 'package:archilink/core/network/websocket/reverb_client.dart';
import 'package:archilink/core/services/media_picker_service.dart';
import 'package:archilink/core/services/notification/data_source/fcm_data_source.dart';
import 'package:archilink/core/services/notification/data_source/fcm_data_source_impl.dart';
import 'package:archilink/core/services/notification/display/notificatio_display_service.dart';
import 'package:archilink/core/services/notification/display/notification_display_service_impl.dart';
import 'package:archilink/core/services/post_images_picker.dart';
import 'package:archilink/core/services/profile_image_picker.dart';
import 'package:archilink/core/storage/hive_storage.dart';
import 'package:archilink/core/storage/local_storage.dart';
import 'package:archilink/core/utils/constants.dart';
import 'package:archilink/core/utils/device_helper.dart';
import 'package:archilink/features/Auth/data/data_source/auth_local_data_source_impl.dart';
import 'package:archilink/features/Auth/data/data_source/auth_remote_data_source_impl.dart';
import 'package:archilink/features/Auth/data/repo/auth_repo_impl.dart';
import 'package:archilink/features/Auth/data/repo/notification_repo_impl.dart';
import 'package:archilink/features/Auth/domain/data_source/auth_local_data_source.dart';
import 'package:archilink/features/Auth/domain/data_source/auth_remote_data_source.dart';
import 'package:archilink/features/Auth/domain/repo/auth_repo.dart';
import 'package:archilink/features/Auth/domain/repo/notification_repo.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/auth_cubit.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/check_username_cubit.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/current_user_cubit.dart';
import 'package:archilink/features/Chat/data/data_source/chat_remote_data_source_impl.dart';
import 'package:archilink/features/Chat/data/data_source/chat_websocket_remote_data_source_impl.dart';
import 'package:archilink/features/Chat/data/repo/chat_repo_impl.dart';
import 'package:archilink/features/Chat/data/repo/chat_websocket_repo_impl.dart';
import 'package:archilink/features/Chat/domain/data_source/chat_remote_data_source.dart';
import 'package:archilink/features/Chat/domain/data_source/chat_websocket_remote_data_source.dart';
import 'package:archilink/features/Chat/domain/repo/chat_repo.dart';
import 'package:archilink/features/Chat/domain/repo/chat_websocket_repo.dart';
import 'package:archilink/features/Chat/domain/usecase/listen_to_chat_usecase.dart';
import 'package:archilink/features/Chat/presentation/manager/bloc/chat_bloc.dart';
import 'package:archilink/features/Create_Post/data/data_source/create_post_remote_date_source_impl.dart';
import 'package:archilink/features/Edit_Profile/data/data_source/edit_profile_remote_data_source_impl.dart';
import 'package:archilink/features/Edit_Profile/data/repo/edit_profile_repo_impl.dart';
import 'package:archilink/features/Edit_Profile/domain/data_source/edit_profile_remote_data_source.dart';
import 'package:archilink/features/Edit_Profile/domain/repo/edit_profile_repo.dart';
import 'package:archilink/features/Edit_Profile/presentation/manager/cubit/universities_cubit.dart';
import 'package:archilink/features/Main/presentation/manager/main_tab_controller.dart';
import 'package:archilink/features/Create_Post/data/repo/create_post_repo_impl.dart';
import 'package:archilink/features/Create_Post/domain/data_source/create_post_remote_data_source.dart';
import 'package:archilink/features/Create_Post/domain/repo/create_post_repo.dart';
import 'package:archilink/features/Home/data/data_source/home_remote_data_source_impl.dart';
import 'package:archilink/features/Home/data/repo/home_repo_impl.dart';
import 'package:archilink/features/Home/domain/data_source/home_remote_data_source.dart';
import 'package:archilink/features/Home/domain/repo/home_repo.dart';
import 'package:archilink/features/Post/data/data_source/post_remote_data_source_impl.dart';
import 'package:archilink/features/Post/data/repo/post_repo_impl.dart';
import 'package:archilink/features/Post/domain/data_soource/post_remote_data_source.dart';
import 'package:archilink/features/Post/domain/repo/post_repo.dart';
import 'package:archilink/features/Post/presentation/manager/cubit/post_like_cubit.dart';
import 'package:archilink/features/Post_Details/data/data_source/post_details_remote_data_source_impl.dart';
import 'package:archilink/features/Post_Details/data/repo/post_details_repo_impl.dart';
import 'package:archilink/features/Post_Details/domain/data_source/post_details_remote_data_source.dart';
import 'package:archilink/features/Post_Details/domain/repo/post_details_repo.dart';
import 'package:archilink/features/Profile/data/data_source/profile_local_data_source_impl.dart';
import 'package:archilink/features/Profile/data/data_source/profile_remote_data_source_impl.dart';
import 'package:archilink/features/Profile/data/repo/profile_repo_impl.dart';
import 'package:archilink/features/Profile/domain/data_source/profile_local_data_source.dart';
import 'package:archilink/features/Profile/domain/data_source/profile_remote_data_source.dart';
import 'package:archilink/features/Profile/domain/repo/profile_repo.dart';
import 'package:archilink/features/Profile/presentation/manager/bloc/profile_bloc.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/follow_cubit.dart';
import 'package:archilink/features/Search/data/data_source/search_remote_data_source_impl.dart';
import 'package:archilink/features/Search/data/repo/search_repo_impl.dart';
import 'package:archilink/features/Search/domain/data_source/search_remote_data_source.dart';
import 'package:archilink/features/Search/domain/repo/search_repo.dart';
import 'package:archilink/features/settings/data/data_source/setting_remote_data_source_impl.dart';
import 'package:archilink/features/settings/data/repo/setting_repo_impl.dart';
import 'package:archilink/features/settings/domain/data_source/setting_remote_data_source.dart';
import 'package:archilink/features/settings/domain/repo/setting_repo.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/followers_and_following_cubit.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/settings_session_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

final GetIt sl = GetIt.instance;

Future<void> initServiceLocator({
  required Box authBox,
  required Box profileBox,
}) async {
  ///----------
  ///Services
  ///----------
  ///
  // sl.registerLazySingleton(() => PusherClient.instance);
  sl.registerLazySingleton(() => ReverbClient.instance);
  sl.registerLazySingleton<MediaPickerService>(
    () => PostImagesPicker(),
    instanceName: kPostImagePicker,
  );
  sl.registerLazySingleton<MediaPickerService>(
    () => ProfileImagePicker(),
    instanceName: kProfileImagePicker,
  );
  sl.registerLazySingleton<NotificationDisplayService>(
    () => NotificationDisplayServiceImpl(),
  );

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
  sl.registerLazySingleton<PostDetailsRemoteDataSource>(
    () => PostDetailsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CreatePostRemoteDataSource>(
    () => CreatePostRemoteDateSourceImpl(sl()),
  );
  sl.registerLazySingleton<EditProfileRemoteDataSource>(
    () => EditProfileRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ChatWebsocketRemoteDataSource>(
    () => ChatWebsocketRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<SettingRemoteDataSource>(
    () => SettingRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<FCMDataSource>(() => FCMDataSourceImpl());

  ///----------
  ///Interceptor
  ///----------
  sl.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(sl(), sl<ReverbClient>()),
  );
  sl.registerLazySingleton<ErrorInterceptor>(() => ErrorInterceptor());
  sl.registerLazySingleton<LogInterseptor>(() => LogInterseptor());

  final isEmulator = await DeviceInfoHelper.isEmulator();
  final baseURL = isEmulator
      ? NetworkConfig.emulatorBaseUrl
      : NetworkConfig.physicalBaseUrl;

  ///----------
  ///Dio client
  ///----------
  sl.registerLazySingleton<DioClient>(
    () => DioClient(
      baseUrl: baseURL,
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
  sl.registerLazySingleton<ChatWebsocketRepo>(
    () => ChatWebsocketRepoImpl(sl()),
  );
  sl.registerLazySingleton<ChatRepo>(
    () => ChatRepoImpl(sl<ChatRemoteDataSource>()),
  );
  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(localDataSource: sl(), remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ProfileRepo>(
    () => ProfileRepoImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton<HomeRepo>(
    () => HomeRepoImpl(sl<HomeRemoteDataSource>()),
  );
  sl.registerLazySingleton<PostRepo>(
    () => PostRepoImpl(sl<PostRemoteDataSource>()),
  );
  sl.registerLazySingleton<PostDetailsRepo>(
    () => PostDetailsRepoImpl(sl<PostDetailsRemoteDataSource>()),
  );
  sl.registerLazySingleton<CreatePostRepo>(
    () => CreatePostRepoImpl(
      sl<ProfileLocalDataSource>(),
      remoteDataSource: sl<CreatePostRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton<EditProfileRepo>(
    () => EditProfileRepoImpl(sl<EditProfileRemoteDataSource>()),
  );
  sl.registerLazySingleton<NotificationRepo>(
    () => NotificationRepoImpl(
      sl<FCMDataSource>(),
      sl<AuthRemoteDataSource>(),
      sl<AuthLocalDataSource>(),
      sl<NotificationDisplayService>(),
    ),
  );
  sl.registerLazySingleton<SearchRepo>(
    () => SearchRepoImpl(sl<SearchRemoteDataSource>()),
  );
  sl.registerLazySingleton<SettingRepo>(
    () => SettingRepoImpl(sl<SettingRemoteDataSource>()),
  );

  ///---------
  ///Usecases
  ///---------
  sl.registerLazySingleton(() => ListenToChatUsecase(sl()));

  ///---------
  ///Bloc
  ///---------
  sl.registerLazySingleton(() => MainTabController());
  sl.registerLazySingleton(() => CurrentUserCubit(sl()));
  sl.registerLazySingleton(() => CheckUsernameCubit(sl()));
  sl.registerLazySingleton(() => PostLikeCubit(sl()));
  sl.registerLazySingleton(
    () => ProfileBloc(sl<ProfileRepo>(), sl<PostLikeCubit>()),
  );
  sl.registerLazySingleton(
    () => AuthCubit(
      sl<AuthRepo>(),
      sl<CurrentUserCubit>(),
      sl<NotificationRepo>(),
      sl<ReverbClient>(),
    ),
  );
  sl.registerLazySingleton(() => UniversitiesCubit(sl<EditProfileRepo>()));
  sl.registerLazySingleton(() => ChatBloc(sl(), sl<ChatRepo>()));
  sl.registerFactory(() => FollowCubit(sl<ProfileRepo>()));
  sl.registerFactory(
    () => SettingsSessionCubit(
      sl<SettingRepo>(),
      sl<AuthLocalDataSource>(),
      sl<CurrentUserCubit>(),
      sl<ReverbClient>(),
    ),
  );
  sl.registerFactory(
    () => FollowersAndFollowingCubit(
      sl<SettingRepo>(),
      sl<CurrentUserCubit>(),
    ),
  );
}
