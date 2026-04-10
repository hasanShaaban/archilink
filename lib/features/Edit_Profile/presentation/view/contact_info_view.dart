import 'package:archilink/features/Edit_Profile/presentation/view/add_contact_info_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/contact_info_cards_list_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/edit_profile_add_button.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/edit_profile_app_bar.dart';
import 'package:flutter/material.dart';

class ContactInfoView extends StatelessWidget {
  const ContactInfoView({super.key});
  static const name = '/contactInfo';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            EditProfileAppBar(
              titel: 'Contact info',
              withDoneButton: false,
              backButtonIcon: Icons.arrow_back_ios_new_rounded,
            ),
            SizedBox(height: 8),
            EditProfileAddButton(
              onPressed: () {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamed(AddContactInfoView.name);
              },
              title: 'Add Contact',
            ),
            SizedBox(height: 8),
            ContactInfoCardsListView(),
          ],
        ),
      ),
    );
  }
}
