import 'package:archilink/features/Auth/domain/auth_step.dart';
import 'package:archilink/features/Auth/domain/entity/signup_draft.dart';
import 'package:flutter/material.dart';

class AuthFlowController extends ChangeNotifier {
  final SignupDraft draft = SignupDraft();

  AuthStep _currentStep = AuthStep.onboarding;
  AuthStep get currentStep => _currentStep;

  void goTo(AuthStep step) {
    _currentStep = step;
    notifyListeners();
  }

  void setEmail(String email) {
    draft.email = email;
  }

  void setPassword(String password) {
    draft.password = password;
  }

  void setConfirmPassword(String password) {
    draft.confirmPassword = password;
  }

  void setName(String name) {
    draft.name = name;
  }

  void setUsername(String username) {
    draft.username = username;
  }

  void setPhone(String phoneNumber) {
    draft.phone = phoneNumber;
  }

  void setRole(String role) {
    if (role == 'Student Account') {
      draft.role = 'student';
      notifyListeners();
    } else if (role == 'Mentor Account') {
      draft.role = 'mentor';
      notifyListeners();
    } else {
      draft.role = role;
      notifyListeners();
    }
  }

  void toLogin() => goTo(AuthStep.login);
  void toSignup() => goTo(AuthStep.signup);
  void toSetupAccount() => goTo(AuthStep.setupAccount);
  void toOnBoarding() => goTo(AuthStep.onboarding);
}
