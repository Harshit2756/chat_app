import 'package:flutter/material.dart';

import '../colors.dart';

/// Custom Class for Light & textPrimary Text Themes
class HRadioTheme {
  /// Customizable Light Text Theme
  static RadioThemeData lightRadioTheme = RadioThemeData(
    fillColor: WidgetStateColor.resolveWith((states) => HColors.primary),
    overlayColor: WidgetStateColor.resolveWith((states) => HColors.primary.withOpacity(0.1)),
  );

  HRadioTheme._();
}
