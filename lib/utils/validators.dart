bool isNotEmpty(String? value) => value != null && value.trim().isNotEmpty;

String? validateRequired(String? value, String fieldName) {
  if (value == null || value.trim().isEmpty) {
    return ' A0$fieldName is required';
  }
  return null;
} 