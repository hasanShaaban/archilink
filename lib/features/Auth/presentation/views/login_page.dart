import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/widgets/auth_button.dart';
import 'package:archilink/core/widgets/auth_text_field.dart';
import 'package:archilink/features/Auth/presentation/views/widgets/remember_me_section.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, required this.onSignupPressed});

  final VoidCallback onSignupPressed;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: height * 51 / 896),
        AuthTextFiled(
          height: height,
          label: 'Email​ Address',
          hint: 'email@gmail.com',
        ),
        SizedBox(height: 16),
        AuthTextFiled(
          height: height,
          label: 'Password',
          hint: 'Your Password',
          isPassword: true,
        ),
        SizedBox(height: 16),
        Row(
          children: [
            RememberMeSection(),
            Spacer(),
            Text(
              'Forgot Password?',
              style: AppTextStyle.mallannaSemiBold14.copyWith(
                color: AppColors.red,
              ),
            ),
          ],
        ),
        SizedBox(height: height * 42 / 896,),
        AuthButton(
        onPressed: (){},
        height: height,
        content: Text(
          'Login',
          style: AppTextStyle.mallannaSemiBold17.copyWith(
            color: AppColors.whiteForElements,
          ),
        ),
        
      ),Spacer()
      ],
    );
  }
}


