import 'dart:async';

import 'package:auto_recorder/features/recording/sound_monitor/sound_monitor.dart';
import 'package:auto_recorder/features/recording/sound_monitor/sound_util.dart';
import 'package:auto_recorder/features/shared_preferences.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('recordingSignal', () {
    late StreamController<double> dbfsController;
    late StreamController<Duration> elapsedController;
    late StreamController<Duration> remainController;
    late ProviderContainer container;
    SharedPreferences.setMockInitialValues({});

    setUp(() async {
      final sharedPreferences = await SharedPreferences.getInstance();
      dbfsController = StreamController<double>();
      elapsedController = StreamController<Duration>();
      remainController = StreamController<Duration>();
      container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          dbfsProvider.overrideWith((ref) => dbfsController.stream),
          elapsedProvider.overrideWith((ref) => elapsedController.stream),
          remainProvider.overrideWith((ref) => remainController.stream),
        ],
      );
    });

    tearDown(() {
      container.dispose();
      dbfsController.close();
      elapsedController.close();
      remainController.close();
    });

    test('''should yield RecordingSignal.startRecording when 
    dbfs > threshold and isRecording is false''', () async {
      container.read(isRecordingProvider.notifier).state = false;
      container.read(thresholdDbfsProvider.notifier).state = 10;
      dbfsController.add(15);

      final recordingSignal =
          await container.read(recordingSignalProvider.future);

      expect(recordingSignal, equals(RecordingSignals.startRecording));
    });

    test('''should yield RecordingSignal.stopRecording when 
        elapsed >= maxWaitTime and isRecording is true''', () async {
      container.read(isRecordingProvider.notifier).state = true;
      elapsedController.add(const Duration(minutes: 2));

      dbfsController.add(5);

      final recordingSignal =
          await container.read(recordingSignalProvider.future);

      expect(recordingSignal, equals(RecordingSignals.stopRecording));
    });

    test('''should yield RecordingSignal.stopRecording when 
        remain <= Duration.zero and isRecording is true''', () async {
      container.read(isRecordingProvider.notifier).state = true;
      elapsedController.add(const Duration(seconds: 10));
      remainController.add(Duration.zero);
      dbfsController.add(5);

      final recordingSignal =
          await container.read(recordingSignalProvider.future);

      expect(recordingSignal, equals(RecordingSignals.stopRecording));
    });

    test(
        'should yield RecordingSignal.none when none of the conditions are met',
        () async {
      dbfsController.add(5);
      container.read(thresholdDbfsProvider.notifier).state = 10;
      container.read(isRecordingProvider.notifier).state = false;
      elapsedController.add(const Duration(seconds: 10));
      remainController.add(const Duration(seconds: 10));

      final recordingSignal =
          await container.read(recordingSignalProvider.future);

      expect(recordingSignal, equals(RecordingSignals.none));
    });
  });
}
