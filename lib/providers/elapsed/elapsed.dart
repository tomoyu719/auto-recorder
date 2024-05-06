import 'package:auto_recorder/providers/is_recording.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'elapsed.g.dart';

const monitorDuration = Duration(milliseconds: 100);

@Riverpod(keepAlive: true)
Stream<Duration> elapsed(ElapsedRef ref) async* {
  final isRecording = ref.watch(isRecordingProvider);
  if (isRecording) {
    yield* Stream.periodic(
        monitorDuration, (period) => monitorDuration * period);
  }
  yield Duration.zero;
}
