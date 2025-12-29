<p align="center">
  <img src="assets/logo/nebula_logo_512.png" width="120" alt="Nebula Logo">
</p>

<h1 align="center">✨ Nebula Messenger ✨</h1>

<p align="center">
  <strong>Мессенджер нового поколения с космическим дизайном</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.24+-02569B?style=for-the-badge&logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.5+-00B4AB?style=for-the-badge&logo=dart" alt="Dart">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-blue?style=for-the-badge" alt="Platform">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Architecture-Clean%20Architecture-success?style=flat-square" alt="Clean Architecture">
  <img src="https://img.shields.io/badge/State%20Management-BLoC-blue?style=flat-square" alt="BLoC">
  <img src="https://img.shields.io/badge/Design-Glassmorphism-purple?style=flat-square" alt="Glassmorphism">
</p>

---

## 🌌 О проекте

**Nebula** — это футуристический мессенджер с уникальным космическим дизайном, вдохновлённый глубинами вселенной. Сочетает в себе передовые технологии Flutter с эстетикой glassmorphism и неоновых градиентов.

<p align="center">
  <em>«Общение на скорости света через туманности космоса»</em>
</p>

---

## 🚀 Ключевые возможности

### 💬 Чаты и сообщения

- **Приватные чаты** с E2E шифрованием (AES-256-GCM / XChaCha20)
- **Безопасный поиск** по сообщениям (Client-Side Search)
- **Групповые чаты** с расширенным управлением
- **Голосовые сообщения** с визуализацией волн
- **Медиа-вложения** (фото, видео, файлы, геолокация, контакты)
- **Swipe-действия** для быстрого архивирования и закрепления

### ⏳ Капсулы времени (Time Capsules)

> _Уникальная функция отправки сообщений в будущее_

- 📅 Выбор даты доставки от минут до лет
- 🔒 Запечатанное содержимое до момента открытия
- 🎤 Поддержка текста и голосовых записей
- ✨ Кинематографические анимации открытия
- 🔔 Уведомления о скорой доставке

### 🎵 Spatial Audio

- Виртуальная 3D-комната для голосового общения
- Позиционное аудио для иммерсивного опыта
- Drag-and-drop позиционирование участников

### 🎨 Дизайн

- **Glassmorphism** — полупрозрачные элементы с размытием
- **Parallax Background** — динамический градиентный фон с гироскопом
- **Неоновые градиенты** — яркие акценты и тени
- **Плавные анимации** — микро-взаимодействия на каждом шагу

---

## 🏗️ Архитектура

```
lib/
├── 📁 data/
│   ├── models/          # Модели данных (Hive)
│   └── services/        # Сервисы (шифрование, чаты)
│
├── 📁 features/
│   ├── 💬 chat_detail/   # Экран чата
│   │   ├── screens/
│   │   │   └── chat_detail/
│   │   │       └── helpers/   # Painters
│   │   ├── state/
│   │   └── widgets/
│   │       ├── capsule/       # Капсулы времени
│   │       └── message_bubble/ # Компоненты сообщений
│   │
│   ├── 🏠 home/          # Главный экран
│   │   ├── screens/
│   │   │   └── home_screen/
│   │   │       └── dialogs/
│   │   └── widgets/
│   │       ├── chat_item/     # Элемент чата (7 файлов)
│   │       └── time_capsules/ # Экран капсул (6 файлов)
│   │
│   ├── 📞 call/          # Звонки
│   ├── 👥 community/     # Сообщества
│   ├── 📸 media_editor/  # Редактор медиа
│   ├── 👤 profile/       # Профиль
│   └── 📖 story/         # Истории
│
├── 📁 shared_widgets/
│   ├── audio/            # Аудио визуализаторы
│   ├── common/           # Общие виджеты
│   └── time_capsule/     # Иконки капсул
│
├── 📁 theme/
│   └── nebula_theme.dart # Космическая тема
│
└── 📁 utils/             # Утилиты
```

---

## 🛠️ Технологии

| Категория               | Технологии                         |
| ----------------------- | ---------------------------------- |
| **Framework**           | Flutter 3.24+                      |
| **Язык**                | Dart 3.5+                          |
| **State Management**    | flutter_bloc                       |
| **Локальное хранилище** | Hive                               |
| **Аудио**               | audioplayers, record               |
| **Изображения**         | cached_network_image               |
| **Анимации**            | CustomPainter, AnimationController |
| **Безопасность**        | encrypt (AES), FFI (C++)           |

---

## 🎨 Цветовая палитра

```dart
// Основные цвета Nebula
static const Color primary = Color(0xFF7C4DFF);      // Фиолетовый
static const Color accent = Color(0xFF18FFFF);       // Циан
static const Color background = Color(0xFF0D0D1A);  // Глубокий космос

// Капсулы времени
static const Color capsulePrimary = Color(0xFFFF6B35); // Оранжевый
static const Color capsuleAccent = Color(0xFFFFD93D);  // Золотой
static const Color capsuleGlow = Color(0xFF00F5D4);    // Бирюзовый
```

---

## ⚡ Производительность

Nebula оптимизирован для плавной работы на 60/120 FPS:

- ✅ **CustomPainter** вместо тяжёлых виджетов
- ✅ **RepaintBoundary** для изоляции перерисовок
- ✅ **Modular Architecture** — маленькие переиспользуемые компоненты
- ✅ **Lazy Loading** — отложенная загрузка элементов списка
- ✅ **Image Caching** — кэширование изображений

---

## 🚀 Запуск

```bash
# Клонирование репозитория
git clone https://github.com/your-username/nebula-messenger.git
cd nebula-messenger

# Установка зависимостей
flutter pub get

# Генерация Hive адаптеров (если нужно)
dart run build_runner build --delete-conflicting-outputs

# Запуск
flutter run

# 🔐 Безопасная сборка (Obfuscation)
# Для создания защищенного APK с обфускацией кода:
# Windows:
scripts\build_android_secure.bat
# Unix:
./scripts/build_android_secure.sh

# Символы для деобфускации (mapping files) сохраняются в:
# build/app/outputs/symbols
```

---

## 📱 Поддерживаемые платформы

| Платформа  | Статус            |
| ---------- | ----------------- |
| 🤖 Android | ✅ Поддерживается |
| 🍎 iOS     | ✅ Поддерживается |
| 🌐 Web     | ✅ Поддерживается |
| 🪟 Windows | ✅ Поддерживается |
| 🍏 macOS   | ✅ Поддерживается |
| 🐧 Linux   | ✅ Поддерживается |

---

## 📄 Лицензия

```
MIT License

Copyright (c) 2024 Nebula Messenger

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software.
```

---

<p align="center">
  <strong>Made with 💜 and Flutter</strong>
</p>

<p align="center">
  <sub>✨ Nebula — Connecting the Universe ✨</sub>
</p>


