import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/features/Auth/presentation/manager/controller/auth_flow_controller.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/check_username_cubit.dart';
import 'package:archilink/features/Auth/presentation/views/widgets/auth_view_body_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthViewBody extends StatelessWidget {
  const AuthViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AuthFlowController>();
    final step = controller.currentStep;

    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => sl<CheckUsernameCubit>())],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: AuthViewBodyStack(step: step, controller: controller),
        ),
      ),
    );
  }
}
