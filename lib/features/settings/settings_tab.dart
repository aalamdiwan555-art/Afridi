import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../auth/auth_provider.dart';
import '../paywall/paywall_screen.dart';
import '../subscription/subscription_provider.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

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
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: Text(
                  auth.user?.initial ?? '?',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      auth.user?.name ?? 'Creator',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      auth.user?.email ?? '',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SectionTitle('Subscription'),
          Card(
            color: AppColors.card,
            child: ListTile(
              leading: const Icon(Icons.workspace_premium_rounded, color: AppColors.gold),
              title: Text(sub.isPremium ? '${sub.activePlan?.title} Plan' : 'Free Trial / Upgrade'),
              subtitle: Text(
                sub.inTrial
                    ? 'Trial ends in ${sub.trialCountdown}'
                    : sub.isPremium
                        ? 'Active until ${sub.storage.subscriptionEnd!.day}/${sub.storage.subscriptionEnd!.month}/${sub.storage.subscriptionEnd!.year}'
                        : 'Upgrade to unlock full streaming',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PaywallScreen()),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _SectionTitle('YouTube'),
          Card(
            color: AppColors.card,
            child: ListTile(
              leading: const Icon(Icons.play_circle_fill_rounded, color: AppColors.primary),
              title: Text(auth.youtubeChannel?.title ?? 'Connect YouTube'),
              subtitle: Text(
                auth.youtubeChannel == null
                    ? 'Use Google OAuth to link your creator channel'
                    : '${auth.youtubeChannel!.subscriberLabel} subscribers - ${auth.youtubeChannel!.videoLabel} videos',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              trailing: auth.youtubeLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(auth.youtubeChannel == null ? Icons.link_rounded : Icons.check_circle_rounded, color: auth.youtubeChannel == null ? AppColors.textMuted : AppColors.success),
              onTap: auth.youtubeLoading
                  ? null
                  : () async {
                      if (auth.youtubeChannel != null) {
                        await auth.disconnectYouTube();
                      } else {
                        await auth.connectYouTube();
                      }
                      if (!context.mounted) return;
                      final message = auth.youtubeError ?? (auth.youtubeChannel == null ? 'YouTube disconnected.' : 'YouTube connected successfully.');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                    },
            ),
          ),
          const SizedBox(height: 16),
          _SectionTitle('Preferences'),
          Card(
            color: AppColors.card,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.dark_mode_rounded),
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Always on for Smartyt', style: TextStyle(fontSize: 12)),
                  trailing: Switch(value: true, onChanged: null, activeColor: AppColors.primary),
                ),
                const Divider(height: 1, color: AppColors.cardLight),
                ListTile(
                  leading: const Icon(Icons.high_quality_rounded),
                  title: const Text('Default Stream Quality'),
                  subtitle: const Text('1080p60', style: TextStyle(fontSize: 12)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {},
                ),
                const Divider(height: 1, color: AppColors.cardLight),
                ListTile(
                  leading: const Icon(Icons.language_rounded),
                  title: const Text('Language'),
                  subtitle: const Text('English', style: TextStyle(fontSize: 12)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionTitle('Support'),
          Card(
            color: AppColors.card,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.help_outline_rounded),
                  title: const Text('Help Center'),
                  trailing: const Icon(Icons.open_in_new_rounded, size: 18),
                  onTap: () {},
                ),
                const Divider(height: 1, color: AppColors.cardLight),
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: const Text('About Smartyt'),
                  subtitle: const Text('v1.0.0 - 100% ad-free', style: TextStyle(fontSize: 12)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => showAboutDialog(
                    context: context,
                    applicationName: AppConstants.appName,
                    applicationVersion: '1.0.0',
                    applicationLegalese: 'Smartyt is a 100% ad-free, subscription-powered '
                        'YouTube creator streaming platform.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () => auth.signOut(),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
    );
  }
}
