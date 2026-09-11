import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/services/app_storage.dart';
import 'features/auth/auth_provider.dart';
import 'features/subscription/subscription_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Local storage must be ready before any provider reads it.
  final storage = AppStorage();
  await storage.init();

  runApp(
    MultiProvider(
      providers: [
        Provider<AppStorage>.value(value: storage),
        ChangeNotifierProvider(
          create: (_) => SubscriptionProvider(storage),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(storage),
        ),
      ],
      child: const SmartytApp(),
    ),
  );
}
