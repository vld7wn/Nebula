import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nebula/features/auth/presentation/screens/welcome_screen.dart';
import 'package:nebula/core/services/deep_link_service.dart';

import 'core/themes/app_theme.dart';
import 'core/di/injection.dart';
import 'firebase_options.dart';

/// Глобальный ключ навигатора для deep link обработки
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Инициализация DI
  await configureDependencies();

  runApp(const NebulaApp());
}

class NebulaApp extends StatefulWidget {
  const NebulaApp({super.key});

  @override
  State<NebulaApp> createState() => _NebulaAppState();
}

class _NebulaAppState extends State<NebulaApp> {
  late DeepLinkService _deepLinkService;

  @override
  void initState() {
    super.initState();
    _deepLinkService = DeepLinkService(navigatorKey: navigatorKey);
    _deepLinkService.initialize();
  }

  @override
  void dispose() {
    _deepLinkService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Nebula Messenger',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const WelcomeScreen(),
    );
  }
}
