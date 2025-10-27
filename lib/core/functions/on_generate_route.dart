
import 'package:archilink/features/chat/presentation/view/chat_view.dart';
import 'package:archilink/features/post/presentation/view/post_details_view.dart';
import 'package:flutter/material.dart';
import 'package:archilink/features/main/presentation/views/main_page.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {

  switch (settings.name) {
    case ChatView.name:
      return MaterialPageRoute(builder: (context) => const ChatView());
    case PostDetailsView.name:
      return MaterialPageRoute(builder: (context) => const PostDetailsView());
    case MainView.name:
      return MaterialPageRoute(builder: (context) => const MainView());
    
    default:
      return MaterialPageRoute(builder: (context) => Scaffold(body: Center(child: Text('Page not found'))));
  }
}
