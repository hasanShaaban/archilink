import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/about_me_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/academic_experiance_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/contact_info_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/skills_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/edit_profile_account_type_button.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/edit_profile_app_bar.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/editable_text.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/routed_view_row.dart';
import 'package:flutter/material.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  static const name = '/editProfile';

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final ValueNotifier<bool> hasChanges = ValueNotifier(false);
  late final EditProfileController controller;

  @override
  void initState() {
    controller = EditProfileController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            EditProfileAppBar(),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: AppColorsFromTheme.editProfileContainer(context),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    EditProfileTextField(
                      title: 'Full Name',
                      initialValue: 'Hasan Shaaban',
                      controller: controller.fullName,
                    ),
                    Divider(height: 1),
                    EditProfileTextField(
                      title: 'bio',
                      initialValue: 'hsa_hasan',
                      controller: controller.bio,
                    ),

                    Divider(height: 1),
                    EditProfileAccountTypeButton(),

                    Divider(height: 1),
                    RoutedViewRow(title: 'About Me', route: AboutMeView.name),

                    Divider(height: 1),
                    RoutedViewRow(
                      title: 'Academic Experience',
                      route: AcademicExperianceView.name,
                    ),
                    Divider(height: 1),
                    RoutedViewRow(
                      title: 'Contact Information',
                      route: ContactInfoView.name,
                    ),
                    Divider(height: 1),
                    RoutedViewRow(title: 'Skills', route: SkillsView.name),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfileController {
  final fullName = TextEditingController();
  final username = TextEditingController();
  final bio = TextEditingController();
  final about = TextEditingController();
  final services = TextEditingController();

  void dispose() {
    fullName.dispose();
    username.dispose();
    bio.dispose();
    about.dispose();
    services.dispose();
  }
}
