import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/features/Edit_Profile/presentation/manager/cubit/edit_profile_cubit.dart';
import 'package:archilink/features/Edit_Profile/presentation/manager/cubit/universities_cubit.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/edit_profile_app_bar.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/editable_text.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/edit_profile_popup_field.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/university_popup_field.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/year_picker_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAcademicExperianceView extends StatefulWidget {
  const AddAcademicExperianceView({
    super.key,
    this.initialExperience,
    this.editIndex,
  });

  static const String name = '/addAcademicExperianceView';

  final AcademicExperience? initialExperience;
  final int? editIndex;

  @override
  State<AddAcademicExperianceView> createState() =>
      _AddAcademicExperianceViewState();
}

class _AddAcademicExperianceViewState extends State<AddAcademicExperianceView> {
  String selectedUniversity = '';
  String selectedDegree = '';
  late final TextEditingController fieldOfStudyController;
  int? selectedStartYear;
  int? selectedEndYear;

  final List<String> degrees = const ['Associate', 'Bachelor', 'Master', 'PhD'];
  static const String _fieldOfStudyPlaceholder = 'Enter your Major';

  @override
  void initState() {
    super.initState();
    context.read<UniversitiesCubit>().loadUniversities();
    final initial = widget.initialExperience;
    selectedUniversity = initial?.university ?? '';
    selectedDegree = initial?.degree ?? '';
    selectedStartYear = initial?.startYear;
    selectedEndYear = initial?.endYear;
    fieldOfStudyController = TextEditingController(
      text: initial?.fieldOfStudy ?? _fieldOfStudyPlaceholder,
    );
  }

  @override
  void dispose() {
    fieldOfStudyController.dispose();
    super.dispose();
  }

  void _handleDone() {
    final cubit = context.read<EditProfileCubit>();
    final experience = AcademicExperience(
      university: selectedUniversity,
      degree: selectedDegree,
      fieldOfStudy: fieldOfStudyController.text.trim(),
      startYear: selectedStartYear ??
          widget.initialExperience?.startYear ??
          DateTime.now().year,
      endYear: selectedEndYear ?? widget.initialExperience?.endYear,
    );
    final editIndex = widget.editIndex;
    if (editIndex != null) {
      cubit.updateAcademicExperience(editIndex, experience);
    } else {
      cubit.addAcademicExperience(experience);
    }
    Navigator.pop(context);
  }

  bool _isFormValid() {
    final field = fieldOfStudyController.text.trim();
    final isFieldValid =
        field.isNotEmpty && field != _fieldOfStudyPlaceholder;
    return selectedUniversity.isNotEmpty &&
        selectedDegree.isNotEmpty &&
        isFieldValid &&
        selectedStartYear != null;
  }

  Future<void> _showYearPicker({
    required int? currentYear,
    required ValueChanged<int> onPicked,
  }) async {
    final now = DateTime.now();

    final picked = await showDialog<int>(
      context: context,
      builder: (ctx) {
        int tempYear = currentYear ?? now.year;

        return AlertDialog(
          backgroundColor: AppColorsFromTheme.editProfileContainer(context),
          title: const Text('Select Year'),
          content: SizedBox(
            width: 300,
            height: 300,
            child: StatefulBuilder(
              builder: (context, setInnerState) => YearPicker(
                firstDate: DateTime(1950),
                lastDate: DateTime(now.year + 10),
                selectedDate: DateTime(tempYear),
                onChanged: (date) {
                  setInnerState(() => tempYear = date.year);
                  Navigator.pop(ctx, tempYear);
                },
              ),
            ),
          ),
        );
      },
    );

    if (picked != null) {
      setState(() => onPicked(picked));
      context.read<EditProfileCubit>().markHasChanges();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            EditProfileAppBar(
              titel: widget.editIndex == null
                  ? 'Add Academic Experience'
                  : 'Edit Academic Experience',
              withDoneButton: true,
              onDone: _handleDone,
              canSubmitOverride: _isFormValid(),
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
                    UniversityPopupField(
                      value: selectedUniversity,
                      onSelected: (value) {
                        setState(() {
                          selectedUniversity = value;
                          context.read<EditProfileCubit>().markHasChanges();
                        });
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
                          context.read<EditProfileCubit>().markHasChanges();
                        });
                      },
                      placeholder: 'Select Degree',
                    ),
                    Divider(height: 1),
                    EditProfileTextField(
                      title: 'Field of Study',
                      initialValue: fieldOfStudyController.text,
                      controller: fieldOfStudyController,
                      onChanged: (_) {
                        setState(() {});
                        context.read<EditProfileCubit>().markHasChanges();
                      },
                    ),
                    Divider(height: 1),
                    YearPickerRow(
                      title: 'Start year',
                      valueText:
                          selectedStartYear?.toString() ?? 'Select Year',
                      onTap: () => _showYearPicker(
                        currentYear: selectedStartYear,
                        onPicked: (value) => selectedStartYear = value,
                      ),
                    ),
                    Divider(height: 1),
                    YearPickerRow(
                      title: 'End year',
                      valueText: selectedEndYear?.toString() ?? 'Present',
                      onTap: () => _showYearPicker(
                        currentYear: selectedEndYear,
                        onPicked: (value) => selectedEndYear = value,
                      ),
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
