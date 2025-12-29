messenger_app/

├── 📁 lib/ # ИСХОДНЫЙ КОД
├── 📁 assets/ # ВСЕ АССЕТЫ ПРИЛОЖЕНИЯ (статические)
│ ├── 📁 images/
│ │ ├── 📁 icons/ # Иконки по категориям
│ │ │ ├── tab/ # chat_active.png, call_inactive.png
│ │ │ ├── common/ # send.png, attach.png, microphone.png
│ │ │ ├── auth/ # google.png, apple.png
│ │ │ └── settings/ # notification.png, privacy.png
│ │ │
│ │ ├── 📁 illustrations/ # SVG/PNG иллюстрации
│ │ │ ├── empty_chat.svg
│ │ │ ├── no_internet.svg
│ │ │ └── welcome.svg
│ │ │
│ │ ├── 📁 avatars/ # Дефолтные аватары
│ │ │ ├── default_1.png
│ │ │ ├── default_2.png
│ │ │ └── group_default.png
│ │ │
│ │ ├── 📁 backgrounds/ # Фоны чатов
│ │ │ └── chat_wallpaper.jpg
│ │ │
│ │ ├── 📁 stickers/ # Локальные стикерпаки
│ │ │ ├── 📁 animals/
│ │ │ │ ├── 1.png
│ │ │ │ └── info.json
│ │ │ └── 📁 emotions/
│ │ │
│ │ └── 📁 themes/ # Ассеты для разных тем
│ │ ├── 📁 light/ # light-варианты иконок
│ │ └── 📁 dark/ # dark-варианты иконок
│ │
│ ├── 📁 fonts/ # Кастомные шрифты
│ │ ├── Inter-Regular.ttf
│ │ ├── Inter-Medium.ttf
│ │ └── Inter-Bold.ttf
│ │
│ ├── 📁 sounds/ # Системные звуки
│ │ ├── notification.mp3
│ │ ├── message_sent.mp3
│ │ └── call_ringtone.mp3
│ │
│ ├── 📁 lottie/ # Lottie-анимации
│ │ ├── typing.json
│ │ ├── sending.json
│ │ └── loading.json
│ │
│ └── 📁 data/ # Статические данные
│ ├── 📁 countries/
│ │ ├── countries.json
│ │ └── flags/ # flag_us.png, flag_ru.png
│ └── emojis.json # Категории emoji
│
│ ├── 📁 core/ # ЯДРО - общие утилиты
│ │ ├── 📁 constants/ # Константы, включая AssetPaths.dart
│ │ ├── 📁 utils/ # Хелперы, extensions
│ │ ├── 📁 network/ # Dio, WebSocket клиенты
│ │ ├── 📁 database/ # Isar схемы, миграции
│ │ ├── 📁 storage/ # Управление кэшем и файлами
│ │ │ ├── 📁local_cache/ # Кэш загруженных медиа
│ │ │ │ ├── 📁images/ # Кэш аватарок, фото из чатов
│ │ │ │ ├── 📁videos/
│ │ │ │ ├── 📁documents/
│ │ │ │ └── 📁stickers/ # Скачанные стикеры
│ │ │ └── 📁temp/ # Временные файлы перед отправкой
│ │ │
│ │ ├── 📁 navigation/ # Маршруты, deep-linking
│ │ ├── 📁 themes/ # Цвета, текстовые стили, градиенты
│ │ ├── 📁 localization/ # arb-файлы, локализация
│ │ └── 📁 di/ # Dependency Injection
│ │
│ ├── 📁 features/ # ФИЧИ-МОДУЛИ (архитектура Clean + DDD)
│ │ ├── 📁 auth/ # Авторизация
│ │ │ ├── 📁 data/ # Data Layer
│ │ │ │ ├── 📁datasources/
│ │ │ │ ├── 📁models/ # DTO
│ │ │ │ ├── 📁repositories/
│ │ │ │ └── 📁mappers/
│ │ │ ├── 📁 domain/ # Domain Layer
│ │ │ │ ├── 📁entities/
│ │ │ │ ├── 📁repositories/
│ │ │ │ ├── 📁usecases/ # Login, Register, Logout
│ │ │ │ └── 📁failures/
│ │ │ └── 📁 presentation/# UI + State
│ │ │ ├── 📁 screens/ # LoginScreen, RegisterScreen
│ │ │ ├── 📁 widgets/ # Кастомные виджеты модуля
│ │ │ ├── 📁 bloc/ # AuthBloc, AuthState
│ │ │ └── 📁 views/
│ │ │
│ │ ├── 📁 chat/ # ЯДРО - ЧАТЫ И СООБЩЕНИЯ
│ │ │ ├── 📁 data/
│ │ │ ├── 📁 domain/ # Chat, Message, Attachment
│ │ │ └── 📁 presentation/# ChatScreen, MessageWidget
│ │ │
│ │ ├── 📁 contacts/ # Контакты
│ │ ├── 📁 calls/ # Звонки (WebRTC)
│ │ ├── 📁 profile/ # Профиль
│ │ ├── 📁 notifications/ # Уведомления
│ │ ├── 📁 media_gallery/ # Галерея медиа
│ │ └── 📁 search/ # Поиск
│ │
│ ├── 📁 shared/ # ПЕРЕИСПОЛЬЗУЕМЫЕ КОМПОНЕНТЫ
│ │ ├── 📁 widgets/ # Кнопки, диалоги, инпуты
│ │ ├── 📁 enums/ # Общие перечисления
│ │ ├── 📁 mixins/ # Миксины
│ │ └── 📁 services/ # Общие сервисы
│ │
│ └── 📁 packages/ # ВНУТРЕННИЕ DART-ПАКЕТЫ
│ ├── 📁 messaging_protocol/ # Протокол сообщений
│ ├── 📁 websocket_client/ # WebSocket клиент
│ └── 📁 encryption/ # Шифрование
│
├── 📁 scripts/ # CI/CD, codegen, линтинг

