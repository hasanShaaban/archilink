import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/features/Edit_Profile/presentation/manager/cubit/edit_profile_cubit.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/about_me_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/academic_experiance_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/contact_info_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/skills_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/edit_profile_account_type_button.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/edit_profile_app_bar.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/editable_text.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/routed_view_row.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key, required this.profileData});

  final ProfileEntity profileData;

  static const name = '/editProfile';

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late final TextEditingController fullNameController;
  late final TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<EditProfileCubit>();
    cubit.initializeFromProfile(widget.profileData);
    final state = cubit.state;
    fullNameController = TextEditingController(text: state.fullName);
    bioController = TextEditingController(text: state.bio);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditProfileCubit>();
    return Scaffold(
      body: SafeArea(
        child: BlocListener<EditProfileCubit, EditProfileState>(
          listenWhen: (prev, next) =>
              prev.fullName != next.fullName || prev.bio != next.bio,
          listener: (context, state) {
            if (fullNameController.text != state.fullName) {
              fullNameController.text = state.fullName;
            }
            if (bioController.text != state.bio) {
              bioController.text = state.bio;
            }
          },
          child: Column(
            children: [
              EditProfileAppBar(titel: 'Edit Profile', withDoneButton: true,),
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
                        hintText: 'Enter your full name',
                        title: 'Full Name',
                        initialValue: fullNameController.text,
                        controller: fullNameController,
                        onChanged: cubit.updateFullName,
                      ),
                      Divider(height: 1),
                      EditProfileTextField(
                        hintText: 'Enter a bio',
                        title: 'bio',
                        initialValue: bioController.text,
                        controller: bioController,
                        onChanged: cubit.updateBio,
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
      ),
    );
  }
}
