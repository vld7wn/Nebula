import 'package:flutter_test/flutter_test.dart';
import 'package:nebula/data/services/ar_avatar_service.dart';

void main() {
  group('ARAvatarService Models', () {
    group('FaceTrackingData', () {
      test('creates from map', () {
        final map = {
          'posX': 1.0,
          'posY': 2.0,
          'posZ': 3.0,
          'rotX': 0.1,
          'rotY': 0.2,
          'rotZ': 0.3,
          'eyeBlinkLeft': 0.5,
          'eyeBlinkRight': 0.6,
          'mouthSmileLeft': 0.8,
          'mouthSmileRight': 0.9,
        };

        final data = FaceTrackingData.fromMap(map);

        expect(data.posX, 1.0);
        expect(data.posY, 2.0);
        expect(data.posZ, 3.0);
        expect(data.eyeBlinkLeft, 0.5);
        expect(data.eyeBlinkRight, 0.6);
        expect(data.mouthSmileLeft, 0.8);
      });

      test('handles missing values with defaults', () {
        final data = FaceTrackingData.fromMap({});

        expect(data.posX, 0.0);
        expect(data.eyeBlinkLeft, 0.0);
        expect(data.mouthOpen, 0.0);
      });

      test('has timestamp', () {
        final data = FaceTrackingData.fromMap({});
        expect(data.timestamp, isNotNull);
      });
    });

    group('AvatarPreset', () {
      test('creates correctly', () {
        const preset = AvatarPreset(
          id: 'test_avatar',
          name: 'Test Avatar',
          emoji: '🎭',
          modelPath: 'assets/test.glb',
          primaryColor: 0xFF000000,
        );

        expect(preset.id, 'test_avatar');
        expect(preset.name, 'Test Avatar');
        expect(preset.emoji, '🎭');
        expect(preset.modelPath, 'assets/test.glb');
        expect(preset.primaryColor, 0xFF000000);
      });
    });

    group('FaceExpression', () {
      test('has all expressions', () {
        expect(FaceExpression.values.length, 8);
        expect(FaceExpression.values, contains(FaceExpression.neutral));
        expect(FaceExpression.values, contains(FaceExpression.happy));
        expect(FaceExpression.values, contains(FaceExpression.sad));
        expect(FaceExpression.values, contains(FaceExpression.angry));
        expect(FaceExpression.values, contains(FaceExpression.surprised));
        expect(FaceExpression.values, contains(FaceExpression.wink));
        expect(FaceExpression.values, contains(FaceExpression.kiss));
        expect(FaceExpression.values, contains(FaceExpression.silly));
      });
    });
  });

  group('ARAvatarService', () {
    late ARAvatarService service;

    setUp(() {
      service = ARAvatarService();
    });

    test('has 6 available avatars', () {
      expect(service.availableAvatars.length, 6);
    });

    test('avatars have unique IDs', () {
      final ids = service.availableAvatars.map((a) => a.id).toSet();
      expect(ids.length, 6);
    });

    test('avatars have emoji', () {
      for (final avatar in service.availableAvatars) {
        expect(avatar.emoji, isNotEmpty);
      }
    });

    test('default avatar is nebula_cat', () {
      expect(service.selectedAvatarId, 'nebula_cat');
    });

    test('selectedAvatar returns correct preset', () {
      final selected = service.selectedAvatar;
      expect(selected.id, 'nebula_cat');
      expect(selected.emoji, '🐱');
    });

    test('getCurrentExpression returns neutral by default', () {
      final expression = service.getCurrentExpression();
      expect(expression, FaceExpression.neutral);
    });

    test('isTracking is false by default', () {
      expect(service.isTracking, false);
    });

    test('lastFaceData is null by default', () {
      expect(service.lastFaceData, isNull);
    });
  });
}
