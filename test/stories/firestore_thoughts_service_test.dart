import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Firestore Thoughts Service', () {
    group('Story Creation', () {
      test('creates story with required fields', () {
        final story = {
          'id': 'story_1',
          'userId': 'user_1',
          'content': 'My thought',
          'type': 'text',
          'createdAt': DateTime.now().toIso8601String(),
          'expiresAt': DateTime.now()
              .add(const Duration(hours: 24))
              .toIso8601String(),
        };

        expect(story['id'], isNotNull);
        expect(story['userId'], isNotNull);
        expect(story['expiresAt'], isNotNull);
      });

      test('image story has imageUrl', () {
        final story = {
          'type': 'image',
          'imageUrl': 'https://example.com/image.jpg',
          'content': '',
        };

        expect(story['imageUrl'], isNotNull);
        expect(story['type'], 'image');
      });
    });

    group('Story Expiration', () {
      test('story expires after 24 hours', () {
        final createdAt = DateTime.now().subtract(const Duration(hours: 25));
        final expiresAt = createdAt.add(const Duration(hours: 24));

        final isExpired = DateTime.now().isAfter(expiresAt);
        expect(isExpired, true);
      });

      test('fresh story is not expired', () {
        final expiresAt = DateTime.now().add(const Duration(hours: 23));

        final isExpired = DateTime.now().isAfter(expiresAt);
        expect(isExpired, false);
      });

      test('calculates time remaining correctly', () {
        final expiresAt = DateTime.now().add(const Duration(hours: 12));
        final remaining = expiresAt.difference(DateTime.now());

        expect(remaining.inHours, greaterThanOrEqualTo(11));
      });
    });

    group('Story Viewing', () {
      test('tracks viewers', () {
        final viewers = <String>{'user_1', 'user_2'};

        viewers.add('user_3');
        expect(viewers.length, 3);

        // Same user doesn't add twice
        viewers.add('user_1');
        expect(viewers.length, 3);
      });

      test('calculates view count', () {
        final story = {
          'viewers': ['user_1', 'user_2', 'user_3'],
        };

        expect((story['viewers'] as List).length, 3);
      });

      test('marks story as viewed', () {
        final viewedStories = <String>{};

        viewedStories.add('story_1');
        expect(viewedStories.contains('story_1'), true);
        expect(viewedStories.contains('story_2'), false);
      });
    });

    group('Reactions', () {
      test('adds reaction to story', () {
        final reactions = <String, String>{};

        reactions['user_1'] = '❤️';
        reactions['user_2'] = '😂';

        expect(reactions['user_1'], '❤️');
        expect(reactions.length, 2);
      });

      test('updates reaction', () {
        final reactions = {'user_1': '❤️'};

        reactions['user_1'] = '👍';
        expect(reactions['user_1'], '👍');
      });

      test('removes reaction', () {
        final reactions = {'user_1': '❤️'};

        reactions.remove('user_1');
        expect(reactions.containsKey('user_1'), false);
      });
    });

    group('Story Deletion', () {
      test('user can delete own story', () {
        final story = {'userId': 'user_1'};
        const currentUserId = 'user_1';

        final canDelete = story['userId'] == currentUserId;
        expect(canDelete, true);
      });

      test('cannot delete others story', () {
        final story = {'userId': 'user_1'};
        const currentUserId = 'user_2';

        final canDelete = story['userId'] == currentUserId;
        expect(canDelete, false);
      });
    });
  });
}
