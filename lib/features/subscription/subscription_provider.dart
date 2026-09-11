import 'package:flutter/foundation.dart';

import '../../data/models/subscription_plan.dart';
import '../../data/services/app_storage.dart';

enum SubscriptionStatus { trialActive, trialExpired, premium }

class SubscriptionProvider extends ChangeNotifier {
  final AppStorage storage;

  SubscriptionProvider(this.storage);

  SubscriptionStatus get status {
    final sub = storage.subscriptionEnd;
    if (sub != null && sub.isAfter(DateTime.now())) {
      return SubscriptionStatus.premium;
    }
    return storage.trialRemaining.inSeconds > 0
        ? SubscriptionStatus.trialActive
        : SubscriptionStatus.trialExpired;
  }

  bool get isPremium => status == SubscriptionStatus.premium;

  bool get inTrial => status == SubscriptionStatus.trialActive;

  Duration get trialRemaining => storage.trialRemaining;

  SubscriptionPlan? get activePlan => SubscriptionPlan.byId(storage.planId ?? '');

  String get trialCountdown {
    final d = storage.trialRemaining;
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  /// Simulated purchase. TODO(billing): replace with real store purchase,
  /// then call [storage.saveSubscription] with the real expiry date.
  Future<void> purchase(SubscriptionPlan plan) async {
    await storage.saveSubscription(plan.id, DateTime.now().add(plan.duration));
    notifyListeners();
  }

  /// TODO(billing): query the store for existing purchases and call
  /// [storage.saveSubscription] for the newest valid one.
  Future<void> restorePurchases() async {
    notifyListeners();
  }
}
