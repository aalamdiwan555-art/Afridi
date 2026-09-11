import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../auth/auth_provider.dart';
import '../golive/golive_screen.dart';
import '../paywall/paywall_screen.dart';
import '../subscription/subscription_provider.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  static const _modes = [
    (StreamMode.screen, Icons.screen_share_rounded, 'Screen Stream', 'Games, apps & tutorials', AppColors.accent),
    (StreamMode.camera, Icons.videocam_rounded, 'Camera Live', 'Filters, AR & multi-guest', AppColors.primary),
    (StreamMode.prerecorded, Icons.play_circle_fill_rounded, 'Pre-Recorded', 'Premiere-style simulive', AppColors.gold),
    (StreamMode.alwaysOn, Icons.all_inclusive_rounded, '24x7 Channel', 'Auto-loop always-on stream', AppColors.success),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final sub = context.watch<SubscriptionProvider>();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: Text(
                  auth.user?.initial ?? '?',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hey, ${auth.user?.name.split(' ').first ?? 'Creator'}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      auth.user?.isDemo == true ? 'Demo account' : auth.user?.email ?? '',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  sub.activePlan?.title.toUpperCase() ?? 'TRIAL',
                  style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_rounded, color: AppColors.accent),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    sub.inTrial
                        ? 'Free trial: ${sub.trialCountdown} left'
                        : '${sub.activePlan?.title ?? 'Premium'} plan active',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PaywallScreen()),
                  ),
                  child: const Text('Manage'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Go Live', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.05,
            children: [
              for (final (mode, icon, title, subtitle, color) in _modes)
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => GoLiveScreen(mode: mode)),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(icon, color: color, size: 28),
                        ),
                        const Spacer(),
                        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 2),
                        Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Quick Stats', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Row(
            children: [
              _StatCard(label: 'Views 24h', value: '24.6K'),
              _StatCard(label: 'Peak Live', value: '1,283'),
              _StatCard(label: 'New Subs', value: '+312'),
              _StatCard(label: 'Est. Revenue', value: r'$58.20'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 4),
            Text(label, textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
