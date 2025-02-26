import 'package:flutter/material.dart';

import '../colors.dart';

class HInputDecorations {
  static InputDecoration defaultDecoration({String? hintText, Widget? suffixIcon, bool isFocused = false}) {
    return InputDecoration(
      filled: isFocused,
      hintText: hintText,
      suffixIcon: suffixIcon,

      fillColor: HColors.secondary.withValues(alpha: 0.6),
      hintStyle: TextStyle(color: isFocused ? HColors.textPrimary : HColors.textTertiary),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: HColors.borderSecondary)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: HColors.borderSecondary)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: HColors.primary)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: HColors.error)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: HColors.error)),
    );
  }

  static InputDecoration phoneInputDecoration({String? hintText, bool isFocused = false}) {
    return defaultDecoration(hintText: hintText, isFocused: isFocused).copyWith(counterText: '', contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16));
  }
}
