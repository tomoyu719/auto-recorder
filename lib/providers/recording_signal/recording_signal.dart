import 'package:auto_recorder/providers/dbfs/dbfs.dart';
import 'package:auto_recorder/providers/threshold/threshold_dbfs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../is_recording.dart';
import '../remain/remain_duration.dart';

part 'recording_signal.g.dart';

@Riverpod(keepAlive: true)
Stream<bool> startRecording(StartRecordingRef ref) async* {
  final isRecording = ref.watch(isRecordingProvider);
  if (isRecording) yield false;
  final threshold = ref.watch(thresholdDbSplProvider);
  final exceeds =
      await ref.watch(dbSplProvider.selectAsync((dbfs) => dbfs >= threshold));
  yield exceeds;
}

@Riverpod(keepAlive: true)
Stream<bool> stopRecording(StartRecordingRef ref) async* {
  final isRecording = ref.watch(isRecordingProvider);
  if (!isRecording) yield false;
  final hasNoRemain = await ref
      .watch(remainProvider.selectAsync((data) => data <= Duration.zero));
  yield hasNoRemain;
}
