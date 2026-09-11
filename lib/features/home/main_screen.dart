import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../analytics/analytics_tab.dart';
import '../chat/chat_tab.dart';
import 'home_tab.dart';
import '../settings/settings_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  static const _tabs = [
    HomeTab(),
    ChatTab(),
    AnalyticsTab(),
    SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: AppColors.card,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_rounded), label: 'Chat'),
          NavigationDestination(icon: Icon(Icons.insights_rounded), label: 'Analytics'),
          NavigationDestination(icon: Icon(Icons.settings_rounded), label: 'Settings'),
        ],
      ),
    );
  }
}
