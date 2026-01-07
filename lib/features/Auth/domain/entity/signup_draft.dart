class SignupDraft {
  String? email;
  String? password;
  String? confirmPassword;
  String? name;
  String? username;
  String? phone;
  String? role;

  bool get isStepValid =>
      email != null && password != null && confirmPassword != null;

  bool get isComplete =>
      email != null &&
      password != null &&
      confirmPassword != null &&
      name != null &&
      username != null &&
      phone != null &&
      role != null;
}
