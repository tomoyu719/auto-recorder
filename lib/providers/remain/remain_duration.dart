import 'package:auto_recorder/providers/waiting_time/waiting_time.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../elapsed_last_detection/elapsed_last_detection.dart';
import '../is_recording.dart';

part 'remain_duration.g.dart';

@Riverpod(keepAlive: true)
Stream<Duration> remain(RemainRef ref) async* {
  final isRecording = ref.watch(isRecordingProvider);
  final waitingTime = ref.watch(waitingTimeProvider);
  if (!isRecording) yield waitingTime;
  final elapsedLastDetection =
      await ref.watch(elapsedLastDetectionProvider.future);
  final remain = waitingTime - elapsedLastDetection;

  yield remain.isNegative ? Duration.zero : remain;
}
