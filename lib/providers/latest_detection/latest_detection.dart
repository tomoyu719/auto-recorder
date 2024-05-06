import 'package:auto_recorder/providers/dbfs/dbfs.dart';
import 'package:auto_recorder/providers/elapsed/elapsed.dart';
import 'package:auto_recorder/providers/threshold/threshold_dbfs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../is_recording.dart';

part 'latest_detection.g.dart';

/// A stream provider that emits the latest detection duration.　This provider is intended to be used by other providers, not the UI.
///
/// This provider listens to changes in the [isRecordingProvider] and [thresholdDbSplProvider]
/// and emits the elapsed duration since the last detection. If recording is not in progress,
/// it emits a duration of zero.
///
/// The [dbSplProvider] is used to determine if the current audio level exceeds the threshold.
/// The [elapsedProvider] is used to prevent this provider from being updated by itself.
@Riverpod(keepAlive: true)
Stream<Duration> latestDetection(LatestDetectionRef ref) async* {
  final isRecording = ref.watch(isRecordingProvider);
  if (!isRecording) yield Duration.zero;

  final threshold = ref.watch(thresholdDbSplProvider);

  // By using 'selectAsync', this provider will be updated when the value
  // of dbfsProvider is updated, but the value of dbfsProvider is not used.
  // TODO Find a better way
  late Duration elapsed;
  await Future.wait([
    ref.watch(dbSplProvider.selectAsync((data) => data >= threshold)),
    // Read elapsedProvider to prevent this provider itself from being updated
    // by elapsedProvider
    // TODO Find a better way
    ref.read(elapsedProvider.future).then((value) => elapsed = value)
  ]);

  yield elapsed;
}
