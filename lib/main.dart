import 'package:archilink/core/functions/on_generate_route.dart';
import 'package:archilink/core/services/media_picker_service.dart';
import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/core/theme/app_theme.dart';
import 'package:archilink/core/utils/constants.dart';
import 'package:archilink/features/Create_Post/domain/repo/create_post_repo.dart';
import 'package:archilink/features/Create_Post/presentation/manager/cubit/create_post_cubit.dart';
import 'package:archilink/features/Post/presentation/manager/cubit/post_like_cubit.dart';
import 'package:archilink/features/Profile/domain/repo/profile_repo.dart';
import 'package:archilink/features/Profile/presentation/manager/bloc/profile_bloc.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/profile_cubit.dart';
import 'package:archilink/features/Splash/presentation/views/splash_view.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  final authBox = await Hive.openBox(kAuthBox);
  final profileBox = await Hive.openBox(kProfileBox);
  await initServiceLocator(authBox: authBox, profileBox: profileBox);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      //Bloc Providers
      providers: [
        BlocProvider(create: (context) => ProfileCubit(sl<ProfileRepo>())),
        BlocProvider(create: (context) => sl<PostLikeCubit>()),
        BlocProvider(create: (context) => sl<ProfileBloc>()),
        BlocProvider(
          create: (context) => CreatePostCubit(
            mediaPickerService: sl<MediaPickerService>(),
            createPostRepo: sl<CreatePostRepo>(),
          ),
        ),
      ],
      child: MaterialApp(
        // Localization
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,

        // Debug
        debugShowCheckedModeBanner: false,

        // App
        title: 'ArchiLink Demo',

        // Theme
        theme: AppTheme.lightMode,
        darkTheme: AppTheme.darkMode,
        themeMode: ThemeMode.system,

        //Routing
        onGenerateRoute: onGenerateRoute,
        initialRoute: SplashView.name,
      ),
    );
  }
}
