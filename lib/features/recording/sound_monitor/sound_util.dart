import 'dart:math';
import 'dart:typed_data';

import 'package:auto_recorder/constants/decibel.dart';
import 'package:auto_recorder/features/recording/sound_monitor/sound_monitor.dart';
import 'package:auto_recorder/features/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mic_stream/mic_stream.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sound_util.g.dart';

/// A StreamProvider that emits the decibel full scale (dBFS) values.
///
/// The [dbfs] stream emits the dBFS values based on the microphone input.
/// It uses the [MicStream.microphone] stream from the audio package to capture
/// the microphone audio and convert it to dBFS values.
///
/// The [isActiveProvider] is used to determine if the microphone is active.
/// If it is active, the [dbfs] stream will continuously emit the dBFS values.
/// Otherwise, it will emit the minimum dBFS value.
///
/// The [minDb] and [maxDb] parameters define the minimum and
/// maximum dBFS values that the emitted values will be clamped to.
@Riverpod(keepAlive: true)
Stream<double> dbfs(DbfsRef ref) async* {
  final isActive = ref.watch(isActiveProvider);
  if (isActive) {
    yield* MicStream.microphone(
      audioFormat: AudioFormat.ENCODING_PCM_16BIT,
      audioSource: AudioSource.MIC,
    ).map((sample) => _convertPcmToDbfs(sample).clamp(minDb, maxDb));
  }
  yield minDb;
}

/// The maximum amplitude value for audio samples.
final _maxAmplitude = pow(2, 15) - 1;

/// Convert a PCM sample in little-endian format to dBFS (decibels relative to
/// full scale).
double _convertPcmToDbfs(Uint8List samples) {
  var squareSum = 0;
  for (var i = 0; i < samples.length ~/ 2; i++) {
    var msb = samples[i * 2 + 1];
    var lsb = samples[i * 2];
    if (msb > 128) {
      msb -= 255;
    }
    if (lsb > 128) {
      lsb -= 255;
    }
    final amp = lsb + msb * 128;
    squareSum += amp * amp;
  }
  final mean = squareSum / samples.length;
  final rms = sqrt(mean);

  final db = 20 * log(rms / _maxAmplitude) / ln10;
  return db;
}

/// A StreamProvider that emits the elapsed time since
/// the last loudness detection.
/// This provider to calculate the time remaining until the end of
/// recording [remainProvider].
///
/// This stream emits a [Duration] representing the time elapsed since
/// the last detection.
/// If the noise detection is not active, emits a [Duration] of zero.
/// If the noise detection is active, it calculates the difference between
/// the elapsed time and the time of the latest detection.
@Riverpod(keepAlive: true)
Stream<Duration> elapsedLastDetection(ElapsedLastDetectionRef ref) async* {
  final isRecording = ref.watch(isRecordingProvider);
  if (!isRecording) {
    yield Duration.zero;
    return;
  }
  final elapsed = await ref.watch(elapsedProvider.future);
  final latest = await ref.watch(latestDetectionTimeProvider.future);
  yield elapsed - latest;
}

/// The duration to monitor the elapsed time.
const monitorDuration = Duration(milliseconds: 100);

/// A StreamProvider that emits the elapsed time. Used to display recording
/// time and terminate recordings that are too long
///
/// This emits the elapsed time periodically based on the [monitorDuration].
/// It only emits the elapsed time when the recording is in progress.
/// If the recording is not in progress, it emits a duration of zero.
@Riverpod(keepAlive: true)
Stream<Duration> elapsed(ElapsedRef ref) async* {
  final isRecording = ref.watch(isRecordingProvider);
  if (isRecording) {
    yield* Stream.periodic(
      monitorDuration,
      (period) => monitorDuration * period,
    );
  }
  yield Duration.zero;
}

/// StreamProvider that emits the latest loudness detection time.
///
/// The [latestDetectionState] state provider is used to store and
/// access the latest detection duration.
@Riverpod(keepAlive: true)
Stream<Duration> latestDetectionTime(LatestDetectionTimeRef ref) async* {
  final isRecording = ref.watch(isRecordingProvider);
  if (!isRecording) {
    yield Duration.zero;
    return;
  }
  final threshold = ref.watch(thresholdDbfsProvider);
  final dbfs = await ref.watch(dbfsProvider.future);
  final elapsed = await ref.read(elapsedProvider.future);
  if (dbfs >= threshold) {
    ref.read(latestDetectionState.notifier).state = elapsed;
  }
  yield ref.read(latestDetectionState);
}

final latestDetectionState = StateProvider<Duration>((ref) => Duration.zero);

const maxWaitTime = Duration(minutes: 1);

enum RecordingSignals { startRecording, stopRecording, none }

