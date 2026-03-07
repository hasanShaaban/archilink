class ValidationErrorResponse {
  final String message;
  final Map<String, List<String>> errors;

  ValidationErrorResponse({required this.message, required this.errors});

  factory ValidationErrorResponse.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> rawErrors = json["errors"] ?? {};
    return ValidationErrorResponse(
      message: json["message"] ?? '',
      errors: rawErrors.map(
        (key, value) => MapEntry(key, List<String>.from(value)),
      ),
    );
  }
}
