import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/widgets/auth_button.dart';
import 'package:archilink/core/widgets/auth_text_field.dart';
import 'package:archilink/features/Auth/presentation/manager/controller/auth_flow_controller.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({
    super.key,
    required this.onLoginTap,
    required this.controller,
  });

  final VoidCallback onLoginTap;
  final AuthFlowController controller;

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: height * 41 / 896),
            AuthTextField(
              height: height,
              label: 'Email Address',
              hint: 'email@gmail.com',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              errorText: emailError,
              onChanged: (_) => setState(() => emailError = null),
            ),

            const SizedBox(height: 10),

            AuthTextField(
              height: height,
              label: 'Password',
              hint: 'Your Password',
              controller: passwordController,
              isPassword: true,
              errorText: passwordError,
              onChanged: (_) => setState(() => passwordError = null),
            ),

            const SizedBox(height: 10),

            AuthTextField(
              height: height,
              label: 'Confirm Password',
              hint: 'Your Password',
              controller: confirmPasswordController,
              isPassword: true,
              errorText: confirmPasswordError,
              onChanged: (_) => setState(() => confirmPasswordError = null),
            ),

            const SizedBox(height: 32),

            AuthButton(
              height: height,
              content: Text(
                'Continue',
                style: AppTextStyle.mallannaSemiBold17.copyWith(
                  color: AppColors.whiteForElements,
                ),
              ),
              onPressed: _onContinuePressed,
            ),
          ],
        ),
      ),
    );
  }

  void _onContinuePressed() {
    setState(() {
      emailError = _emailValidator(emailController.text);
      passwordError = _passwordValidator(passwordController.text);
      confirmPasswordError = _confirmPasswordValidator(
        confirmPasswordController.text,
      );
    });

    if (emailError == null &&
        passwordError == null &&
        confirmPasswordError == null) {
      widget.controller.setEmail(emailController.text.trim());
      widget.controller.setPassword(passwordController.text);
      widget.controller.setConfirmPassword(confirmPasswordController.text);
      widget.controller.toSetupAccount();
    }
  }

  String? _emailValidator(String value) {
    if (value.isEmpty) return 'Email is required';
    if (!value.contains('@')) return 'Enter a valid email';
    return null;
  }

  String? _passwordValidator(String value) {
    if (value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Minimum 8 characters';
    return null;
  }

  String? _confirmPasswordValidator(String value) {
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
}
