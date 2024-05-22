import 'dart:async';
import 'package:auto_recorder/features/recording/sound_monitor/sound_monitor.dart';
import 'package:auto_recorder/features/recording/sound_monitor/sound_util.dart';
import 'package:auto_recorder/features/shared_preferences.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('elapsedLastDetection', () {
    late ProviderContainer container;

    late StreamController<Duration> elapsedController;
    late StreamController<Duration> latestDetectionController;
    SharedPreferences.setMockInitialValues({});

    setUp(() async {
      final sharedPreferences = await SharedPreferences.getInstance();
      elapsedController = StreamController<Duration>();
      latestDetectionController = StreamController<Duration>();

      container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          elapsedProvider.overrideWith((ref) => elapsedController.stream),
          latestDetectionTimeProvider
              .overrideWith((ref) => latestDetectionController.stream),
        ],
      );
    });

    tearDown(() {
      container.dispose();
      elapsedController.close();
      latestDetectionController.close();
    });

    test('''should yield Duration.zero when isRecording is false, regardless of
         the value of elapsedProvider or latestDetectionProvider.''', () async {
      container.read(isRecordingProvider.notifier).state = false;
      const elapsed = Duration(seconds: 10);
      const latestDetection = Duration(seconds: 5);
      elapsedController.add(elapsed);
      latestDetectionController.add(latestDetection);

      final elapsedLastDetection =
          await container.read(elapsedLastDetectionProvider.future);
      expect(elapsedLastDetection, equals(Duration.zero));
    });

    test('''should yield the difference between elapsed and
         latestDetection durations when isRecording is true''', () async {
      container.read(isRecordingProvider.notifier).state = true;
      const elapsed = Duration(seconds: 10);

      const latestDetection = Duration(seconds: 5);
      elapsedController.add(elapsed);
      latestDetectionController.add(latestDetection);

      final elapsedLastDetection =
          await container.read(elapsedLastDetectionProvider.future);

      expect(elapsedLastDetection, equals(elapsed - latestDetection));
    });
  });
}
