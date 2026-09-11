enum BillingPeriod { daily, weekly, monthly, yearly }

/// A paid plan. Smartyt has NO ads - this is the entire monetization model:
/// 1-day free trial, then the user picks one of these plans.
class SubscriptionPlan {
  final String id;
  final BillingPeriod period;
  final String title;
  final String price;
  final String priceNote;
  final Duration duration;
  final String? badge; // 'MOST POPULAR' / 'BEST VALUE'
  final List<String> features;

  const SubscriptionPlan({
    required this.id,
    required this.period,
    required this.title,
    required this.price,
    required this.priceNote,
    required this.duration,
    this.badge,
    this.features = const [],
  });

  static const List<String> proFeatures = [
    'Full HD screen + camera streaming',
    'Pre-recorded "live" streams',
    'Live chat + moderation tools',
    'No ads, no watermark',
  ];

  static const List<String> eliteFeatures = [
    'Everything in shorter plans',
    '24x7 always-on cloud streams',
    'AI title / SEO + thumbnail tools',
    'Cloud recording + auto highlights',
    'Priority ingest relay (4K ready)',
    'Team seats for moderators',
  ];

  static const List<SubscriptionPlan> all = [
    SubscriptionPlan(
      id: 'daily',
      period: BillingPeriod.daily,
      title: 'Daily',
      price: r'$0.99',
      priceNote: 'per day',
      duration: Duration(days: 1),
      features: proFeatures,
    ),
    SubscriptionPlan(
      id: 'weekly',
      period: BillingPeriod.weekly,
      title: 'Weekly',
      price: r'$4.99',
      priceNote: 'per week',
      duration: Duration(days: 7),
      features: proFeatures,
    ),
    SubscriptionPlan(
      id: 'monthly',
      period: BillingPeriod.monthly,
      title: 'Monthly',
      price: r'$14.99',
      priceNote: 'per month',
      duration: Duration(days: 30),
      badge: 'MOST POPULAR',
      features: eliteFeatures,
    ),
    SubscriptionPlan(
      id: 'yearly',
      period: BillingPeriod.yearly,
      title: 'Yearly',
      price: r'$99.99',
      priceNote: 'per year',
      duration: Duration(days: 365),
      badge: 'BEST VALUE',
      features: eliteFeatures,
    ),
  ];

  static SubscriptionPlan? byId(String id) {
    for (final p in all) {
      if (p.id == id) return p;
    }
    return null;
  }
}