/// A streamProvider that emits [RecordingSignals] based on
/// the provided conditions. Used to end and start recordings.
///
/// This emits [RecordingSignals.startRecording] when the current decibel
/// level is greater than the threshold and recording is not in progress.
///
/// This emits [RecordingSignals.stopRecording] when the elapsed time
/// exceeds the maximum wait time and recording is in progress.
///
/// This also emits [RecordingSignals.stopRecording] when the remaining time
/// is less than or equal to zero and recording is in progress.
///
/// Otherwise, this emits [RecordingSignals.none].
@Riverpod(keepAlive: true)
Stream<RecordingSignals> recordingSignal(
  RecordingSignalRef ref,
) async* {
  final dbfs = await ref.watch(dbfsProvider.future);
  final isRecording = ref.watch(isRecordingProvider);
  final threshold = ref.watch(thresholdDbfsProvider);
  if (dbfs > threshold && !isRecording) {
    yield RecordingSignals.startRecording;
    return;
  }
  final elapsed = await ref.watch(elapsedProvider.future);
  if (elapsed >= maxWaitTime && isRecording) {
    yield RecordingSignals.stopRecording;
    return;
  }
  final remain = await ref.watch(remainProvider.future);
  if (remain <= Duration.zero && isRecording) {
    yield RecordingSignals.stopRecording;
    return;
  }

  yield RecordingSignals.none;
}

/// A streamProvider that emits the remaining duration until the end of
/// recording. Used to display and terminate recordings.
@Riverpod(keepAlive: true)
Stream<Duration> remain(RemainRef ref) async* {
  final isRecording = ref.watch(isRecordingProvider);
  final waitingTime = ref.watch(waitingTimeProvider);
  if (!isRecording) {
    yield waitingTime;
  }

  final elapsedLastDetection =
      await ref.watch(elapsedLastDetectionProvider.future);
  final remain = waitingTime - elapsedLastDetection;
  yield remain.isNegative ? Duration.zero : remain;
}

@Riverpod(keepAlive: true)
class ThresholdDbfs extends _$ThresholdDbfs {
  static const thresholdDbfsPrefsKey = 'thresholdDbfsPrefsKey';
  static const initialThresholdDbfs = (minDb + maxDb) ~/ 2;

  @override
  int build() {
    return ref.watch(sharedPreferencesProvider).getInt(thresholdDbfsPrefsKey) ??
        initialThresholdDbfs;
  }

  void onChange(double value) => state = value.round();

  void onChangeEnd(double value) {
    state = value.round();
    ref.watch(sharedPreferencesProvider).setInt(thresholdDbfsPrefsKey, state);
  }

  void restoreDefault() {
    state = initialThresholdDbfs;
    ref
        .watch(sharedPreferencesProvider)
        .setInt(thresholdDbfsPrefsKey, initialThresholdDbfs);
  }
}

@Riverpod(keepAlive: true)
class WaitingTime extends _$WaitingTime {
  static const waitingTimePrefsKey = 'waitingTime';
  static const initialWaitingTime = 5;
  static const maxWaitSeconds = 10;
  static const minWaitSeconds = 3;

  @override
  Duration build() {
    return Duration(
      seconds:
          ref.watch(sharedPreferencesProvider).getInt(waitingTimePrefsKey) ??
              initialWaitingTime,
    );
  }

  void onChange(double value) => state = Duration(seconds: value.round());

  void onChangeEnd(double value) {
    final seconds = value.round();

    state = Duration(seconds: seconds);
    ref.watch(sharedPreferencesProvider).setInt(waitingTimePrefsKey, seconds);
  }

  void restoreDefault() {
    state = const Duration(seconds: initialWaitingTime);
    ref
        .watch(sharedPreferencesProvider)
        .setInt(waitingTimePrefsKey, initialWaitingTime);
  }
}

@Riverpod(keepAlive: true)
class RecordingTimeLimit extends _$RecordingTimeLimit {
  static const recordingTimeLimitPrefsKey = 'recordingTimeLimitPrefsKey';
  static const initialRecordingTimeLimitInSeconds = 30;
  static const maxRecordingTimeLimitInSeconds = 60;
  static const minRecordingTimeLimitInSeconds = 10;

  @override
  Duration build() {
    final seconds = ref
            .watch(sharedPreferencesProvider)
            .getInt(recordingTimeLimitPrefsKey) ??
        initialRecordingTimeLimitInSeconds;

    return Duration(seconds: seconds);
  }

  void onChange(double value) {
    final seconds = value.round();
    state = Duration(seconds: seconds);
  }

  void onChangeEnd(double value) {
    final seconds = value.round();
    state = Duration(seconds: seconds);
    ref
        .watch(sharedPreferencesProvider)
        .setInt(recordingTimeLimitPrefsKey, seconds);
  }

  void restoreDefault() {
    state = const Duration(seconds: initialRecordingTimeLimitInSeconds);
    ref
        .watch(sharedPreferencesProvider)
        .setInt(recordingTimeLimitPrefsKey, initialRecordingTimeLimitInSeconds);
  }
}
