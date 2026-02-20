
import 'package:archilink/features/Auth/presentation/views/auth_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/edit_profile_view.dart';
import 'package:archilink/features/Profile/presentation/views/user_profile_view.dart';
import 'package:archilink/features/Splash/presentation/views/splash_view.dart';
import 'package:archilink/features/Chat/presentation/view/chat_list_view.dart';
import 'package:archilink/features/Chat/presentation/view/app_chat_view.dart';
import 'package:archilink/features/Post/presentation/view/post_details_view.dart';
import 'package:flutter/material.dart';
import 'package:archilink/features/Main/presentation/views/main_page.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {

  switch (settings.name) {
    case SplashView.name:
      return MaterialPageRoute(builder: (context) => const SplashView());
    case AuthView.name:
      return MaterialPageRoute(builder: (context) => const AuthView());
    case ChatListView.name:
      return MaterialPageRoute(builder: (context) => const ChatListView());
    case AppChatView.name:
      return MaterialPageRoute(builder: (context) => const AppChatView());
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
