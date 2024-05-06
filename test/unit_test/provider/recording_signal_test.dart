import 'dart:async';

import 'package:auto_recorder/providers/dbfs/dbfs.dart';
import 'package:auto_recorder/providers/is_recording.dart';
import 'package:auto_recorder/providers/remain/remain_duration.dart';
import 'package:auto_recorder/providers/threshold/threshold_dbfs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:auto_recorder/providers/recording_signal/recording_signal.dart';

void main() {
  group('startRecordingProvider', () {
    late StreamController<double> dbfsController;
    late ProviderContainer container;
    setUp(() {
      dbfsController = StreamController<double>();
      container = ProviderContainer(overrides: [
        dbSplProvider.overrideWith((ref) => dbfsController.stream),
      ]);
    });
    tearDown(() {
      container.dispose();
      dbfsController.close();
    });
    test(
        'should yield false when isRecording is false, regardless of dbfs is below threshold',
        () async {
      container.read(isRecordingProvider.notifier).state = false;
      const dbfs = 5.0;
      dbfsController.add(dbfs);
      const threshold = 10;
      container.read(thresholdDbSplProvider.notifier).state = threshold;
      expect(container.read(isRecordingProvider), isFalse);
      final dbfsValue = await container.read(dbSplProvider.future);
      final thresholdValue = container.read(thresholdDbSplProvider);
      expect(dbfsValue, lessThan(thresholdValue));
      expect(await container.read(startRecordingProvider.future), isFalse);
    });

    test(
        'should yield false when dbfs is above or equal to threshold, but isRecording is true',
        () async {
      container.read(isRecordingProvider.notifier).state = true;
      const dbfs = 10.0;
      dbfsController.add(dbfs);
      const threshold = 5;
      container.read(thresholdDbSplProvider.notifier).state = threshold;
      expect(container.read(isRecordingProvider), isTrue);
      final dbfsValue = await container.read(dbSplProvider.future);
      final thresholdValue = container.read(thresholdDbSplProvider);
      expect(dbfsValue, greaterThanOrEqualTo(thresholdValue));
      expect(await container.read(startRecordingProvider.future), isFalse);
    });
    test(
        'should yield true when isRecording is false and dbfs is above or equal to threshold',
        () async {
      container.read(isRecordingProvider.notifier).state = false;
      const dbfs = 10.0;
      dbfsController.add(dbfs);
      const threshold = 5;
      container.read(thresholdDbSplProvider.notifier).state = threshold;

      expect(container.read(isRecordingProvider), isFalse);
      final dbfsValue = await container.read(dbSplProvider.future);
      final thresholdValue = container.read(thresholdDbSplProvider);
      expect(dbfsValue, greaterThanOrEqualTo(thresholdValue));

      expect(await container.read(startRecordingProvider.future), isTrue);
    });
  });
  group('stopRecording', () {
    late StreamController<Duration> remainController;

    late ProviderContainer container;
    setUp(() {
      remainController = StreamController<Duration>();
      container = ProviderContainer(overrides: [
        remainProvider.overrideWith((ref) => remainController.stream),
      ]);
    });
    tearDown(() {
      container.dispose();
      remainController.close();
    });

    test(
        'should yield false when isRecording is true, but remain is above Duration.zero',
        () async {
      container.read(isRecordingProvider.notifier).state = true;
      remainController.add(const Duration(seconds: 5));

      expect(container.read(isRecordingProvider), isTrue);
      final remain = await container.read(remainProvider.future);
      expect(remain, greaterThan(Duration.zero));
      expect(await container.read(stopRecordingProvider.future), isFalse);
    });
    test(
        'should yield false when remain is below or equal to Duration.zero, but isRecording is false',
        () async {
      container.read(isRecordingProvider.notifier).state = false;
      remainController.add(Duration.zero);
      expect(container.read(isRecordingProvider), isFalse);
      final remain = await container.read(remainProvider.future);
      expect(remain, lessThanOrEqualTo(Duration.zero));
      expect(await container.read(stopRecordingProvider.future), isFalse);
    });

    test(
        'should yield true when isRecording is true and remain is below or equal to Duration.zero',
        () async {
      container.read(isRecordingProvider.notifier).state = true;
      remainController.add(Duration.zero);

      expect(container.read(isRecordingProvider), isTrue);
      final remain = await container.read(remainProvider.future);
      expect(remain, lessThanOrEqualTo(Duration.zero));
      expect(await container.read(stopRecordingProvider.future), isTrue);
    });
  });
}
