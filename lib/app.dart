import 'package:flutter/material.dart';

import 'core/constants.dart';
import 'core/theme.dart';
import 'features/root_gate.dart';

class SmartytApp extends StatelessWidget {
  const SmartytApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: buildDarkTheme(),
      home: const RootGate(),
    );
  }
}
