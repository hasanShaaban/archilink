import 'package:archilink/core/theme/app_theme.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
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

      home: Test(),
    );
  }
}

class Test extends StatelessWidget {
  const Test({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ArchiLink Demo'),
      ),
      body: Column(
        children: [
          ElevatedButton(onPressed: (){}, child: Text('text button',)),
          Center(
            child: Text(S.of(context).welcome),
          ),
        ],
      ), 
    );
  }
}
