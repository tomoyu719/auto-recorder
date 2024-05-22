import 'dart:async';

import 'package:auto_recorder/features/recording/sound_monitor/sound_monitor.dart';
import 'package:auto_recorder/features/recording/sound_monitor/sound_util.dart';
import 'package:auto_recorder/features/shared_preferences.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('latestDetection', () {
    late ProviderContainer container;
    late StreamController<Duration> elapsedController;
    late StreamController<double> dbfsController;
    SharedPreferences.setMockInitialValues({});

    setUp(() async {
      final sharedPreferences = await SharedPreferences.getInstance();
      elapsedController = StreamController<Duration>();
      dbfsController = StreamController<double>();

      container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          elapsedProvider.overrideWith((ref) => elapsedController.stream),
          dbfsProvider.overrideWith((ref) => dbfsController.stream),
        ],
      );
    });

    tearDown(() {
      container.dispose();
      elapsedController.close();
      dbfsController.close();
    });

    test('should yield Duration.zero when isRecording is false', () async {
      container.read(isRecordingProvider.notifier).state = false;

      expect(
        await container.read(latestDetectionTimeProvider.future),
        equals(Duration.zero),
      );
    });

    test('''should yield elapsed duration when dbfs is above threshold and 
        isRecording is true''', () async {
      const elapsed = Duration(seconds: 5);
      container.read(isRecordingProvider.notifier).state = true;
      dbfsController.add(60);
      elapsedController.add(elapsed);
      container.read(thresholdDbfsProvider.notifier).state = 50;

      expect(
        await container.read(latestDetectionTimeProvider.future),
        equals(elapsed),
      );
    });

    test('''should not yield updated elapsed duration when dbfs is
     below threshold''', () async {
      container.read(isRecordingProvider.notifier).state = true;
      container.read(thresholdDbfsProvider.notifier).state = 50;
      elapsedController.add(const Duration(seconds: 5));

      dbfsController.add(60);

      expect(
        await container.read(latestDetectionTimeProvider.future),
        equals(const Duration(seconds: 5)),
      );

      elapsedController.add(const Duration(seconds: 10));

      dbfsController.add(40);

      expect(
        await container.read(latestDetectionTimeProvider.future),
        equals(const Duration(seconds: 5)),
      );
    });
  });
}