🔗 Ключевые связи между ассетами и кодом

1. Регистрация в pubspec.yaml:
   yaml

flutter:
assets: - assets/images/icons/ - assets/images/illustrations/ - assets/images/avatars/ - assets/sounds/ - assets/lottie/
fonts: - family: Inter
fonts: - asset: assets/fonts/Inter-Regular.ttf

2. Константы путей (lib/core/constants/asset_paths.dart):
   dart

abstract class AssetPaths {
// Иконки
static const String sendIcon = 'assets/images/icons/common/send.png';
static const String defaultAvatar = 'assets/images/avatars/default_1.png';

// Иллюстрации
static const String emptyChat = 'assets/images/illustrations/empty_chat.svg';

// Звуки
static const String notificationSound = 'assets/sounds/notification.mp3';

// Lottie
static const String typingAnimation = 'assets/lottie/typing.json';
}

🎯 Три типа хранения медиа в мессенджере
Тип | Где хранится | Пример

---

1. Статические ассеты | assets/ | Иконки приложения, дефолтные аватары
2. Локальный кэш | lib/core/storage/local_cache/ | Загруженные аватарки, фото из чатов
3. Облачное хранилище | AWS S3 / Firebase Storage | Пользовательские фото/видео, файлы

⚙️ Пример работы с разными типами ассетов
dart

// 1. Статический ассет (из assets/)
Image.asset(AssetPaths.defaultAvatar)

// 2. Кэшированное сетевое изображение
CachedNetworkImage(
imageUrl: user.avatarUrl,
placeholder: (ctx, url) =>
Image.asset(AssetPaths.defaultAvatar),
cacheManager: DefaultCacheManager(),
)

// 3. Локальный файл (из галереи или камеры)
Image.file(File(localFilePath))

// 4. Временный файл перед отправкой
// Хранится в lib/core/storage/temp/

📦 Важные пакеты для работы с ассетами
yaml

dependencies:

# Для SVG

flutter_svg: ^2.0.0

# Для кэширования сетевых изображений

cached_network_image: ^3.2.0

# Для Lottie анимаций

lottie: ^2.0.0

# Для работы с файлами

file_picker: ^5.0.0
image_picker: ^0.8.5
image_cropper: ^5.0.0

# Для видео и аудио

video_player: ^2.4.0
audio_session: ^0.1.0
just_audio: ^0.9.0

⚠️ Важные правила для мессенджера

    Оптимизация изображений:

        Используйте pngquant, svgo для сжатия

        Для иконок — SVG, для фото — WebP (с fallback на PNG)

        Разделяйте по density (1x, 2x, 3x)

    Звуки уведомлений:

        Длительность ≤ 3 секунды

        Формат MP3 с битрейтом 96-128 kbps

        Тестируйте на разных устройствах

    Стикеры:

        Рекомендуемый размер: 512x512px (PNG с прозрачностью)

        Ограничивайте размер файла (≤100KB на стикер)

        Храните метаданные в info.json (автор, теги, версия)

    Локальный кэш:
    dart

