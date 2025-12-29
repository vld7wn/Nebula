/// Пути к статическим ассетам приложения
abstract class AssetPaths {
  // === Иконки ===
  static const String sendIcon = 'assets/images/icons/common/send.png';
  static const String attachIcon = 'assets/images/icons/common/attach.png';
  static const String microphoneIcon =
      'assets/images/icons/common/microphone.png';

  // === Аватары ===
  static const String defaultAvatar = 'assets/images/avatars/default_1.png';
  static const String groupDefaultAvatar =
      'assets/images/avatars/group_default.png';

  // === Иллюстрации ===
  static const String emptyChat = 'assets/images/illustrations/empty_chat.svg';
  static const String noInternet =
      'assets/images/illustrations/no_internet.svg';
  static const String welcome = 'assets/images/illustrations/welcome.svg';

  // === Звуки ===
  static const String notificationSound = 'assets/sounds/notification.mp3';
  static const String messageSentSound = 'assets/sounds/message_sent.mp3';
  static const String callRingtone = 'assets/sounds/call_ringtone.mp3';

  // === Lottie анимации ===
  static const String typingAnimation = 'assets/lottie/typing.json';
  static const String sendingAnimation = 'assets/lottie/sending.json';
  static const String loadingAnimation = 'assets/lottie/loading.json';
}
