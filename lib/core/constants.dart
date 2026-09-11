import 'package:flutter/material.dart';

/// App-wide constants.
class AppConstants {
  static const String appName = 'Smartyt';
  static const String tagline = 'Stream Everything. One App.';
  static const String supportEmail = 'support@smartyt.app';

  /// Every new user gets a 1-day free trial. After it ends the
  /// user must upgrade to a paid plan (daily / weekly / monthly / yearly).
  static const Duration trialDuration = Duration(hours: 24);

  /// MONETIZATION POLICY: Smartyt is 100% ad-free.
  /// Never add AdMob / Facebook Audience / any ad SDK to this app.
  /// Revenue comes only from user subscriptions.
  static const bool adsEnabled = false;
}

/// Brand color palette.
class AppColors {
  static const Color primary = Color(0xFFE62117);
  static const Color primaryDark = Color(0xFF9E1B1B);
  static const Color bg = Color(0xFF0F1115);
  static const Color card = Color(0xFF1B1F27);
  static const Color cardLight = Color(0xFF242A35);
  static const Color accent = Color(0xFF4FC3F7);
  static const Color gold = Color(0xFFFFC107);
  static const Color success = Color(0xFF4CAF50);
  static const Color danger = Color(0xFFFF5252);
  static const Color textMuted = Color(0xFF8A93A6);
}
