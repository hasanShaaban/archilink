import 'package:archilink/features/Auth/presentation/views/auth_view.dart';
import 'package:archilink/features/Chat/domain/entity/chat_args.dart';
import 'package:archilink/features/Create_Post/presentation/views/create_post_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/about_me_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/academic_experiance_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/add_academic_experiance_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/add_contact_info_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/contact_info_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/edit_profile_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/location_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/skills_view.dart';
import 'package:archilink/features/Profile/presentation/views/user_profile_view.dart';
import 'package:archilink/features/Splash/presentation/views/splash_view.dart';
import 'package:archilink/features/Chat/presentation/view/chat_list_view.dart';
import 'package:archilink/features/Chat/presentation/view/app_chat_view.dart';
import 'package:archilink/features/Post_Details/presentation/view/post_details_view.dart';
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
      final args = settings.arguments as ChatArgs;
      return MaterialPageRoute(builder: (context) => AppChatView(args: args));
    case PostDetailsView.name:
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (context) => PostDetailsView(post: args['post']),
      );
    case MainView.name:
      return MaterialPageRoute(builder: (context) => const MainView());
    case UserProfileView.name:
      return MaterialPageRoute(builder: (context) => const UserProfileView());
    case EditProfileView.name:
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (context) => EditProfileView(profileData: args['profileData']),
      );
    case AboutMeView.name:
      return MaterialPageRoute(builder: (context) => const AboutMeView());
    case LocationView.name:
      return MaterialPageRoute(builder: (context) => const LocationView());
    case AcademicExperianceView.name:
      return MaterialPageRoute(
        builder: (context) => const AcademicExperianceView(),
      );
    case AddAcademicExperianceView.name:
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (context) => AddAcademicExperianceView(
          initialExperience: args?['experience'],
          editIndex: args?['index'],
        ),
      );
    case ContactInfoView.name:
      return MaterialPageRoute(builder: (context) => const ContactInfoView());
    case AddContactInfoView.name:
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (context) => AddContactInfoView(
          initialContactInfo: args?['contactInfo'],
          editIndex: args?['index'],
        ),
      );
    case SkillsView.name:
      return MaterialPageRoute(builder: (context) => const SkillsView());
    case CreatePostView.name:
      return MaterialPageRoute(builder: (context) => const CreatePostView());

    default:
      return MaterialPageRoute(
        builder: (context) =>
            Scaffold(body: Center(child: Text('Page not found'))),
      );
  }
}
