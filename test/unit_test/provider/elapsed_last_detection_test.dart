import 'dart:async';
import 'package:auto_recorder/providers/elapsed/elapsed.dart';
import 'package:auto_recorder/providers/elapsed_last_detection/elapsed_last_detection.dart';
import 'package:auto_recorder/providers/is_recording.dart';
import 'package:auto_recorder/providers/latest_detection/latest_detection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  group('elapsedLastDetection', () {
    late ProviderContainer container;

    late StreamController<Duration> elapsedController;
    late StreamController<Duration> latestDetectionController;

    setUp(() {
      elapsedController = StreamController<Duration>();
      latestDetectionController = StreamController<Duration>();

      container = ProviderContainer(overrides: [
        elapsedProvider.overrideWith(((ref) => elapsedController.stream)),
        latestDetectionProvider
            .overrideWith((ref) => latestDetectionController.stream),
      ]);
    });

    tearDown(() {
      container.dispose();
      elapsedController.close();
      latestDetectionController.close();
    });

    test(
        'should yield Duration.zero when isRecording is false, regardless of the value of elapsedProvider or latestDetectionProvider.',
        () async {
      container.read(isRecordingProvider.notifier).state = false;
      const elapsed = Duration(seconds: 10);
      const latestDetection = Duration(seconds: 5);

      elapsedController.add(elapsed);
      latestDetectionController.add(latestDetection);

      final elapsedLastDetection =
          await container.read(elapsedLastDetectionProvider.future);
      expect(elapsedLastDetection, equals(Duration.zero));
    });

    test(
        'should yield the difference between elapsed and latestDetection durations when isRecording is true',
        () async {
      container.read(isRecordingProvider.notifier).state = true;
      const elapsed = Duration(seconds: 10);
      const latestDetection = Duration(seconds: 5);
      elapsedController.add(elapsed);
      latestDetectionController.add(latestDetection);
      final elapsedLastDetection =
          await container.read(elapsedLastDetectionProvider.future);

      expect(elapsedLastDetection, equals(elapsed - latestDetection));
    });
    test(
        'should not yield any value when elapsed or detected is null and isRecording is true',
        () async {
      container.read(isRecordingProvider.notifier).state = true;

      final elapsedLastDetection =
          container.read(elapsedLastDetectionProvider.future);

      await expectLater(elapsedLastDetection, doesNotComplete);
    });
  });
}
