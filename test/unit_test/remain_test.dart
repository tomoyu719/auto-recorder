import 'dart:async';

import 'package:auto_recorder/features/recording/sound_monitor/sound_monitor.dart';
import 'package:auto_recorder/features/recording/sound_monitor/sound_util.dart';
import 'package:auto_recorder/features/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('remain', () {
    late ProviderContainer container;
    late StreamController<Duration> elapsedLastDetectionController;
    SharedPreferences.setMockInitialValues({});

    setUp(() async {
      final sharedPreferences = await SharedPreferences.getInstance();
      elapsedLastDetectionController = StreamController<Duration>();
      container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          elapsedLastDetectionProvider
              .overrideWith((_) => elapsedLastDetectionController.stream),
        ],
      );
    });

    tearDown(() {
      container.dispose();
      elapsedLastDetectionController.close();
    });

    test('should return waitingTime when isRecording is false', () async {
      container.read(isRecordingProvider.notifier).state = false;

      elapsedLastDetectionController.add(const Duration(seconds: 10));
      final waitingTime = container.read(waitingTimeProvider);

      expect(await container.read(remainProvider.future), waitingTime);
    });

    test('should return remain when isRecording is true', () async {
      const waitingTime = Duration(seconds: 10);
      const elapsedLastDetection = Duration(seconds: 5);

      container.read(isRecordingProvider.notifier).state = true;
      container.read(waitingTimeProvider.notifier).state = waitingTime;
      elapsedLastDetectionController.add(elapsedLastDetection);

      expect(
        await container.read(remainProvider.future),
        waitingTime - elapsedLastDetection,
      );
    });

    test('should return Duration.zero when remain is negative', () async {
      const waitingTime = Duration(seconds: 5);
      const elapsedLastDetection = Duration(seconds: 15);
      container.read(waitingTimeProvider.notifier).state = waitingTime;

      container.read(isRecordingProvider.notifier).state = true;

      elapsedLastDetectionController.add(elapsedLastDetection);
      expect(
        await container.read(elapsedLastDetectionProvider.future),
        elapsedLastDetection,
      );

      expect(await container.read(remainProvider.future), Duration.zero);
    });
  });
}
