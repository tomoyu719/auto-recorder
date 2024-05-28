import 'package:auto_recorder/features/file_dir.dart';
import 'package:auto_recorder/features/player.dart';
import 'package:auto_recorder/features/recording/model/recording.dart';
import 'package:path/path.dart';
import 'package:record/record.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recorder.g.dart';

@Riverpod(keepAlive: true)
Recorder recorder(RecorderRef ref) {
  return Recorder(
    AudioRecorder(),
    ref.read(audiosFileDirProvider),
    ref.read(audioPlayerProvider).getDuration,
  );
}

//
typedef GetDurationCallBack = Future<Duration?> Function(String);

class Recorder {
  Recorder(this.recorder, this.audioFilePath, this.getDuration);
  final AudioRecorder recorder;
  final String audioFilePath;
  final GetDurationCallBack getDuration;
  String? outputFilePath;
  DateTime? recordingDate;

  void record(DateTime date) {
    recordingDate = date;
    final fileName = 'recording_${date.millisecondsSinceEpoch}.m4a';
    outputFilePath = join(audioFilePath, fileName);
    recorder.start(const RecordConfig(), path: outputFilePath!);
  }

  Future<Recording?> finish() async {
    final outputfilePath = await recorder.stop();
    if (outputfilePath == null) {
      return null;
    }

    final duration = await getDuration(outputfilePath);
    if (duration == null) {
      return null;
    }
    return Recording(
      date: recordingDate,
      path: outputfilePath,
      milliSeconds: duration.inMilliseconds,
    );
  }
}
