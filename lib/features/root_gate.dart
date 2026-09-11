import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/services/app_storage.dart';
import 'auth/auth_provider.dart';
import 'auth/auth_screen.dart';
import 'onboarding/onboarding_screen.dart';
import 'paywall/paywall_screen.dart';
import 'home/main_screen.dart';
import 'subscription/subscription_provider.dart';

/// Decides what the user sees:
/// onboarding (first launch) -> sign in -> paywall (trial over & not premium)
/// -> main app. Rebuilds automatically when auth or subscription changes.
class RootGate extends StatefulWidget {
  const RootGate({super.key});

  @override
  State<RootGate> createState() => _RootGateState();
}

class _RootGateState extends State<RootGate> {
  late bool _showOnboarding;

  @override
  void initState() {
    super.initState();
    _showOnboarding = !context.read<AppStorage>().onboardingSeen;
  }

  @override
  Widget build(BuildContext context) {
    if (_showOnboarding) {
      return OnboardingScreen(
        onDone: () async {
          await context.read<AppStorage>().setOnboardingSeen();
          setState(() => _showOnboarding = false);
        },
      );
    }

    final auth = context.watch<AuthProvider>();
    if (!auth.isLoggedIn) {
      return const AuthScreen();
    }

    final sub = context.watch<SubscriptionProvider>();
    if (!sub.isPremium) {
      // Trial running -> shows countdown; trial over -> hard upgrade wall.
      return const PaywallScreen();
    }

    return const MainScreen();
  }
}
