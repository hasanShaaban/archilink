import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/widgets/auth_button.dart';
import 'package:archilink/core/widgets/auth_text_field.dart';
import 'package:archilink/features/Auth/presentation/manager/controller/auth_flow_controller.dart';
import 'package:archilink/features/Auth/presentation/views/widgets/phone_number_text_field.dart';
import 'package:archilink/features/Auth/presentation/views/widgets/role_drop_down_field.dart';
import 'package:archilink/features/main/presentation/views/main_page.dart';
import 'package:flutter/material.dart';

class SetupAccountPage extends StatelessWidget {
  const SetupAccountPage({super.key, required this.c});

  final AuthFlowController c;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(height: height * 51 / 896),
        // AuthTextFiled(height: height, label: 'Name', hint: 'Your Fall Name'),
        const SizedBox(height: 16),
        // AuthTextFiled(height: height, label: 'Username', hint: 'Your username'),
        const SizedBox(height: 16),
        RoleDropDownField(
          height: height,
          label: 'Role',
          hint: 'Select your role',
          value: c.draft.role,
          options: const [
            'Student Account',
            'Mentor Account',
            'Store Account'
          ],
          onSelected: c.setRole,
        ),
        const SizedBox(height: 16),
        PhoneNumberTextField(height: height),
        SizedBox(height: height * 42 / 896),
        AuthButton(
          height: height,
          content: Text(
            'Sign Up',
            style: AppTextStyle.mallannaSemiBold17.copyWith(
              color: AppColors.whiteForElements,
            ),
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, MainView.name);
          },
        ),
      ],
    );
  }
}
