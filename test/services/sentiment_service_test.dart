import 'package:flutter_test/flutter_test.dart';
import 'package:nebula/data/services/sentiment_service.dart';

void main() {
  group('SentimentAnalysisService', () {
    late SentimentAnalysisService service;

    setUp(() {
      service = SentimentAnalysisService();
    });

    group('analyze()', () {
      test('returns neutral for empty string', () {
        final result = service.analyze('');
        expect(result.mood, Mood.neutral);
        expect(result.score, 0.0);
      });

      test('detects positive sentiment in Russian', () {
        final result = service.analyze('Это отлично! Супер!');
        expect(result.isPositive, true);
        expect(result.mood, anyOf(Mood.positive, Mood.veryPositive));
      });

      test('detects positive sentiment in English', () {
        final result = service.analyze('This is awesome! Great job!');
        expect(result.isPositive, true);
      });

      test('detects negative sentiment in Russian', () {
        final result = service.analyze('Это ужасно. Плохо.');
        expect(result.isNegative, true);
        expect(result.mood, anyOf(Mood.negative, Mood.veryNegative));
      });

      test('detects negative sentiment in English', () {
        final result = service.analyze('This is terrible. I hate it.');
        expect(result.isNegative, true);
      });

      test('handles negation correctly', () {
        final positive = service.analyze('Это хорошо');
        final negated = service.analyze('Это не хорошо');
        expect(positive.score > negated.score, true);
      });

      test('handles intensifiers', () {
        final normal = service.analyze('Это дело вполне хорошо');
        final intensified = service.analyze('Это дело вполне очень хорошо');
        expect(intensified.score > normal.score, true);
      });

      test('detects positive emoji', () {
        final result = service.analyze('Привет! 😍❤️');
        expect(result.isPositive, true);
        expect(result.positiveCount, greaterThan(0));
      });

      test('detects negative emoji', () {
        final result = service.analyze('Грустно 😢😭');
        expect(result.isNegative, true);
        expect(result.negativeCount, greaterThan(0));
      });
    });

    group('quickMood()', () {
      test('returns Mood enum', () {
        final mood = service.quickMood('Хорошо');
        expect(mood, isA<Mood>());
      });
    });

    group('moodEmoji()', () {
      test('returns emoji for each mood', () {
        expect(service.moodEmoji(Mood.veryPositive), '😍');
        expect(service.moodEmoji(Mood.positive), '😊');
        expect(service.moodEmoji(Mood.neutral), '😐');
        expect(service.moodEmoji(Mood.negative), '😔');
        expect(service.moodEmoji(Mood.veryNegative), '😢');
      });
    });

    group('moodColor()', () {
      test('returns color for each mood', () {
        expect(service.moodColor(Mood.veryPositive), 0xFF4CAF50);
        expect(service.moodColor(Mood.neutral), 0xFF9E9E9E);
        expect(service.moodColor(Mood.veryNegative), 0xFFF44336);
      });
    });
  });
}
