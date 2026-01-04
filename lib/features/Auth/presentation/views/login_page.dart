
import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/widgets/auth_button.dart';
import 'package:archilink/core/widgets/auth_text_field.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/auth_cubit.dart';
import 'package:archilink/features/Auth/presentation/views/widgets/remember_me_section.dart';
import 'package:archilink/features/main/presentation/views/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onSignupPressed});

  final VoidCallback onSignupPressed;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if(state is AuthAuthenticated){
          Navigator.pushReplacementNamed(context, MainView.name);
        }
        if(state is AuthError){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 51 / 896),
                  AuthTextFiled(
                    height: height,
                    label: 'Email​ Address',
                    hint: 'email@gmail.com',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: _emailValidator,
                  ),
                  SizedBox(height: 16),
                  AuthTextFiled(
                    height: height,
                    label: 'Password',
                    hint: 'Your Password',
                    isPassword: true,
                    controller: passwordController,
                    validator: _passwordValidator,
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
                  SizedBox(height: height * 42 / 896),
                  AuthButton(
                    onPressed: _onLoginPressed,
                    height: height,
                    content: Text(
                      'Login',
                      style: AppTextStyle.mallannaSemiBold17.copyWith(
                        color: AppColors.whiteForElements,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            state is AuthLoading ? Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.darkGray.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: CircularProgressIndicator()),
              ),
            ) : SizedBox(),
          ],
        );
      },
    );
  }

  void _onLoginPressed() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthCubit>().login(
      email: emailController.text.trim(),
      password: passwordController.text,
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
}
