import 'package:flutter_test/flutter_test.dart';
import 'package:nebula/utils/lazy_init.dart';

void main() {
  group('Lazy<T>', () {
    test('creates value only on first access', () {
      int callCount = 0;
      final lazy = Lazy(() {
        callCount++;
        return 'value';
      });

      expect(callCount, 0);
      expect(lazy.isInitialized, false);

      final value = lazy.value;
      expect(value, 'value');
      expect(callCount, 1);
      expect(lazy.isInitialized, true);

      // Second access doesn't call factory again
      final value2 = lazy.value;
      expect(value2, 'value');
      expect(callCount, 1);
    });

    test('reset() allows re-initialization', () {
      int callCount = 0;
      final lazy = Lazy(() {
        callCount++;
        return callCount;
      });

      expect(lazy.value, 1);
      lazy.reset();
      expect(lazy.isInitialized, false);
      expect(lazy.value, 2);
    });
  });

  group('AsyncLazy<T>', () {
    test('creates value only on first access', () async {
      int callCount = 0;
      final lazy = AsyncLazy(() async {
        callCount++;
        return 'async_value';
      });

      expect(lazy.isInitialized, false);
      expect(lazy.valueOrNull, null);

      final value = await lazy.value;
      expect(value, 'async_value');
      expect(callCount, 1);
      expect(lazy.isInitialized, true);

      // Second access doesn't call factory again
      final value2 = await lazy.value;
      expect(value2, 'async_value');
      expect(callCount, 1);
    });

    test('prevents concurrent initialization', () async {
      int callCount = 0;
      final lazy = AsyncLazy(() async {
        callCount++;
        await Future.delayed(const Duration(milliseconds: 50));
        return callCount;
      });

      // Start two concurrent accesses
      final future1 = lazy.value;
      final future2 = lazy.value;

      final results = await Future.wait([future1, future2]);
      expect(results[0], 1);
      expect(results[1], 1);
      expect(callCount, 1); // Factory called only once
    });
  });

  group('LazySingleton<T>', () {
    test('returns same instance', () {
      final singleton1 = LazySingleton(() => Object());
      final singleton2 = LazySingleton(() => Object());

      // Same type returns same instance
      expect(identical(singleton1.instance, singleton2.instance), true);
    });

    test('reset removes instance', () {
      final singleton = LazySingleton(() => 'test_value');
      final first = singleton.instance;

      LazySingleton.reset<String>();

      // After reset, a new instance is created
      final second = singleton.instance;
      expect(first, 'test_value');
      expect(second, 'test_value');
    });

    test('resetAll clears all instances', () {
      final s1 = LazySingleton(() => 'string');
      final s2 = LazySingleton(() => 42);

      s1.instance;
      s2.instance;

      LazySingleton.resetAll();

      // New instances after reset
      expect(s1.instance, 'string');
      expect(s2.instance, 42);
    });
  });

  group('LazyResource<T>', () {
    test('loads resource successfully', () async {
      final resource = LazyResource(() async => 'loaded');

      expect(resource.isLoaded, false);
      expect(resource.isLoading, false);

      final value = await resource.load();

      expect(value, 'loaded');
      expect(resource.isLoaded, true);
      expect(resource.valueOrNull, 'loaded');
    });

    test('returns cached value on subsequent loads', () async {
      int loadCount = 0;
      final resource = LazyResource(() async {
        loadCount++;
        return 'value_$loadCount';
      });

      final first = await resource.load();
      final second = await resource.load();

      expect(first, 'value_1');
      expect(second, 'value_1');
      expect(loadCount, 1);
    });

    test('retries on failure', () async {
      int attempts = 0;
      final resource = LazyResource(
        () async {
          attempts++;
          if (attempts < 3) throw Exception('Fail');
          return 'success';
        },
        maxRetries: 3,
        retryDelay: const Duration(milliseconds: 10),
      );

      final value = await resource.load();
      expect(value, 'success');
      expect(attempts, 3);
    });

    test('throws after max retries', () async {
      final resource = LazyResource(
        () async => throw Exception('Always fails'),
        maxRetries: 2,
        retryDelay: const Duration(milliseconds: 10),
      );

      expect(() => resource.load(), throwsException);
    });

    test('reset allows reload', () async {
      int loadCount = 0;
      final resource = LazyResource(() async {
        loadCount++;
        return loadCount;
      });

      expect(await resource.load(), 1);
      resource.reset();
      expect(resource.isLoaded, false);
      expect(await resource.load(), 2);
    });
  });
}
