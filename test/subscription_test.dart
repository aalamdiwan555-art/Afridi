import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartytapp/data/models/subscription_plan.dart';
import 'package:smartytapp/data/services/app_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('all four billing periods exist', () {
    expect(SubscriptionPlan.all.length, 4);
    expect(
      SubscriptionPlan.all.map((p) => p.period).toSet(),
      {
        BillingPeriod.daily,
        BillingPeriod.weekly,
        BillingPeriod.monthly,
        BillingPeriod.yearly,
      },
    );
  });

  test('new user gets 24h trial', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = AppStorage();
    await storage.init();
    expect(storage.trialRemaining.inHours, greaterThanOrEqualTo(23));
    expect(storage.trialRemaining.inHours, lessThanOrEqualTo(24));
    expect(storage.subscriptionEnd, isNull);
  });

  test('purchasing a plan unlocks premium', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = AppStorage();
    await storage.init();
    final plan = SubscriptionPlan.all.firstWhere((p) => p.id == 'weekly');
    await storage.saveSubscription(plan.id, DateTime.now().add(plan.duration));
    expect(storage.subscriptionEnd, isNotNull);
    expect(storage.planId, 'weekly');
  });
}
