// Главный файл для запуска ВСЕХ тестов
// Запуск: flutter test test/all_tests.dart

// ==================== AUTH ====================
import 'auth/firebase_auth_service_test.dart' as auth_service;
import 'auth/validation_test.dart' as validation;

// ==================== CHAT ====================
import 'chat/firestore_chat_service_test.dart' as chat_service;
import 'chat/message_model_test.dart' as message_model;

// ==================== STORIES ====================
import 'stories/firestore_thoughts_service_test.dart' as thoughts_service;

// ==================== CAPSULE ====================
import 'capsule/time_capsule_test.dart' as time_capsule;

// ==================== CONTACTS ====================
import 'contacts/contacts_test.dart' as contacts;

// ==================== SEARCH ====================
import 'search/search_test.dart' as search;

// ==================== SETTINGS ====================
import 'settings/settings_test.dart' as settings;

// ==================== SECURITY ====================
import 'security/encryption_service_test.dart' as encryption;
import 'security/stealth_mode_service_test.dart' as stealth;

// ==================== SERVICES ====================
import 'services/sentiment_service_test.dart' as sentiment;
import 'services/ai_persona_service_test.dart' as ai_persona;
import 'services/spatial_audio_service_test.dart' as spatial_audio;
import 'services/ar_avatar_service_test.dart' as ar_avatar;

// ==================== UTILS ====================
import 'utils/lazy_init_test.dart' as lazy_init;
import 'utils/isolate_utils_test.dart' as isolates;
import 'utils/responsive_layout_test.dart' as responsive;

// ==================== FIREBASE ====================
import 'firebase/firebase_test.dart' as firebase;

// ==================== WIDGETS ====================
import 'widgets/widgets_test.dart' as widgets;

// ==================== INTEGRATION ====================
import 'integration/integration_test.dart' as integration;

// ==================== PERFORMANCE ====================
import 'perf/performance_test.dart' as performance;

// ==================== MEDIA ====================
import 'media/media_test.dart' as media;

void main() {
  // Auth
  auth_service.main();
  validation.main();

  // Chat
  chat_service.main();
  message_model.main();

  // Stories
  thoughts_service.main();

  // Capsule
  time_capsule.main();

  // Contacts
  contacts.main();

  // Search
  search.main();

  // Settings
  settings.main();

  // Security
  encryption.main();
  stealth.main();

  // Services
  sentiment.main();
  ai_persona.main();
  spatial_audio.main();
  ar_avatar.main();

  // Utils
  lazy_init.main();
  isolates.main();
  responsive.main();

  // Firebase
  firebase.main();

  // Widgets
  widgets.main();

  // Integration
  integration.main();

  // Performance
  performance.main();

  // Media
  media.main();
}