// Используйте cached_network_image для загружаемых аватарок
CachedNetworkImage(
imageUrl: user.avatarUrl,
placeholder: (context, url) => Image.asset(AssetPaths.defaultAvatar),
errorWidget: (context, url, error) => Image.asset(AssetPaths.defaultAvatar),
)

    Безопасность:

        Проверяйте MIME-типы загружаемых файлов

        Ограничивайте максимальный размер кэша

        Шифруйте чувствительные ассеты (если нужно)

Для хранения пользовательских аватарок, загруженных фото/видео используйте облачное хранилище (AWS S3, Firebase Storage) с CDN, а в приложении — только локальный кэш

Хелпер для загрузки
dart

class AssetHelper {
static Future<String> loadString(String path) async {
return await rootBundle.loadString(path);
}

static Future<ByteData> loadBytes(String path) async {
return await rootBundle.load(path);
}

// Для SVG через flutter_svg
static Widget loadSvg(String path, {double? width, double? height, Color? color}) {
return SvgPicture.asset(
path,
width: width,
height: height,
colorFilter: color != null
? ColorFilter.mode(color, BlendMode.srcIn)
: null,
);
}
}

🧩 Критически важные пакеты для pubspec.yaml
yaml

dependencies:
flutter:
sdk: flutter

# State Management (выберите один)

flutter_bloc: ^8.0.0 # ИЛИ riverpod: ^2.0.0

# Navigation

go_router: ^11.0.0 # Умный роутинг с deep-linking
auto_route: ^7.0.0 # Альтернатива с codegen

# Локальная база данных

isar: ^3.1.0 # Лучшая производительность
isar_flutter_libs: ^3.1.0
isar_generator: ^3.1.0

# Сетевое взаимодействие

dio: ^5.0.0 # HTTP-клиент
socket_io_client: ^2.0.0 # WebSocket для реального времени
web_socket_channel: ^2.0.0 # Альтернатива

# Dependency Injection

get_it: ^7.0.0
injectable: ^2.0.0

# Сериализация

freezed: ^2.0.0 # Data-классы + immutability
json_serializable: ^6.0.0

# UI & Анимации

flutter_svg: ^2.0.0
cached_network_image: ^3.0.0
lottie: ^2.0.0

# Безопасность

flutter_secure_storage: ^9.0.0
encrypt: ^5.0.0

# Уведомления

firebase_messaging: ^14.0.0

# Аудио/Видео звонки

flutter_webrtc: ^0.9.0

dev_dependencies:
build_runner: ^2.0.0
mockito: ^5.0.0
bloc_test: ^9.0.0
integration_test:
sdk: flutter

🔗 Схема зависимостей между слоями
text

Presentation Layer (UI) → Domain Layer → Data Layer
↑ ↑ ↑
Зависит от Зависит от Зависит от
Domain слоя внешних данных Core пакетов

---

## 📂 ТЕКУЩАЯ РЕАЛИЗАЦИЯ (Декабрь 2024)

### lib/

```
lib/
├── main.dart
├── core/
│   ├── constants/
│   │   └── asset_paths.dart
│   ├── di/
│   │   └── injection.dart
│   └── themes/
│       └── app_theme.dart
├── features/
│   └── auth/
│       └── presentation/
│           └── screens/
│               └── welcome_screen.dart
└── shared/
    └── widgets/
        ├── nebula_background.dart
        ├── nebula_button.dart
        └── nebula_logo.dart
```

### assets/

```
assets/
├── images/
│   ├── backgrounds/
│   │   └── nebula_cosmic_bg.png
│   └── logo/
│       ├── nebula_logo.png
│       ├── nebula_n_icon.png
│       └── nebula_n_transparent.png
└── lottie/
    └── Voice line _ wave animation.json
```

### Статус реализации

| Экран          | Статус         |
| -------------- | -------------- |
| WelcomeScreen  | ✅ Готов       |
| LoginScreen    | ⏳ Следующий   |
| RegisterScreen | ⏳ Планируется |
| ChatListScreen | ⏳ Планируется |

