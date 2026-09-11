import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_user.dart';
import '../../core/constants.dart';

/// Local persistence: onboarding flag, 1-day trial timestamp,
/// active subscription and signed-in user.
///
/// TODO(billing): swap [saveSubscription] for RevenueCat / in_app_purchase
/// (Google Play Billing + Apple StoreKit) when going to production.
/// The trial + expiry logic around it stays exactly the same.
class AppStorage {
  static const _kOnboarding = 'onboarding_seen';
  static const _kFirstLaunch = 'first_launch_ms';
  static const _kSubEnd = 'sub_end_ms';
  static const _kPlanId = 'plan_id';
  static const _kUser = 'user_json';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ---------------- Onboarding ----------------
  bool get onboardingSeen => _prefs.getBool(_kOnboarding) ?? false;

  Future<void> setOnboardingSeen() => _prefs.setBool(_kOnboarding, true);

  // ---------------- Free trial (1 day) ----------------
  int get firstLaunchMs {
    var v = _prefs.getInt(_kFirstLaunch);
    if (v == null) {
      v = DateTime.now().millisecondsSinceEpoch;
      _prefs.setInt(_kFirstLaunch, v);
    }
    return v;
  }

  DateTime get trialStart =>
      DateTime.fromMillisecondsSinceEpoch(firstLaunchMs);

  DateTime get trialEnd => trialStart.add(AppConstants.trialDuration);

  Duration get trialRemaining {
    final d = trialEnd.difference(DateTime.now());
    return d.isNegative ? Duration.zero : d;
  }

  // ---------------- Subscription ----------------
  DateTime? get subscriptionEnd {
    final v = _prefs.getInt(_kSubEnd);
    return v == null ? null : DateTime.fromMillisecondsSinceEpoch(v);
  }

  String? get planId => _prefs.getString(_kPlanId);

  Future<void> saveSubscription(String planId, DateTime end) async {
    await _prefs.setInt(_kSubEnd, end.millisecondsSinceEpoch);
    await _prefs.setString(_kPlanId, planId);
  }

  Future<void> clearSubscription() async {
    await _prefs.remove(_kSubEnd);
    await _prefs.remove(_kPlanId);
  }

  // ---------------- Signed-in user ----------------
  AppUser? get user {
    final s = _prefs.getString(_kUser);
    if (s == null) return null;
    try {
      return AppUser.fromJson(jsonDecode(s) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveUser(AppUser user) => _prefs.setString(_kUser, jsonEncode(user.toJson()));

  Future<void> clearUser() => _prefs.remove(_kUser);
}
