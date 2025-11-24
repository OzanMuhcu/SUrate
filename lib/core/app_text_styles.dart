import 'package:flutter/material.dart';

class AppTextStyles {
  static const heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const caption = TextStyle(
    fontSize: 12,
    color: Colors.black54,
  );

  static TextTheme get textTheme {
    return const TextTheme(
      headlineSmall: heading1,
      titleMedium: heading2,
      bodyMedium: body,
      bodySmall: caption,
    );
  }
}

