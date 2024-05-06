// import 'package:auto_recorder/recording.dart';
// import 'package:auto_recorder/ui/recording/recording_list.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final recordingPlayerServiceProvider =
//     Provider((ref) => RecordingPlayerService(ref));

// class RecordingPlayerService {
//   final Ref ref;

//   RecordingPlayerService(this.ref);
//   void play(Recording recording) async {
//     ref.read(playingRecordingProvider.notifier).state = recording;
//     Future.delayed(const Duration(seconds: 5)).then(
//         (value) => ref.read(playingRecordingProvider.notifier).state = null);
//   }

//   void stop(Recording recording) {
//     ref.read(playingRecordingProvider.notifier).state = null;
//   }

//   void pause() {
//     ref.read(playingRecordingProvider.notifier).state = null;
//   }
// }

// class FakePlayer {
//   void play(Recording recording) {}
//   void stop(Recording recording) {}
// }
