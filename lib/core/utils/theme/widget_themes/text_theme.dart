import 'package:flutter/material.dart';

import '../colors.dart';

/// Custom Class for Light & textPrimary Text Themes
class HTextTheme {
  /// Customizable Light Text Theme
  static TextTheme lightTextTheme = TextTheme(
    displayLarge: const TextStyle().copyWith(fontSize: 48.0, fontWeight: FontWeight.bold, color: HColors.textPrimary),
    headlineLarge: const TextStyle().copyWith(fontSize: 32.0, fontWeight: FontWeight.bold, color: HColors.textPrimary),
    headlineMedium: const TextStyle().copyWith(fontSize: 24.0, fontWeight: FontWeight.w600, color: HColors.textPrimary),
    headlineSmall: const TextStyle().copyWith(fontSize: 18.0, fontWeight: FontWeight.w600, color: HColors.textPrimary),
    titleLarge: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w600, color: HColors.textPrimary),
    titleMedium: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w500, color: HColors.textPrimary),
    titleSmall: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w400, color: HColors.textPrimary),
    bodyLarge: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w600, color: HColors.textPrimary),
    bodyMedium: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.normal, color: HColors.textPrimary),
    bodySmall: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w500, color: HColors.textPrimary.withValues(alpha: 0.5)),
    labelLarge: const TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.normal, color: HColors.textPrimary),
    labelMedium: const TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.normal, color: HColors.textPrimary.withValues(alpha: 0.5)),
  );

  HTextTheme._();
}
