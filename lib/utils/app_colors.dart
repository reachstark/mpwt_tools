import 'package:flutter/material.dart';

class AppColors {
  // Primary and Accent Colors (Light)
  static const Color backgroundLight = Color(0xFF7C93C3);
  static const Color primaryLight = Color(0xFF1E2A5E);
  static const Color secondaryLight = Color(0xFF55679C);
  // Primary and Accent Colors (Dark)
  static const Color backgroundDark = Color(0xFF094074);
  static const Color primaryDark = Color(0xFF3C6997);
  static const Color secondaryDark = Color(0xFF013a63);

  static const Color mpwtRed = Color(0xFFD00800);
  static const Color mpwtYellow = Color(0xFFF0B050);

  static const Color darkBlueGray = Color(0xFF01172F);
  static const Color spaceCadet = Color(0xFF1d2951);
  static const Color pantoneBlue = Color(0xFF003049);
  static const Color gentianBlue = Color(0xFF0e294b);
  static const Color lighterBlue = Color(0xFF8ecae6);
  static const Color darkerRed = Color(0xFF950000);
  static const Color lighterRed = Color(0xFFFF3333);
  static const Color cosmicRed = Color(0xFFE63946);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color midnightBlue = Color(0xFF0B2447);
  static const Color vibrantOrange = Color(0xFFFCA311);
  static const Color vibrantGreen = Color(0xFF2ec4b6);
  static const Color lightGrayish = Color(0xFFEDF2F4);
  static const Color crayolaColor = Color(0xFFF25F5C);
  static const Color sunsetPink = Color(0xFFF78DA7);
  static const Color coralPink = Color(0xFFFF9999);
  static const Color terracotta = Color(0xFFE27D60);
  static const Color goldenYellow = Color(0xFFF7CA44);
  static const Color mustardYellow = Color(0xFFD9AD42);
  static const Color oceanBlue = Color(0xFF457B9D);
  static const Color lavender = Color(0xFFE6E6FA);
  static const Color mintGreen = Color(0xFFBDC3C7);
  static const Color skyBlue = Color(0xFF81CFE0);
  static const Color dustyBlue = Color(0xFF93A7BE);
  static const Color taupe = Color(0xFFA89A8D);
  static const Color charcoalGray = Color(0xFF333333);
  static const Color greige = Color(0xFFC2C2C2);
  static const Color warmGray = Color(0xFF9E9E9E);
  static const Color coolGray = Color(0xFF757575);
  static const Color charcoal = Color(0xFF273E47);
  static const Color butterScotch = Color(0xFFD8973C);
  static const Color davyGray = Color(0xFF4E5166);
  static const Color slateGray = Color(0xFF7C90A0);
  static const Color periwinkle = Color(0xFFB8BEDD);
  static const Color midnightGreen = Color(0xFF0B3C49);
  static const Color neonPink = Color(0xFFF63275);
  static const Color neonBlue = Color(0xFF03C5E7);
  static const Color planNew = Color(0xFF3399FF);
  static const Color planPending = Color(0xFFFFCC00);
  static const Color planApproved = Color(0xFF33CC33);
  static const Color planRejected = Color(0xFFFF3333);

  List<BoxShadow> get fadeShadow {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        spreadRadius: 1,
        blurRadius: 5,
        offset: const Offset(0, 2),
      ),
    ];
  }

  LinearGradient darkBlueGradientColor() {
    return const LinearGradient(
      colors: [
        Color(0xFF243748),
        Color(0xFF4b749f),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomRight,
    );
  }

  LinearGradient earthGradientColor() {
    return const LinearGradient(
      colors: [
        Colors.blue,
        Colors.green,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  LinearGradient goldGradientColor() {
    return const LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFd4c11c),
        Color(0xffbfa40a),
      ],
    );
  }

  LinearGradient cambodiaGradientColor() {
    return const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xFF2196f3),
        Color(0xfff44336),
      ],
    );
  }

  LinearGradient cambodiaGradientAccent() {
    return const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xFF780206),
        Color(0xff061161),
      ],
    );
  }

  LinearGradient silverGradientColor() {
    return const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xFF8399A2),
        Color(0xffEEF2F3),
      ],
    );
  }

  LinearGradient veniceBlueGradientColor() {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0.0, 1.0],
      colors: [
        Color(0xFF085078),
        Color(0xff85d8ce),
      ],
    );
  }

  LinearGradient sunDawnGradientColor() {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0.0, 1.0],
      colors: [
        Color(0xFFF3904F),
        Color(0xff3B4371),
      ],
    );
  }

  static Gradient get lightGradient => const LinearGradient(
        colors: [backgroundLight, primaryLight],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static Gradient get darkGradient => const LinearGradient(
        colors: [backgroundDark, primaryDark],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static Gradient get primaryGradient => const LinearGradient(
        colors: [primaryLight, primaryDark],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static Gradient get secondaryGradient => const LinearGradient(
        colors: [secondaryLight, secondaryDark],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}
