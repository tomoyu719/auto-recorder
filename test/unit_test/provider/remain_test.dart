import 'dart:async';
import 'package:auto_recorder/providers/shared_preferences.dart';
import 'package:auto_recorder/providers/waiting_time/waiting_time.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:riverpod/riverpod.dart';

import 'package:auto_recorder/providers/elapsed_last_detection/elapsed_last_detection.dart';
import 'package:auto_recorder/providers/is_recording.dart';
import 'package:auto_recorder/providers/remain/remain_duration.dart';
// For some reason, overriding the provider does not change the value if it is an absolute path.
// import 'package:auto_recorder/providers/remain/remain_duration.dart';

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

    test('should yield waitingTime when isRecording is false', () async {
      final waitingTime = container.read(waitingTimeProvider);
      container.read(isRecordingProvider.notifier).state = false;

      expect(await container.read(remainProvider.future), waitingTime);
    });

    test('should yield remain when isRecording is true', () async {
      const waitingTime = Duration(seconds: 10);
      const elapsedLastDetection = Duration(seconds: 5);
      final expectedRemain = waitingTime - elapsedLastDetection;

      elapsedLastDetectionController.add(elapsedLastDetection);
      container.read(waitingTimeProvider.notifier).state = waitingTime;
      container.read(isRecordingProvider.notifier).state = true;

      expect(await container.read(remainProvider.future), expectedRemain);
    });

    test('should yield Duration.zero when remain is negative', () async {
      const waitingTime = Duration(seconds: 5);
      const elapsedLastDetection = Duration(seconds: 15);
      container.read(waitingTimeProvider.notifier).state = waitingTime;

      container.read(isRecordingProvider.notifier).state = true;
      elapsedLastDetectionController.add(elapsedLastDetection);

      expect(await container.read(remainProvider.future), Duration.zero);
    });
  });
}
