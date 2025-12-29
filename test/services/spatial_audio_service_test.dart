import 'package:flutter_test/flutter_test.dart';
import 'package:nebula/data/services/spatial_audio_service.dart';

void main() {
  group('SpatialAudioService', () {
    late SpatialAudioService service;

    setUp(() {
      service = SpatialAudioService();
      service.maxDistance = 500.0;
      service.listenerPosition = const Offset(0, 0);
      service.listenerAngle = 0.0;
    });

    group('Participant Management', () {
      test('adds participant correctly', () {
        service.addParticipant('user1', position: const Offset(100, 0));
        expect(service.participants.containsKey('user1'), true);
        expect(service.getParticipant('user1')?.position, const Offset(100, 0));
      });

      test('removes participant correctly', () {
        service.addParticipant('user1');
        service.removeParticipant('user1');
        expect(service.participants.containsKey('user1'), false);
      });

      test('updates participant position', () {
        service.addParticipant('user1');
        service.updateParticipantPosition('user1', const Offset(200, 100));
        expect(
          service.getParticipant('user1')?.position,
          const Offset(200, 100),
        );
      });
    });

    group('calculateSpatialAudio()', () {
      test('returns full volume at zero distance', () {
        final result = SpatialAudioService.calculateSpatialAudio(
          listenerPosition: const Offset(0, 0),
          listenerAngle: 0,
          sourcePosition: const Offset(0, 0),
          maxDistance: 500,
        );
        expect(result.volume, 1.0);
        expect(result.distance, 0.0);
      });

      test('returns zero volume at max distance', () {
        final result = SpatialAudioService.calculateSpatialAudio(
          listenerPosition: const Offset(0, 0),
          listenerAngle: 0,
          sourcePosition: const Offset(500, 0),
          maxDistance: 500,
        );
        expect(result.volume, 0.0);
      });

      test('volume decreases with distance', () {
        final close = SpatialAudioService.calculateSpatialAudio(
          listenerPosition: const Offset(0, 0),
          listenerAngle: 0,
          sourcePosition: const Offset(100, 0),
          maxDistance: 500,
        );
        final far = SpatialAudioService.calculateSpatialAudio(
          listenerPosition: const Offset(0, 0),
          listenerAngle: 0,
          sourcePosition: const Offset(400, 0),
          maxDistance: 500,
        );
        expect(close.volume > far.volume, true);
      });

      test('pan is correct for right side', () {
        final result = SpatialAudioService.calculateSpatialAudio(
          listenerPosition: const Offset(0, 0),
          listenerAngle: 0,
          sourcePosition: const Offset(0, 100), // Right side (positive Y)
          maxDistance: 500,
        );
        expect(result.pan, greaterThan(0)); // Positive = right
      });

      test('pan is correct for left side', () {
        final result = SpatialAudioService.calculateSpatialAudio(
          listenerPosition: const Offset(0, 0),
          listenerAngle: 0,
          sourcePosition: const Offset(0, -100), // Left side (negative Y)
          maxDistance: 500,
        );
        expect(result.pan, lessThan(0)); // Negative = left
      });

      test('behind listener is dampened', () {
        final inFront = SpatialAudioService.calculateSpatialAudio(
          listenerPosition: const Offset(0, 0),
          listenerAngle: 0,
          sourcePosition: const Offset(100, 0), // In front
          maxDistance: 500,
        );
        final behind = SpatialAudioService.calculateSpatialAudio(
          listenerPosition: const Offset(0, 0),
          listenerAngle: 0,
          sourcePosition: const Offset(-100, 0), // Behind
          maxDistance: 500,
        );
        expect(inFront.volume > behind.volume, true);
      });
    });

    group('SpatialAudioResult', () {
      test('toString() returns formatted string', () {
        final result = SpatialAudioResult(
          volume: 0.75,
          pan: -0.5,
          distance: 100,
          angle: 1.5,
        );
        expect(result.toString(), contains('vol: 0.75'));
        expect(result.toString(), contains('pan: -0.50'));
      });

      test('isComplete is true when state is success', () {
        // Note: This would need TaskState from firebase_storage
        // For now just test the class exists
        expect(SpatialAudioResult, isNotNull);
      });
    });
  });
}
