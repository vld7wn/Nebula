import 'package:flutter/material.dart';
import 'package:nebula/features/auth/data/models/registration_data.dart';
import 'package:nebula/shared/widgets/nebula_background.dart';
import 'package:nebula/shared/widgets/glass_container.dart';
import 'package:nebula/shared/widgets/nebula_button.dart';
import 'package:nebula/shared/widgets/nebula_logo.dart';
import 'package:url_launcher/url_launcher.dart';

/// Экран ожидания подтверждения email через Email Link
class RegisterEmailPendingScreen extends StatefulWidget {
  final RegistrationData data;

  const RegisterEmailPendingScreen({super.key, required this.data});

  @override
  State<RegisterEmailPendingScreen> createState() =>
      _RegisterEmailPendingScreenState();
}

class _RegisterEmailPendingScreenState
    extends State<RegisterEmailPendingScreen> {
  /// Открыть почтовое приложение
  Future<void> _openEmailApp() async {
    // Определяем URL для разных почтовых сервисов
    final email = widget.data.email.toLowerCase();
    String? webmailUrl;

    if (email.contains('@gmail.com')) {
      webmailUrl = 'https://mail.google.com';
    } else if (email.contains('@yandex.') || email.contains('@ya.ru')) {
      webmailUrl = 'https://mail.yandex.ru';
    } else if (email.contains('@mail.ru') ||
        email.contains('@inbox.ru') ||
        email.contains('@bk.ru')) {
      webmailUrl = 'https://e.mail.ru';
    } else if (email.contains('@outlook.') ||
        email.contains('@hotmail.') ||
        email.contains('@live.')) {
      webmailUrl = 'https://outlook.live.com';
    } else if (email.contains('@icloud.com')) {
      webmailUrl = 'https://www.icloud.com/mail';
    }

    if (webmailUrl != null) {
      final uri = Uri.parse(webmailUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return;
      }
    }

    // Fallback: открыть mailto (откроет почтовый клиент)
    final mailtoUri = Uri(scheme: 'mailto');
    if (await canLaunchUrl(mailtoUri)) {
      await launchUrl(mailtoUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NebulaBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GlassContainer(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const NebulaLogo(logoSize: 60, fontSize: 23),
                        const SizedBox(height: 24),

                        // Иконка почты
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.mark_email_read_outlined,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 24),

                        Text(
                          'Проверьте почту',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Text(
                          'Мы отправили ссылку для входа на',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),

                        Text(
                          widget.data.email,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 24),

                        Text(
                          'Нажмите на ссылку в письме,\nчтобы продолжить регистрацию',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Открыть почту
                        SizedBox(
                          width: double.infinity,
                          child: NebulaGlassButton(
                            text: 'Открыть почту',
                            icon: const Icon(Icons.open_in_new, size: 20),
                            onPressed: _openEmailApp,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Назад
                        TextButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white.withOpacity(0.6),
                            size: 18,
                          ),
                          label: Text(
                            'Изменить email',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
