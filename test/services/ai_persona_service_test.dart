import 'package:flutter_test/flutter_test.dart';
import 'package:nebula/data/services/ai_persona_service.dart';

void main() {
  group('AIPersonaService Models', () {
    group('ChatMessage', () {
      test('creates with defaults', () {
        final message = ChatMessage(role: MessageRole.user, content: 'Hello');

        expect(message.role, MessageRole.user);
        expect(message.content, 'Hello');
        expect(message.timestamp, isNotNull);
      });

      test('serializes to JSON', () {
        final message = ChatMessage(
          role: MessageRole.assistant,
          content: 'Hi there',
          timestamp: DateTime(2024, 12, 25),
        );

        final json = message.toJson();

        expect(json['role'], 'assistant');
        expect(json['content'], 'Hi there');
        expect(json['timestamp'], '2024-12-25T00:00:00.000');
      });

      test('deserializes from JSON', () {
        final json = {
          'role': 'system',
          'content': 'You are helpful',
          'timestamp': '2024-12-25T12:00:00.000',
        };

        final message = ChatMessage.fromJson(json);

        expect(message.role, MessageRole.system);
        expect(message.content, 'You are helpful');
        expect(message.timestamp.year, 2024);
      });
    });

    group('PersonaConfig', () {
      test('default persona has correct values', () {
        final persona = PersonaConfig.defaultPersona();

        expect(persona.name, 'Nebula AI');
        expect(persona.avatarEmoji, '✨');
        expect(persona.systemPrompt, isNotEmpty);
      });

      test('professional persona has formal tone', () {
        final persona = PersonaConfig.professional();

        expect(persona.name, 'Professional');
        expect(persona.avatarEmoji, '👔');
        expect(persona.systemPrompt, contains('профессиональный'));
      });

      test('friendly persona has casual tone', () {
        final persona = PersonaConfig.friendly();

        expect(persona.name, 'Friendly');
        expect(persona.avatarEmoji, '😊');
        expect(persona.systemPrompt, contains('друг'));
      });

      test('serializes to JSON', () {
        final persona = PersonaConfig(
          name: 'Custom',
          description: 'My persona',
          systemPrompt: 'You are custom',
          avatarEmoji: '🎯',
        );

        final json = persona.toJson();

        expect(json['name'], 'Custom');
        expect(json['description'], 'My persona');
        expect(json['systemPrompt'], 'You are custom');
        expect(json['avatarEmoji'], '🎯');
      });

      test('deserializes from JSON', () {
        final json = {
          'name': 'Test',
          'description': 'Test persona',
          'systemPrompt': 'You are test',
          'avatarEmoji': '🧪',
        };

        final persona = PersonaConfig.fromJson(json);

        expect(persona.name, 'Test');
        expect(persona.avatarEmoji, '🧪');
      });

      test('uses default emoji if not provided', () {
        final json = {
          'name': 'NoEmoji',
          'description': 'No emoji',
          'systemPrompt': 'No emoji',
        };

        final persona = PersonaConfig.fromJson(json);

        expect(persona.avatarEmoji, '🤖');
      });
    });

    group('QuickAction', () {
      test('has all action types', () {
        expect(QuickAction.values.length, 5);
        expect(QuickAction.values, contains(QuickAction.summarize));
        expect(QuickAction.values, contains(QuickAction.translate));
        expect(QuickAction.values, contains(QuickAction.improve));
        expect(QuickAction.values, contains(QuickAction.explain));
        expect(QuickAction.values, contains(QuickAction.reply));
      });
    });

    group('AIProvider', () {
      test('has all providers', () {
        expect(AIProvider.values.length, 3);
        expect(AIProvider.values, contains(AIProvider.openai));
        expect(AIProvider.values, contains(AIProvider.claude));
        expect(AIProvider.values, contains(AIProvider.gemini));
      });
    });

    group('MessageRole', () {
      test('has all roles', () {
        expect(MessageRole.values.length, 3);
        expect(MessageRole.values, contains(MessageRole.system));
        expect(MessageRole.values, contains(MessageRole.user));
        expect(MessageRole.values, contains(MessageRole.assistant));
      });
    });
  });
}
