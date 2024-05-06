import 'dart:async';

import 'package:auto_recorder/providers/dbfs/dbfs.dart';
import 'package:auto_recorder/providers/elapsed/elapsed.dart';
import 'package:auto_recorder/providers/is_recording.dart';
import 'package:auto_recorder/providers/latest_detection/latest_detection.dart';
import 'package:auto_recorder/providers/threshold/threshold_dbfs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  group('latestDetection', () {
    late ProviderContainer container;
    late StreamController<Duration> elapsedController;
    late StreamController<double> dbfsController;

    setUp(() {
      elapsedController = StreamController<Duration>();
      dbfsController = StreamController<double>();

      container = ProviderContainer(overrides: [
        elapsedProvider.overrideWith((ref) => elapsedController.stream),
        dbSplProvider.overrideWith((ref) => dbfsController.stream),
      ]);
    });

    tearDown(() {
      container.dispose();
      elapsedController.close();
      dbfsController.close();
    });

    test('should yield Duration.zero when isRecording is false', () async {
      container.read(isRecordingProvider.notifier).state = false;

      expect(await container.read(latestDetectionProvider.future),
          equals(Duration.zero));
    });

    test(
        'should yield elapsed duration when dbfs is above threshold and isRecording is true',
        () async {
      const elapsed = Duration(seconds: 5);
      container.read(isRecordingProvider.notifier).state = true;
      dbfsController.add(60.0);
      elapsedController.add(elapsed);
      container.read(thresholdDbSplProvider.notifier).state = 50;

      expect(await container.read(latestDetectionProvider.future),
          equals(elapsed));
    });

    test(
        'should not yield updated elapsed duration when dbfs is below threshold',
        () async {
      container.read(isRecordingProvider.notifier).state = true;
      container.read(thresholdDbSplProvider.notifier).state = 50;
      elapsedController.add(const Duration(seconds: 5));
      dbfsController.add(60.0);

      expect(await container.read(latestDetectionProvider.future),
          equals(const Duration(seconds: 5)));

      elapsedController.add(const Duration(seconds: 10));
      dbfsController.add(40.0);

      expect(await container.read(latestDetectionProvider.future),
          equals(const Duration(seconds: 5)));
    });
  });
}
