import 'package:flutter/material.dart';
import 'package:nebula/features/auth/data/models/registration_data.dart';
import 'package:nebula/shared/utils/app_notification.dart';
import 'package:nebula/shared/widgets/glass_text_field.dart';
import 'package:nebula/shared/widgets/nebula_background.dart';
import 'package:nebula/shared/widgets/glass_container.dart';
import 'package:nebula/shared/widgets/nebula_button.dart';
import 'package:nebula/shared/widgets/nebula_logo.dart';
import 'register_avatar_screen.dart';

/// Шаг 4: Ввод имени и фамилии
class RegisterNameScreen extends StatefulWidget {
  final RegistrationData data;

  const RegisterNameScreen({super.key, required this.data});

  @override
  State<RegisterNameScreen> createState() => _RegisterNameScreenState();
}

class _RegisterNameScreenState extends State<RegisterNameScreen> {
  bool _isLoading = false;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  Future<void> _continue() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    if (firstName.isEmpty) {
      AppNotification.showError(context, 'Введите имя');
      return;
    }

    setState(() => _isLoading = true);

    try {
      widget.data.firstName = firstName;
      widget.data.lastName = lastName;

      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RegisterAvatarScreen(data: widget.data),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
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
                        const NebulaLogo(logoSize: 80, fontSize: 28),
                        const SizedBox(height: 8),
                        Text(
                          'Как вас зовут?',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Шаг 4 из 5',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Имя
                        GlassTextField(
                          controller: _firstNameController,
                          hintText: 'Имя',
                          prefixIcon: Icons.person_outline,
                        ),
                        const SizedBox(height: 16),
                        // Фамилия
                        GlassTextField(
                          controller: _lastNameController,
                          hintText: 'Фамилия (необязательно)',
                          prefixIcon: Icons.person_outline,
                        ),
                        const SizedBox(height: 24),
                        // Кнопка
                        SizedBox(
                          width: double.infinity,
                          child: _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : NebulaGlassButton(
                                  text: 'Продолжить',
                                  icon: const Icon(
                                    Icons.arrow_forward,
                                    size: 20,
                                  ),
                                  onPressed: _continue,
                                ),
                        ),
                        const SizedBox(height: 16),
                        // Back button
                        TextButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white.withOpacity(0.6),
                            size: 18,
                          ),
                          label: Text(
                            'Назад',
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
