import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/features/Edit_Profile/presentation/manager/cubit/universities_cubit.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/edit_profile_app_bar.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/edit_profile_popup_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAcademicExperianceView extends StatefulWidget {
  const AddAcademicExperianceView({super.key});

  static const String name = '/addAcademicExperianceView';

  @override
  State<AddAcademicExperianceView> createState() =>
      _AddAcademicExperianceViewState();
}

class _AddAcademicExperianceViewState extends State<AddAcademicExperianceView> {
  String selectedUniversity = '';
  String selectedDegree = '';

  final List<String> degrees = const ['Associate', 'Bachelor', 'Master', 'PhD'];

  @override
  void initState() {
    super.initState();
    context.read<UniversitiesCubit>().loadUniversities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const EditProfileAppBar(
              titel: 'Add Academic Experience',
              withDoneButton: true,
            ),
            Padding(
              padding: const EdgeInsetsGeometry.symmetric(horizontal: 20),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColorsFromTheme.editProfileContainer(context),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    BlocBuilder<UniversitiesCubit, UniversitiesState>(
                      builder: (context, state) {
                        final menuItems = <PopupMenuEntry<String>>[];
                        if (state.isLoading) {
                          menuItems.add(
                            const PopupMenuItem(
                              enabled: false,
                              value: '',
                              child: SizedBox(
                                height: 20,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text('Loading...'),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else if (state.universities.isEmpty) {
                          menuItems.add(
                            PopupMenuItem(
                              enabled: false,
                              value: '',
                              child: Text(
                                state.failure?.message ??
                                    'No universities found',
                              ),
                            ),
                          );
                        } else {
                          menuItems.addAll(
                            state.universities.map(
                              (uni) => PopupMenuItem(
                                value: uni.name,
                                child: Text(uni.name),
                              ),
                            ),
                          );
                        }

                        return EditProfilePopupField(
                          title: 'University',
                          value: selectedUniversity,
                          items: const [],
                          menuItems: menuItems,
                          onSelected: (value) {
                            if (value.isEmpty) return;
                            setState(() {
                              selectedUniversity = value;
                            });
                          },
                          placeholder: 'Select University',
                        );
                      },
                    ),
                    Divider(height: 1),
                    EditProfilePopupField(
                      title: 'Degree',
                      value: selectedDegree,
                      items: degrees,
                      onSelected: (value) {
                        setState(() {
                          selectedDegree = value;
                        });
                      },
                      placeholder: 'Select Degree',
                    ),
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
