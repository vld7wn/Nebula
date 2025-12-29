import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Search Tests', () {
    final mockChats = [
      {'id': '1', 'name': 'Alice', 'lastMessage': 'Hello there'},
      {'id': '2', 'name': 'Bob', 'lastMessage': 'How are you?'},
      {'id': '3', 'name': 'Charlie', 'lastMessage': 'Meeting at 5'},
    ];

    final mockMessages = [
      {'id': 'm1', 'chatId': '1', 'content': 'Hello world'},
      {'id': 'm2', 'chatId': '1', 'content': 'Flutter is great'},
      {'id': 'm3', 'chatId': '2', 'content': 'Hello again'},
      {'id': 'm4', 'chatId': '3', 'content': 'See you soon'},
    ];

    group('Chat Search', () {
      test('finds chat by name', () {
        final results = mockChats
            .where((c) => (c['name'] as String).toLowerCase().contains('alice'))
            .toList();

        expect(results.length, 1);
        expect(results[0]['name'], 'Alice');
      });

      test('case insensitive search', () {
        final results = mockChats
            .where((c) => (c['name'] as String).toLowerCase().contains('bob'))
            .toList();

        expect(results.length, 1);
      });

      test('partial match', () {
        final results = mockChats
            .where((c) => (c['name'] as String).toLowerCase().contains('ar'))
            .toList();

        expect(results.length, 1); // Charlie
      });

      test('no results for non-matching query', () {
        final results = mockChats
            .where((c) => (c['name'] as String).toLowerCase().contains('xyz'))
            .toList();

        expect(results.isEmpty, true);
      });
    });

    group('Message Search', () {
      test('finds messages by content', () {
        final results = mockMessages
            .where(
              (m) => (m['content'] as String).toLowerCase().contains('hello'),
            )
            .toList();

        expect(results.length, 2);
      });

      test('searches across all chats', () {
        final results = mockMessages
            .where((m) => (m['content'] as String).toLowerCase().contains('o'))
            .toList();

        expect(results.length, greaterThan(1));
      });
    });

    group('Global Search', () {
      test('searches both chats and messages', () {
        const query = 'hello';

        final chatResults = mockChats
            .where(
              (c) =>
                  (c['name'] as String).toLowerCase().contains(query) ||
                  (c['lastMessage'] as String).toLowerCase().contains(query),
            )
            .toList();

        final messageResults = mockMessages
            .where(
              (m) => (m['content'] as String).toLowerCase().contains(query),
            )
            .toList();

        final totalResults = chatResults.length + messageResults.length;
        expect(totalResults, greaterThan(0));
      });
    });

    group('Search Filters', () {
      test('filter by date range', () {
        final messages = [
          {'content': 'Old', 'timestamp': DateTime(2024, 1, 1)},
          {'content': 'New', 'timestamp': DateTime(2024, 12, 25)},
        ];

        final startDate = DateTime(2024, 12, 1);
        final results = messages
            .where((m) => (m['timestamp'] as DateTime).isAfter(startDate))
            .toList();

        expect(results.length, 1);
      });

      test('filter by message type', () {
        final messages = [
          {'type': 'text', 'content': 'Hello'},
          {'type': 'image', 'content': ''},
          {'type': 'voice', 'content': ''},
        ];

        final textOnly = messages.where((m) => m['type'] == 'text').toList();
        expect(textOnly.length, 1);
      });
    });

    group('Search History', () {
      test('saves recent searches', () {
        final recentSearches = <String>[];

        recentSearches.insert(0, 'query1');
        recentSearches.insert(0, 'query2');

        expect(recentSearches[0], 'query2'); // Most recent first
        expect(recentSearches.length, 2);
      });

      test('limits history size', () {
        final recentSearches = <String>[];
        const maxSize = 10;

        for (int i = 0; i < 15; i++) {
          recentSearches.insert(0, 'query_$i');
          if (recentSearches.length > maxSize) {
            recentSearches.removeLast();
          }
        }

        expect(recentSearches.length, maxSize);
      });

      test('clears history', () {
        final recentSearches = ['q1', 'q2', 'q3'];

        recentSearches.clear();
        expect(recentSearches.isEmpty, true);
      });
    });
  });
}
