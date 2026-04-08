import 'package:archilink/features/Edit_Profile/presentation/manager/cubit/universities_cubit.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/edit_profile_popup_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UniversityPopupField extends StatelessWidget {
  const UniversityPopupField({
    super.key,
    required this.value,
    required this.onSelected,
    this.placeholder = 'Select University',
  });

  final String value;
  final ValueChanged<String> onSelected;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UniversitiesCubit, UniversitiesState>(
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
                      child: CircularProgressIndicator(strokeWidth: 2),
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
                state.failure?.message ?? 'No universities found',
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
          value: value,
          items: const [],
          menuItems: menuItems,
          onSelected: (selected) {
            if (selected.isEmpty) return;
            onSelected(selected);
          },
          placeholder: placeholder,
        );
      },
    );
  }
}
