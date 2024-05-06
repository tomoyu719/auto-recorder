import 'package:auto_recorder/providers/elapsed/elapsed.dart';
import 'package:auto_recorder/providers/latest_detection/latest_detection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../is_recording.dart';

part 'elapsed_last_detection.g.dart';

/// A stream provider that emits the latest detection duration.　This provider is intended to be used by other providers, not the UI.
///
/// This provider listens to changes in the [isRecordingProvider] and [thresholdDbfsProvider]
/// and emits the elapsed duration since the last detection. If recording is not in progress,
/// it emits a duration of zero.
///
/// The [elapsedProvider] is used to determine if the current audio level exceeds the threshold.
/// The [latestDetectionProvider] is used to prevent this provider from being updated by itself.

@Riverpod(keepAlive: true)
Stream<Duration> elapsedLastDetection(ElapsedLastDetectionRef ref) async* {
  final isRecording = ref.watch(isRecordingProvider);
  if (!isRecording) yield Duration.zero;
  late Duration current;
  late Duration latest;
  // avoid to raise Unhandled Exception. see 'https://github.com/rrousselGit/riverpod/issues/815'
  // TODO Find a better way of this.
  await Future.wait([
    ref.watch(elapsedProvider.future).then((value) => current = value),
    ref.watch(latestDetectionProvider.future).then((value) => latest = value)
  ]);
  yield current - latest;
}

final latestDetectionProvider2 =
    StreamProvider.autoDispose<Duration>((ref) async* {
  final isRecording = ref.watch(isRecordingProvider);
  if (!isRecording) yield Duration.zero;
  late Duration current;
  late Duration latest;
  // avoid to raise Unhandled Exception. see 'https://github.com/rrousselGit/riverpod/issues/815'
  // TODO Find a better way of this.
  await Future.wait([
    ref.watch(elapsedProvider.future).then((value) => current = value),
    ref.watch(latestDetectionProvider.future).then((value) => latest = value)
  ]);
  yield current - latest;
});
