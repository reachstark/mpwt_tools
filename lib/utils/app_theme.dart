import 'package:estimation_list_generator/utils/strings.dart';

import 'app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  /// LIGHT THEME
  static ThemeData lightTheme = ThemeData(
    fontFamily: dangrek,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    useMaterial3: true,
    colorScheme: const ColorScheme.light(primary: AppColors.primaryLight),

    /// DROPDOWNMENU
    dropdownMenuTheme: const DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        hintStyle: TextStyle(
          color: Colors.black38,
        ),
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(
          AppColors.backgroundLight,
        ),
      ),
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: AppColors.backgroundLight,
      elevation: 0.0,
    ),

    /// APP BAR
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.backgroundLight,
    ),

    /// DATE PICKER
    datePickerTheme: const DatePickerThemeData(
      headerBackgroundColor: AppColors.primaryLight,
      headerForegroundColor: AppColors.backgroundLight,
      surfaceTintColor: Colors.transparent,
      dividerColor: AppColors.primaryLight,
    ),

    /// TEXT BUTTON
    textButtonTheme: const TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStatePropertyAll(AppColors.backgroundLight),
        foregroundColor: WidgetStatePropertyAll(
          AppColors.primaryLight,
        ),
      ),
    ),

    /// TIME PICKER
    timePickerTheme: const TimePickerThemeData(
      dialHandColor: AppColors.secondaryLight,
      // hourMinuteColor: AppColors.primaryLight,
      dayPeriodColor: AppColors.primaryLight,
    ),

    /// NAVIGATION BAR
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: AppColors.backgroundLight,
      indicatorColor: AppColors.primaryLight,
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    ),

    /// PROGRESS INDICATOR
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primaryLight,
      linearTrackColor: AppColors.backgroundLight,
      year2023: false,
    ),

    /// FLOATING ACTION BUTTON
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryLight,
    ),

    /// SWITCH
    switchTheme: const SwitchThemeData(
      thumbColor: WidgetStatePropertyAll(
        AppColors.primaryLight,
      ),
      trackColor: WidgetStatePropertyAll(
        AppColors.white,
      ),
      trackOutlineColor: WidgetStateColor.transparent,
    ),

    /// ELEVATED BUTTON
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.white,
      ),
    ),

    /// SEARCH BAR
    searchBarTheme: const SearchBarThemeData(
      backgroundColor: WidgetStatePropertyAll(AppColors.backgroundLight),
      textStyle: WidgetStatePropertyAll(
        TextStyle(
          fontFamily: dangrek,
          color: AppColors.primaryLight,
        ),
      ),
      hintStyle: WidgetStatePropertyAll(
        TextStyle(
          fontFamily: dangrek,
          color: AppColors.primaryLight,
        ),
      ),
    ),

    /// TEXT INPUT DECORATION
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xffF5F5F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // Soft rounded edges
        borderSide: BorderSide.none, // No harsh border
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.primaryLight, // Border color when focused
          width: 1.5,
        ),
      ),
      hintStyle: const TextStyle(
        fontFamily: dangrek,
        color: Colors.black38, // Hint text color
      ),
      errorStyle: const TextStyle(
        color: AppColors.cosmicRed, // Error text color
      ),
      labelStyle: const TextStyle(
        color: AppColors.primaryLight, // Label text color
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      iconColor: AppColors.primaryLight,
      // Add box shadows for the neumorphic effect
    ),

    /// DIALOG
    dialogTheme: const DialogTheme(
      elevation: 0.0,
      backgroundColor: AppColors.backgroundLight,
      titleTextStyle: TextStyle(
        color: Color(0xFF14213D),
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
    ),

    /// CARD
    cardColor: AppColors.backgroundLight,

    /// CHECKBOX
    checkboxTheme: const CheckboxThemeData(
      fillColor: WidgetStatePropertyAll(AppColors.primaryLight),
      shape: CircleBorder(
        side: BorderSide(
          color: AppColors.primaryLight,
        ),
      ),
    ),

    /// SEGMENTED BUTTON
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primaryLight;
            } else {
              return Colors.transparent;
            }
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.white;
            } else {
              return AppColors.secondaryLight;
            }
          },
        ),
      ),
    ),

    /// LIST TILE
    listTileTheme: ListTileThemeData(
      tileColor: Colors.blue[100],
    ),

    /// SLIDER
    sliderTheme: SliderThemeData(
      thumbColor: AppColors.primaryLight,
      activeTrackColor: AppColors.primaryLight,
      secondaryActiveTrackColor: AppColors.primaryLight.withOpacity(0.5),
      overlayColor: AppColors.primaryLight.withOpacity(0.3),
      inactiveTrackColor: AppColors.backgroundLight,
    ),

    /// BOTTOM SHEET
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.backgroundLight,
    ),
  );

  /// ========================================================================== ///

  /// DARK THEME
  static ThemeData darkTheme = ThemeData(
    fontFamily: dangrek,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryLight,
      secondary: AppColors.secondaryLight,
      surface: AppColors.backgroundLight,
      error: AppColors.cosmicRed, // Define an error color
      onPrimary: AppColors.backgroundLight, // Text/icon color on primary color
      onSecondary:
          AppColors.backgroundLight, // Text/icon color on secondary color
      onSurface: AppColors.white, // Text/icon color on background color
      onError: AppColors.backgroundLight, // Text/icon color on error color
    ),
  );
}

List<BoxShadow> get fadeShadow {
  return const [
    BoxShadow(
      color: Color.fromARGB(31, 170, 170, 170),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];
}

List<BoxShadow> get blurShadow {
  return [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      spreadRadius: 1,
      blurRadius: 5,
      offset: const Offset(0, 2),
    ),
  ];
}
