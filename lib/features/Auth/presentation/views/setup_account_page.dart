import 'dart:async';

import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/widgets/auth_button.dart';
import 'package:archilink/core/widgets/auth_text_field.dart';
import 'package:archilink/features/Auth/domain/entity/signup_draft.dart';
import 'package:archilink/features/Auth/presentation/manager/controller/auth_flow_controller.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/auth_cubit.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/check_username_cubit.dart';
import 'package:archilink/features/Auth/presentation/views/widgets/phone_number_text_field.dart';
import 'package:archilink/features/Auth/presentation/views/widgets/role_drop_down_field.dart';
import 'package:archilink/features/main/presentation/views/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SetupAccountPage extends StatefulWidget {
  const SetupAccountPage({super.key, required this.c});

  final AuthFlowController c;

  @override
  State<SetupAccountPage> createState() => _SetupAccountPageState();
}

class _SetupAccountPageState extends State<SetupAccountPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  bool isUsernameTaken = false;

  String? fullNameError, usernameError;

  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void dispose() {
    _usernameDebounce?.cancel();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
         if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, MainView.name);
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          autovalidateMode: autovalidateMode,
          child: Column(
            children: [
              SizedBox(height: height * 51 / 896),
              AuthTextField(
                height: height,
                label: 'Name',
                hint: 'Your Full Name',
                controller: nameController,
                keyboardType: TextInputType.name,
                errorText: fullNameError,
                onChanged: (_) => setState(() => fullNameError = null),
              ),
              const SizedBox(height: 10),
              AuthUsernameField(
                height: height,
                label: 'Username',
                hint: 'Your username',
                controller: usernameController,
                isUsernameTaken: isUsernameTaken,
                onChanged: onUsernameChanged,
                errorText: usernameError,
              ),
              const SizedBox(height: 10),
              RoleDropDownField(
                autovalidateMode: autovalidateMode,
                height: height,
                label: 'Role',
                hint: 'Select your role',
                value: widget.c.draft.role,
                options: const [
                  'Student Account',
                  'Mentor Account',
                  'Store Account',
                ],
                onSelected: widget.c.setRole,
                validator: _roleValidator,
              ),
              const SizedBox(height: 10),
              PhoneNumberTextField(height: height, controler: phoneController),
              SizedBox(height: height * 42 / 896),
              AuthButton(
                height: height,
                content: Text(
                  'Sign Up',
                  style: AppTextStyle.mallannaSemiBold17.copyWith(
                    color: AppColors.whiteForElements,
                  ),
                ),
                onPressed: _onSignUpPressed,
              ),
            ],
          ),
        );
      },
    );
  }

  void _onSignUpPressed() {
    // 1. Enable auto-validation FIRST
    setState(() {
      autovalidateMode = AutovalidateMode.always;
    });

    // 2. Manually validate non-FormField inputs
    fullNameError = _nameValidator(nameController.text);
    usernameError = _usernameValidator(usernameController.text);

    // 3. Trigger rebuild for manual errors
    setState(() {});

    // 4. Validate FormFields (Role dropdown)
    final isFormValid = _formKey.currentState!.validate();

    // 5. Final decision
    if (isFormValid && fullNameError == null && usernameError == null) {
      _formKey.currentState!.save();
      SignupDraft draft = widget.c.draft;
      BlocProvider.of<AuthCubit>(context).register(
        email: draft.email!,
        password: draft.password!,
        confirmPassword: draft.confirmPassword!,
        name: nameController.text,
        username: usernameController.text,
        role: widget.c.draft.role!,
        phone: phoneController.text,
      );
      // submit
    }
  }

  String? _roleValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This filed is required';
    }
    return null;
  }

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This filed is required';
    }
    return null;
  }

  String? _usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This filed is required';
    }
    return null;
  }

  Timer? _usernameDebounce;
  void onUsernameChanged(String value) {
    setState(() {
      usernameError = null;
    });
    _usernameDebounce?.cancel();

    _usernameDebounce = Timer(const Duration(milliseconds: 500), () {
      context.read<CheckUsernameCubit>().checkUsername(username: value);
    });
  }
}

List<String> usernames = ['hasan', 'hasson1', 'hasson2', 'hhhh'];
