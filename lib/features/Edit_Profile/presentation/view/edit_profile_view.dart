import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/features/Edit_Profile/presentation/manager/cubit/edit_profile_cubit.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/about_me_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/academic_experiance_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/contact_info_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/location_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/skills_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/edit_profile_account_type_button.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/edit_profile_app_bar.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/editable_text.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/location_routed_row.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/routed_view_row.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({
    super.key,
    required this.profileData,
    this.isStore = false,
  });

  final ProfileEntity profileData;
  final bool isStore;

  static const name = '/editProfile';

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late final TextEditingController fullNameController;
  late final TextEditingController bioController;

  void _applyChanges(EditProfileCubit cubit) {
    cubit.updateFullName(fullNameController.text);
    cubit.updateBio(bioController.text);
  }

  Future<bool> _confirmExit(EditProfileCubit cubit) async {
    if (!cubit.state.hasChanges) return true;
    final bool isStore = widget.isStore ||
        widget.profileData.role.toLowerCase().trim() == 'store' ||
        widget.profileData.role.toLowerCase().trim() == 'store account';
    final action = await showDialog<_ExitAction>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved changes'),
        content: const Text('Do you want to save your changes?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, _ExitAction.discard);
            },
            child: const Text('Discard'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, _ExitAction.cancel);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, _ExitAction.save);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (!mounted) return false;
    switch (action) {
      case _ExitAction.save:
        if (!isStore) {
          _applyChanges(cubit);
        }
        cubit.saveProfile();
        return true;
      case _ExitAction.discard:
        cubit.initializeFromProfile(widget.profileData, isStore: widget.isStore);
        return true;
      case _ExitAction.cancel:
      default:
        return false;
    }
  }

  void _handleBack(EditProfileCubit cubit) {
    _confirmExit(cubit).then((shouldPop) {
      if (shouldPop && mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    final cubit = context.read<EditProfileCubit>();
    cubit.initializeFromProfile(widget.profileData, isStore: widget.isStore);
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
    final bool isStore = widget.isStore ||
        widget.profileData.role.toLowerCase().trim() == 'store' ||
        widget.profileData.role.toLowerCase().trim() == 'store account';
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _confirmExit(cubit);
        if (shouldPop && context.mounted) Navigator.pop(context);
      },
      child: Scaffold(
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  EditProfileAppBar(
                    titel: 'Edit Profile',
                    withDoneButton: true,
                    onDone: () {
                      if (!isStore) {
                        _applyChanges(cubit);
                      }

                      context.read<EditProfileCubit>().saveProfile();
                      Navigator.pop(context, true);
                    },
                    onBack: () => _handleBack(cubit),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: AppColorsFromTheme.editProfileContainer(context),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          if (isStore) ...[
                            const RoutedViewRow(
                              title: 'About Us',
                              route: AboutMeView.name,
                            ),
                            const Divider(height: 1),
                            BlocBuilder<EditProfileCubit, EditProfileState>(
                              buildWhen: (prev, next) =>
                                  prev.location != next.location,
                              builder: (context, state) {
                                return LocationRoutedRow(
                                  title: 'Location',
                                  value: state.location,
                                  route: LocationView.name,
                                );
                              },
                            ),
                          ] else ...[
                            EditProfileTextField(
                              hintText: 'Enter your full name',
                              title: 'Full Name',
                              initialValue: fullNameController.text,
                              controller: fullNameController,
                              onChanged: cubit.updateFullName,
                            ),
                            const Divider(height: 1),
                            EditProfileTextField(
                              hintText: 'Enter a bio',
                              title: 'Bio',
                              initialValue: bioController.text,
                              controller: bioController,
                              onChanged: cubit.updateBio,
                            ),
                            const Divider(height: 1),
                            BlocBuilder<EditProfileCubit, EditProfileState>(
                              buildWhen: (prev, next) =>
                                  prev.location != next.location,
                              builder: (context, state) {
                                return LocationRoutedRow(
                                  title: 'Location',
                                  value: state.location,
                                  route: LocationView.name,
                                );
                              },
                            ),
                            const Divider(height: 1),
                            const EditProfileAccountTypeButton(),
                            const Divider(height: 1),
                            const RoutedViewRow(
                              title: 'About Me',
                              route: AboutMeView.name,
                            ),
                            const Divider(height: 1),
                            const RoutedViewRow(
                              title: 'Academic Experience',
                              route: AcademicExperianceView.name,
                            ),
                            const Divider(height: 1),
                            const RoutedViewRow(
                              title: 'Contact Information',
                              route: ContactInfoView.name,
                            ),
                            const Divider(height: 1),
                            const RoutedViewRow(
                              title: 'Skills',
                              route: SkillsView.name,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _ExitAction { save, discard, cancel }
