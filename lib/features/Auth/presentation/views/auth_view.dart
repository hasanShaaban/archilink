import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/features/Auth/domain/auth_step.dart';
import 'package:archilink/features/Auth/presentation/manager/controller/auth_flow_controller.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/auth_cubit.dart';
import 'package:archilink/features/Auth/presentation/views/login_page.dart';
import 'package:archilink/features/Auth/presentation/views/on_boarding_page.dart';
import 'package:archilink/features/Auth/presentation/views/setup_account_page.dart';
import 'package:archilink/features/Auth/presentation/views/sign_up_page.dart';
import 'package:archilink/features/Auth/presentation/views/widgets/auth_background.dart';
import 'package:archilink/features/Auth/presentation/views/widgets/auth_bottom_section.dart';
import 'package:archilink/features/Auth/presentation/views/widgets/auth_top_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  static const String name = '/auth';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthFlowController(),
      child: const AuthViewBody(),
    );
  }
}

class AuthViewBody extends StatelessWidget {
  const AuthViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AuthFlowController>();
    final step = controller.currentStep;

    return BlocProvider(
      create: (context) => sl<AuthCubit>(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              const AuthBackGround(),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                switchInCurve: Curves.easeInExpo,
                switchOutCurve: Curves.easeOutExpo,
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: Column(
                  key: ValueKey(step),
                  children: [
                    TopSection(step: step),
                    _pageContainer(step: step, c: controller),
                    Spacer(),
                    BottomSection(step: step, controller: controller),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _pageContainer({required AuthStep step, required AuthFlowController c}) {
  return LayoutBuilder(
    key: ValueKey(step),
    builder: (context, constraints) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: constraints.maxHeight,
          minHeight: constraints.minHeight,
        ),
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27.5),
            child: _buildStepContent(step, c),
          ),
        ),
      );
    },
  );
}

Widget _buildStepContent(AuthStep step, AuthFlowController c) {
  switch (step) {
    case AuthStep.onboarding:
      return OnBoardingPage(controller: c);

    case AuthStep.login:
      return LoginPage(onSignupPressed: c.toSignup);

    case AuthStep.signup:
      return SignupPage(onLoginTap: c.toLogin, controller: c);

    case AuthStep.setupAccount:
      return SetupAccountPage(c: c);
  }
}
