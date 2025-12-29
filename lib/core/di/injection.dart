import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

/// Инициализация Dependency Injection
Future<void> configureDependencies() async {
  // TODO: Регистрация сервисов, репозиториев, BLoC

  // Пример:
  // getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  // getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt()));
}
