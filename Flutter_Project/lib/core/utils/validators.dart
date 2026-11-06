class Validators {
  static String? required(String? value, [String message = 'This field is required']) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? rating(int? value) {
    if (value == null) {
      return 'Rating is required';
    }
    if (value < 1 || value > 10) {
      return 'Rating must be between 1 and 10';
    }
    return null;
  }

  /// Calculates drill accuracy safely without division-by-zero
  static double calculateAccuracy(int successfulAttempts, int totalAttempts) {
    if (totalAttempts <= 0) return 0.0;
    if (successfulAttempts < 0) return 0.0;
    if (successfulAttempts > totalAttempts) return 100.0;
    return (successfulAttempts / totalAttempts) * 100.0;
  }

  static String? drillAttempts(int? total, int? successful) {
    if (total == null || total < 0) {
      return 'Total attempts cannot be negative';
    }
    if (successful == null || successful < 0) {
      return 'Successful attempts cannot be negative';
    }
    if (successful > total) {
      return 'Successful attempts cannot exceed total attempts';
    }
    return null;
  }

  static String? dateRange(DateTime? start, DateTime? end) {
    if (start != null && end != null && end.isBefore(start)) {
      return 'End date cannot be earlier than start date';
    }
    return null;
  }
}
