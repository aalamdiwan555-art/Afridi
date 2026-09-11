import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../data/models/subscription_plan.dart';
import '../auth/auth_provider.dart';
import '../subscription/subscription_provider.dart';

/// Shown when the user is not premium.
/// If the 1-day trial is still running this shows a live countdown,
/// otherwise it is a full upgrade wall.
class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  String _selectedId = 'monthly';

  @override
  Widget build(BuildContext context) {
    final sub = context.watch<SubscriptionProvider>();
    final inTrial = sub.inTrial;
    final selected = SubscriptionPlan.byId(_selectedId)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smartyt Premium'),
        actions: [
          IconButton(
            tooltip: 'Restore purchase',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () async {
              await context.read<SubscriptionProvider>().restorePurchases();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Purchase restore checked.')),
                );
              }
            },
          ),
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => context.read<AuthProvider>().signOut(),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primary],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Icon(
                    inTrial ? Icons.timer_rounded : Icons.lock_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    inTrial
                        ? 'Your free trial ends in ${sub.trialCountdown}'
                        : 'Your free trial has ended',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    inTrial
                        ? 'Upgrade now - your plan starts after the trial, nothing is lost.'
                        : 'Upgrade to keep streaming. No ads, no watermark, cancel anytime.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            for (final plan in SubscriptionPlan.all) ...[
              _planTile(plan, selected: plan.id == _selectedId),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.verified_rounded, color: AppColors.success, size: 18),
                SizedBox(width: 8),
                Text('100% ad-free - subscriptions are our only revenue'),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await context.read<SubscriptionProvider>().purchase(selected);
                if (!context.mounted) return;
                final end = DateTime.now().add(selected.duration);
                await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Welcome to Premium'),
                    content: Text(
                      '${selected.title} plan active until '
                      '${end.day}/${end.month}/${end.year}.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Start Streaming'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Continue - ${selected.price} ${selected.priceNote}'),
            ),
            const SizedBox(height: 12),
            const Text(
              'Recurring subscription. Cancel anytime in Play Store / App Store settings.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _planTile(SubscriptionPlan plan, {required bool selected}) {
    return GestureDetector(
      onTap: () => setState(() => _selectedId = plan.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? AppColors.primary : AppColors.textMuted,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        plan.title,
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      if (plan.badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: plan.badge == 'BEST VALUE' ? AppColors.gold : AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            plan.badge!,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    plan.priceNote,
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ],
              ),
            ),
            Text(
              plan.price,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: AppColors.accent),
            ),
          ],
        ),
      ),
    );
  }
}
