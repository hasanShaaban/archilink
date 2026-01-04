import 'package:archilink/core/functions/on_generate_route.dart';
import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/core/theme/app_theme.dart';
import 'package:archilink/features/Splash/presentation/views/splash_view.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  await initServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
