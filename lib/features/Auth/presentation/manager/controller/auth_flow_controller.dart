
import 'package:archilink/features/Auth/domain/auth_step.dart';
import 'package:flutter/material.dart';

class AuthFlowController extends ChangeNotifier{

  String? selectRole;
  void setRole(String role){
    selectRole = role;
    notifyListeners();
  }

  AuthStep _currentStep = AuthStep.onboarding;
  AuthStep get currentStep => _currentStep;
  void goTo(AuthStep step){
    _currentStep = step;
    notifyListeners();
  }

  void toLogin() => goTo(AuthStep.login);
  void toSignup() => goTo(AuthStep.signup);
  void toSetupAccount() => goTo(AuthStep.setupAccount);
  void toOnBoarding() => goTo(AuthStep.onboarding);
}