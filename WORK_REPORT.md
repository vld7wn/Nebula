# Отчёт о работе — Nebula Messenger

## Сессия 29 декабря 2024

### Авторизация и регистрация — ПОЛНОСТЬЮ РЕАЛИЗОВАНО ✅

#### Экраны (8 шт.)

| Экран                  | Файл                            | Описание                                          |
| ---------------------- | ------------------------------- | ------------------------------------------------- |
| WelcomeScreen          | `welcome_screen.dart`           | Приветствие с анимацией засасывания в чёрную дыру |
| LoginScreen            | `login_screen.dart`             | Вход по email/username/phone + Google/Apple OAuth |
| RegisterScreen         | `register_screen.dart`          | Шаг 1: Выбор метода (email или телефон)           |
| RegisterOtpScreen      | `register_otp_screen.dart`      | Шаг 2: Проверка OTP кода                          |
| RegisterPasswordScreen | `register_password_screen.dart` | Шаг 3: Установка пароля                           |
| RegisterNameScreen     | `register_name_screen.dart`     | Шаг 4: Ввод имени и фамилии                       |
| RegisterAvatarScreen   | `register_avatar_screen.dart`   | Шаг 5: Фото профиля (можно пропустить)            |
| ForgotPasswordScreen   | `forgot_password_screen.dart`   | Сброс пароля через email                          |

#### Сервисы

**AuthService** (`auth_service.dart`):

- `signInWithEmail()` — вход по email и паролю
- `signUpWithEmail()` — регистрация по email и паролю
- `signInWithGoogle()` — OAuth через Google
- `signInWithApple()` — OAuth через Apple
- `resetPassword()` — сброс пароля (Firebase email)
- `signOut()` — выход

**UserService** (`user_service.dart`):

- `createUserProfile()` — создание профиля в Firestore
- `getUserProfile()` — получение профиля
- `updateUserProfile()` — обновление профиля
- `isUsernameAvailable()` — проверка username
- `isPhoneAvailable()` — проверка телефона
- `findEmailByUsername()` — поиск email по логину
- `findEmailByPhone()` — поиск email по телефону
- `resolveEmailFromInput()` — разрешение логина/phone/email в email

#### UI компоненты

- **GlassContainer** — glassmorphism контейнер
- **GlassTextField** — текстовое поле
- **GlassPasswordField** — поле пароля с toggle видимости
- **NebulaGlassButton** — матовая кнопка с неоновым бордером
- **NebulaBackground** — космический фон с чёрной дырой
- **NebulaLogo** — логотип (60x23 на экранах auth)

#### Анимации

- Засасывание в чёрную дыру при переходах между экранами
- pullAnimation → contentScale → contentOpacity → blackOverlay
- Обратная анимация при возврате на WelcomeScreen

#### TODO (вторичное)

- [ ] OTP верификация — пока пропускается (код "000000")
- [ ] Выбор аватара — загрузка в Firebase Storage

---

## Сессия 27-28 декабря 2024

### Выполненные задачи

#### 1. WelcomeScreen

- Создан экран приветствия `lib/features/auth/presentation/screens/welcome_screen.dart`
- Лого + текст "Nebula Messenger" в одной строке
- Шрифт Archivo (w900 для Nebula, w400 для Messenger)
- Адаптивные размеры через `MediaQuery`
- Кнопки Sign In / Register

#### 2. NebulaGlassButton

- Создан glassmorphism виджет кнопки `lib/shared/widgets/nebula_button.dart`
- BackdropFilter blur для матовости
- Прозрачный фон с неоновой фиолетовой окантовкой
- Поддержка иконок и loading состояния

#### 3. NebulaBackground

- Создан космический фон `lib/shared/widgets/nebula_background.dart`
- Тёмный градиент (синий → фиолетовый → чёрный)
- Изображение чёрной дыры `nebula_cosmic_bg.png`
- Звёзды (CustomPaint)

#### 4. Зависимости

- Добавлен `google_fonts` для шрифта Archivo
- Добавлен `flutter_svg` (на будущее)
