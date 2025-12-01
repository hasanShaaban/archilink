import 'package:archilink/features/Auth/domain/auth_step.dart';
import 'package:archilink/features/Auth/presentation/manager/controller/auth_flow_controller.dart';
import 'package:archilink/features/Auth/presentation/views/login_page.dart';
import 'package:archilink/features/Auth/presentation/views/on_boarding_page.dart' show OnBoardingPage;
import 'package:archilink/features/Auth/presentation/views/setup_account_page.dart';
import 'package:archilink/features/Auth/presentation/views/sign_up_page.dart';
import 'package:archilink/features/Auth/presentation/views/widgets/auth_background.dart';
import 'package:flutter/material.dart';
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

    final controller = Provider.of<AuthFlowController>(context);
    final step = controller.currentStep;

    return Scaffold(
      body: SafeArea(child: Stack(children: [
        const AuthBackGround(),

        Center(
          child: AnimatedSwitcher(duration: const Duration(milliseconds: 800),
          transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child,),
          child: _buildStep(step, controller),
          ),
        )

      ])),
    );
  }
}

Widget _buildStep(AuthStep step, AuthFlowController c){
  switch(step){
    case AuthStep.onboarding:
      return OnBoardingPage(
        onLoginPressed: c.toLogin,
        onSignupPressed: c.toSignup,
      );
    case AuthStep.login:
      return LoginPage();
    case AuthStep.signup:
      return SignupPage();
    case AuthStep.setupAccount:
      return SetupAccountPage();
    
  }
}





