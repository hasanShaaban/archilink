
import 'package:archilink/features/Auth/presentation/views/auth_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/edit_profile_view.dart';
import 'package:archilink/features/Profile/presentation/views/user_profile_view.dart';
import 'package:archilink/features/Splash/presentation/views/splash_view.dart';
import 'package:archilink/features/chat/presentation/view/chat_view.dart';
import 'package:archilink/features/post/presentation/view/post_details_view.dart';
import 'package:flutter/material.dart';
import 'package:archilink/features/main/presentation/views/main_page.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {

  switch (settings.name) {
    case SplashView.name:
      return MaterialPageRoute(builder: (context) => const SplashView());
    case AuthView.name:
      return MaterialPageRoute(builder: (context) => const AuthView());
    case ChatView.name:
      return MaterialPageRoute(builder: (context) => const ChatView());
    case PostDetailsView.name:
      return MaterialPageRoute(builder: (context) => const PostDetailsView());
    case MainView.name:
      return MaterialPageRoute(builder: (context) => const MainView());
    case UserProfileView.name:
      return MaterialPageRoute(builder: (context)=> const UserProfileView());
    case EditProfileView.name:
      return MaterialPageRoute(builder: (context)=> const EditProfileView());
    
    default:
      return MaterialPageRoute(builder: (context) => Scaffold(body: Center(child: Text('Page not found'))));
  }
}
