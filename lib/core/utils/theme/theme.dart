import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';
import 'widget_themes/appbar_theme.dart';
import 'widget_themes/bottom_sheet_theme.dart';
import 'widget_themes/checkbox_theme.dart';
import 'widget_themes/chip_theme.dart';
import 'widget_themes/elevated_button_theme.dart';
import 'widget_themes/radio_theme.dart';
import 'widget_themes/segmented_button_theme.dart';
import 'widget_themes/text_theme.dart';

class HAppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.exo().fontFamily,
    colorScheme: ColorScheme.fromSeed(seedColor: HColors.primary, secondary: HColors.secondary),
    disabledColor: HColors.grey,
    brightness: Brightness.light,
    primaryColor: HColors.primary,
    textTheme: HTextTheme.lightTextTheme,
    chipTheme: HChipTheme.lightChipTheme,
    scaffoldBackgroundColor: HColors.white,
    appBarTheme: HAppBarTheme.lightAppBarTheme,
    checkboxTheme: HCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: HBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: HElevatedButtonTheme.lightElevatedButtonTheme,
    segmentedButtonTheme: HSegmentedButtonTheme.lightSegmentedButtonTheme,
    radioTheme: HRadioTheme.lightRadioTheme,
  );

  HAppTheme._();
}
