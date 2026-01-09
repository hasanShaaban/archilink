import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/core/widgets/auth_button.dart';
import 'package:archilink/core/widgets/auth_text_field.dart';
import 'package:archilink/features/Auth/presentation/manager/controller/auth_flow_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Form(
      key: _formKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: height * 37 / 896),
          AuthTextFiled(
            height: height,
            label: 'Email​ Address',
            hint: 'email@gmail.com',
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            validator: _emailValidator,
            onSaved: (value) {
              widget.controller.setEmail(emailController.text.trim());
            },
          ),
          SizedBox(height: 16),
          AuthTextFiled(
            height: height,
            label: 'Password',
            hint: 'Your Password',
            isPassword: true,
            controller: passwordController,
            validator: _passwordValidator,
            onSaved: (value) {
              widget.controller.setPassword(passwordController.text);
            },
          ),
          SizedBox(height: 16),
          AuthTextFiled(
            height: height,
            label: 'Confirm Password',
            hint: 'Your Password',
            isPassword: true,
            controller: confirmPasswordController,
            validator: _confirmPasswordValidator,
            onSaved: (value) {
              widget.controller.setConfirmPassword(
                confirmPasswordController.text,
              );
            },
          ),
          SizedBox(height: height * 42 / 896),
          AuthButton(
            height: height,
            content: Text(
              'Continue',
              style: AppTextStyle.mallannaSemiBold17.copyWith(
                color: AppColors.whiteForElements,
              ),
            ),
            onPressed: _onPressed,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: AppColorsFromTheme.lightGray(context),
                  thickness: 0.5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 19),
                child: Text(
                  'Or With',
                  style: AppTextStyle.mallannaSemiBold14.copyWith(
                    color: AppColorsFromTheme.lightGray(context),
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: AppColorsFromTheme.lightGray(context),
                  thickness: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          AuthButton(
            height: height,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  Assets.assetsIconsGoogle,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                const SizedBox(width: 10),
                Text(
                  'Google',
                  style: AppTextStyle.mallannaSemiBold14.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            onPressed: () {},
            secondary: true,
          ),
        ],
      ),
    );
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@')) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != passwordController.text) {
      return 'you passwords do not match';
    }
    return null;
  }

  void _onPressed() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.controller.toSetupAccount();
    } else {
      autovalidateMode = AutovalidateMode.always;
      setState(() {});
    }
  }
}
