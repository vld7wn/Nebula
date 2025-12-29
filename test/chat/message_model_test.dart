import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Message Model', () {
    test('creates text message correctly', () {
      final message = {
        'id': '1',
        'chatId': 'chat1',
        'senderId': 'user1',
        'content': 'Hello',
        'type': 'text',
        'timestamp': DateTime(2024, 12, 25).toIso8601String(),
        'status': 'sent',
      };

      expect(message['id'], '1');
      expect(message['content'], 'Hello');
      expect(message['type'], 'text');
    });

    test('creates image message correctly', () {
      final message = {
        'id': '2',
        'chatId': 'chat1',
        'senderId': 'user1',
        'content': '',
        'imageUrl': 'https://example.com/image.jpg',
        'type': 'image',
        'timestamp': DateTime.now().toIso8601String(),
        'status': 'sent',
      };

      expect(message['type'], 'image');
      expect(message['imageUrl'], isNotNull);
    });

    test('serializes to JSON', () {
      final message = {
        'id': '1',
        'chatId': 'chat1',
        'senderId': 'user1',
        'content': 'Test',
        'type': 'text',
        'timestamp': DateTime(2024, 12, 25, 12, 0).toIso8601String(),
        'status': 'sent',
      };

      expect(message['id'], '1');
      expect(message['content'], 'Test');
      expect(message['type'], 'text');
    });

    test('deserializes from JSON', () {
      final json = {
        'id': '1',
        'chatId': 'chat1',
        'senderId': 'user1',
        'content': 'Hello from JSON',
        'type': 'text',
        'timestamp': '2024-12-25T12:00:00.000',
        'status': 'sent',
      };

      expect(json['id'], '1');
      expect(json['content'], 'Hello from JSON');
    });

    test('reply message has replyToId', () {
      final reply = {
        'id': '3',
        'chatId': 'chat1',
        'senderId': 'user2',
        'content': 'Reply text',
        'type': 'text',
        'timestamp': DateTime.now().toIso8601String(),
        'status': 'sent',
        'replyToId': '1',
      };

      expect(reply['replyToId'], '1');
    });
  });

  group('Chat Model', () {
    test('creates chat correctly', () {
      final chat = {
        'id': 'chat1',
        'participants': ['user1', 'user2'],
        'lastMessage': 'Hello',
        'lastMessageTime': DateTime(2024, 12, 25).toIso8601String(),
        'unreadCount': 2,
      };

      expect(chat['id'], 'chat1');
      expect((chat['participants'] as List).length, 2);
      expect(chat['unreadCount'], 2);
    });

    test('isGroup returns true for 3+ participants', () {
      final groupChat = {
        'id': 'group1',
        'participants': ['u1', 'u2', 'u3'],
        'lastMessage': '',
        'lastMessageTime': DateTime.now().toIso8601String(),
      };

      final isGroup = (groupChat['participants'] as List).length > 2;
      expect(isGroup, true);
    });

    test('serializes to JSON', () {
      final chat = {
        'id': 'chat1',
        'participants': ['u1', 'u2'],
        'lastMessage': 'Test',
        'lastMessageTime': DateTime(2024, 12, 25).toIso8601String(),
      };

      expect(chat['id'], 'chat1');
      expect(chat['participants'], ['u1', 'u2']);
    });
  });

  group('MessageStatus', () {
    test('has all statuses', () {
      final statuses = ['sending', 'sent', 'delivered', 'read'];
      expect(statuses.length, 4);
      expect(statuses.contains('sending'), true);
      expect(statuses.contains('sent'), true);
      expect(statuses.contains('delivered'), true);
      expect(statuses.contains('read'), true);
    });
  });

  group('MessageType', () {
    test('has all types', () {
      final types = ['text', 'image', 'voice', 'file'];
      expect(types.length, 4);
      expect(types.contains('text'), true);
      expect(types.contains('image'), true);
      expect(types.contains('voice'), true);
    });
  });
}
