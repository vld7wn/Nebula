import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Сервис для обработки deep links (Email Link Auth)
class DeepLinkService {
  final AppLinks _appLinks = AppLinks();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StreamSubscription<Uri>? _subscription;
  final GlobalKey<NavigatorState> navigatorKey;

  DeepLinkService({required this.navigatorKey});

  /// Инициализация обработчика deep links
  Future<void> initialize() async {
    // Проверяем начальную ссылку (если приложение запущено по ссылке)
    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      await _handleDeepLink(initialLink);
    }

    // Слушаем новые ссылки
    _subscription = _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });
  }

  /// Обработка deep link
  Future<void> _handleDeepLink(Uri uri) async {
    final link = uri.toString();

    // Проверяем, является ли это Email Link
    if (_auth.isSignInWithEmailLink(link)) {
      await _handleEmailLink(link);
    }
  }

  /// Обработка Email Link для входа
  Future<void> _handleEmailLink(String emailLink) async {
    try {
      // Получаем сохранённый email
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('pendingEmail');

      if (email == null || email.isEmpty) {
        debugPrint('Email not found for Email Link sign in');
        return;
      }

      // Входим по ссылке
      final credential = await _auth.signInWithEmailLink(
        email: email,
        emailLink: emailLink,
      );

      if (credential.user != null) {
        // Очищаем сохранённый email
        await prefs.remove('pendingEmail');

        // Переходим на главный экран или регистрацию
        // Используем navigatorKey для навигации
        debugPrint('Email Link sign in successful: ${credential.user!.email}');

        // TODO: Навигация на экран завершения регистрации (имя, аватар)
        // или на главный экран если пользователь уже зарегистрирован
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Email Link sign in error: ${e.message}');
    } catch (e) {
      debugPrint('Email Link sign in error: $e');
    }
  }

  /// Освобождение ресурсов
  void dispose() {
    _subscription?.cancel();
  }
}
