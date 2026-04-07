import 'package:archilink/features/Edit_Profile/presentation/view/widgets/edit_profile_app_bar.dart';
import 'package:flutter/material.dart';

class AcademicExperianceView extends StatelessWidget {
  const AcademicExperianceView({super.key});
  static const name = '/academicExperiance';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            EditProfileAppBar(
              titel: 'Academic Experiance',
              withDoneButton: false,
              backButtonIcon: Icons.arrow_back_ios_new_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
