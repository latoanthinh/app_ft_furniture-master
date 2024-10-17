import 'package:flutter/material.dart';

abstract final class AppSize {
  static const double sp4 = 4;
  static const double sp6 = 6;
  static const double sp8 = 8;
  static const double sp16 = 16;
  static const double sp24 = 24;
  static const double sp32 = 32;
  static const double sp64 = 64;
  static const double sp128 = 128;
  static const double sp192 = 192;
  static const double sp256 = 256;

  static const double sp360 = 360;
  static const double sp412 = 412;

  // Phone
  static const double compact = 600;

  // Tablet
  static const double medium = 840;

  // Desktop or phone, table landscape
  static const double expanded = 1200;

  // Desktop
  static const double large = 1600;

  // Desktop Ultra-wide
  static const double extraLarge = 900900900;

  static double sizeScreenMargin(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    if (screenSize.width < compact) return sp16;
    return sp24;
  }

  static SizedBox screenMargin(BuildContext context) {
    final screenSize = sizeScreenMargin(context);
    return SizedBox(width: screenSize, height: screenSize);
  }
}
