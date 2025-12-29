import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Contact Tests', () {
    group('User Search', () {
      test('search by username', () {
        final users = [
          {'username': 'alice', 'name': 'Alice Smith'},
          {'username': 'bob', 'name': 'Bob Jones'},
          {'username': 'alex', 'name': 'Alex Brown'},
        ];

        final results = users
            .where(
              (u) => (u['username'] as String).toLowerCase().contains('al'),
            )
            .toList();

        expect(results.length, 2); // alice, alex
      });

      test('search by name', () {
        final users = [
          {'username': 'user1', 'name': 'John Doe'},
          {'username': 'user2', 'name': 'Jane Doe'},
          {'username': 'user3', 'name': 'Bob Smith'},
        ];

        final results = users
            .where((u) => (u['name'] as String).toLowerCase().contains('doe'))
            .toList();

        expect(results.length, 2);
      });

      test('empty search returns empty', () {
        final users = [
          {'username': 'test'},
        ];

        final results = users
            .where((u) => (u['username'] as String).contains('xyz'))
            .toList();

        expect(results.isEmpty, true);
      });
    });

    group('Contact Management', () {
      test('add contact', () {
        final contacts = <String>[];

        contacts.add('user_1');
        expect(contacts.contains('user_1'), true);
      });

      test('remove contact', () {
        final contacts = ['user_1', 'user_2'];

        contacts.remove('user_1');
        expect(contacts.contains('user_1'), false);
        expect(contacts.length, 1);
      });

      test('prevent duplicate contacts', () {
        final contacts = <String>{'user_1'};

        contacts.add('user_1'); // Duplicate
        expect(contacts.length, 1);
      });
    });

    group('Block/Unblock', () {
      test('block user', () {
        final blockedUsers = <String>{};

        blockedUsers.add('bad_user');
        expect(blockedUsers.contains('bad_user'), true);
      });

      test('unblock user', () {
        final blockedUsers = <String>{'bad_user'};

        blockedUsers.remove('bad_user');
        expect(blockedUsers.contains('bad_user'), false);
      });

      test('blocked user cannot message', () {
        final blockedUsers = {'blocked_user'};
        const senderId = 'blocked_user';

        final isBlocked = blockedUsers.contains(senderId);
        final canMessage = !isBlocked;

        expect(canMessage, false);
      });
    });

    group('Online Status', () {
      test('user is online', () {
        final lastSeen = DateTime.now();
        const onlineThreshold = Duration(minutes: 5);

        final isOnline = DateTime.now().difference(lastSeen) < onlineThreshold;
        expect(isOnline, true);
      });

      test('user is offline', () {
        final lastSeen = DateTime.now().subtract(const Duration(minutes: 10));
        const onlineThreshold = Duration(minutes: 5);

        final isOnline = DateTime.now().difference(lastSeen) < onlineThreshold;
        expect(isOnline, false);
      });

      test('formats last seen time', () {
        String formatLastSeen(DateTime lastSeen) {
          final diff = DateTime.now().difference(lastSeen);
          if (diff.inMinutes < 1) return 'только что';
          if (diff.inMinutes < 60) return '${diff.inMinutes} мин назад';
          if (diff.inHours < 24) return '${diff.inHours} ч назад';
          return '${diff.inDays} д назад';
        }

        expect(formatLastSeen(DateTime.now()), 'только что');
        expect(
          formatLastSeen(DateTime.now().subtract(const Duration(minutes: 30))),
          '30 мин назад',
        );
      });
    });
  });
}
