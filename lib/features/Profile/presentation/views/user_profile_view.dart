import 'package:archilink/features/Profile/domain/profile_type.dart';
import 'package:archilink/features/Profile/presentation/views/profile_page_body.dart';
import 'package:flutter/material.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});
  static const String name = '/profile';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SafeArea(child: ProfilePageBody(type: ProfileType.userProfile,)));
  }
}