import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const SkillSyncApp());
}

class SkillSyncApp extends StatelessWidget {
  const SkillSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkillSync AI',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(), // Splash screen hi pehli screen hai
    );
  }
}