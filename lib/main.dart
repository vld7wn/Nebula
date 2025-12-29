import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nebula/features/auth/presentation/screens/welcome_screen.dart';

import 'core/themes/app_theme.dart';
import 'core/di/injection.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Инициализация DI
  await configureDependencies();

  runApp(const NebulaApp());
}

class NebulaApp extends StatelessWidget {
  const NebulaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nebula Messenger',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const WelcomeScreen(),
    );
  }
}
