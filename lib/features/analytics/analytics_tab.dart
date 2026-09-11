import 'package:flutter/material.dart';

import '../../core/constants.dart';

class AnalyticsTab extends StatelessWidget {
  const AnalyticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    const weeklyViews = [820.0, 1240, 980, 1560, 1890, 2310, 2675];
    final maxVal = weeklyViews.reduce((a, b) => a > b ? a : b);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Analytics', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _BigStat(label: 'Views 24h', value: '24.6K', color: AppColors.accent),
              _BigStat(label: 'Peak Concurrents', value: '1,283', color: AppColors.primary),
              _BigStat(label: 'Watch Time', value: '4.8K hrs', color: AppColors.success),
              _BigStat(label: 'New Subs', value: '+312', color: AppColors.gold),
              _BigStat(label: 'Est. Revenue', value: r'$58.20', color: Colors.white),
              _BigStat(label: 'Stream Grade', value: 'A-', color: AppColors.accent),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Weekly Views', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 160,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (final v in weeklyViews)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('${v.toInt()}',
                                    style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
                                const SizedBox(height: 4),
                                Container(
                                  height: (v / maxVal) * 120,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Mon', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                    Text('Tue', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                    Text('Wed', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                    Text('Thu', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                    Text('Fri', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                    Text('Sat', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                    Text('Sun', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Top Tips', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                _Tip(icon: Icons.schedule_rounded, text: 'Best time to stream: 7PM - 10PM in your timezone.'),
                _Tip(icon: Icons.thumb_up_rounded, text: 'Thumbnails with a face + emotion get 38% more CTR.'),
                _Tip(icon: Icons.title_rounded, text: 'Titles under 60 characters rank better in search.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BigStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _BigStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 60) / 2,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
        ],
      ),
    );
  }
}

class _Tip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Tip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.accent, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, height: 1.4))),
        ],
      ),
    );
  }
}
