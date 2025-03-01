import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_flip/utils/colors.dart';
import 'package:pin_flip/data/pin_flip_options.dart';
import 'package:pin_flip/layout/letter_spacing.dart';

ThemeData buildPinFlipTheme() {
  final base = ThemeData.dark();
  return ThemeData(
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      elevation: 0,
    ),
    scaffoldBackgroundColor: PinFlipColors.primaryBackground,
    primaryColor: PinFlipColors.primaryBackground,
    focusColor: PinFlipColors.focusColor,
    textTheme: buildPinFlipTextTheme(base.textTheme),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
        color: PinFlipColors.gray,
        fontWeight: FontWeight.w500,
        fontSize: 18,
      ),
      filled: true,
      fillColor: PinFlipColors.inputBackground,
      focusedBorder: InputBorder.none,
    ),
    visualDensity: VisualDensity.standard,
  );
}

TextTheme buildPinFlipTextTheme(TextTheme base) {
  return base
      .copyWith(
        bodyMedium: deviceLocale?.languageCode == 'ar'
            ? const TextStyle(
                fontFamily: 'NotoKufiArabic',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              )
            : TextStyle(
                fontFamily: 'Eczar', // Keep this if you have it defined
                fontSize: 14,
                fontWeight: FontWeight.w400,
                letterSpacing: letterSpacingOrNone(0.5),
              ),
        bodyLarge: deviceLocale?.languageCode == 'ar'
            ? const TextStyle(
                fontFamily: 'NotoKufiArabic',
                fontSize: 24,
                fontWeight: FontWeight.w400,
              )
            : TextStyle(
                fontFamily: 'Eczar',
                fontSize: 24,
                fontWeight: FontWeight.w400,
                letterSpacing: letterSpacingOrNone(1.4),
              ),
        labelLarge: deviceLocale?.languageCode == 'ar'
            ? const TextStyle(
                fontFamily: 'NotoKufiArabic',
                fontWeight: FontWeight.w700,
              )
            : TextStyle(
                fontFamily: 'Eczar', // Keep this if you have it defined
                fontWeight: FontWeight.w700,
                letterSpacing: letterSpacingOrNone(2.8),
              ),
        headlineSmall: deviceLocale?.languageCode == 'ar'
            ? const TextStyle(
                fontFamily: 'NotoKufiArabic',
                fontSize: 24,
                fontWeight: FontWeight.w600,
              )
            : TextStyle(
                fontFamily: 'Eczar',
                fontSize: 24,
                fontWeight: FontWeight.w600,
                letterSpacing: letterSpacingOrNone(1.4),
              ),
      )
      .apply(
        displayColor: Colors.white,
        bodyColor: Colors.white,
      );
}
