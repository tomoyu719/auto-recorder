import 'package:auto_recorder/recording.dart';
import 'package:auto_recorder/ui/recording/recording_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'player.g.dart';

@Riverpod(keepAlive: true)
Player audioPlayer(AudioPlayerRef ref) => Player(ref, AudioPlayer());
// final audioPlayerProvider = Provider((ref) => Player(ref));

class Player {
  final Ref ref;
  final AudioPlayer _audioPlayer;

  Player(this.ref, this._audioPlayer) {
    isPlayingStream.listen((event) {});
  }

  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  Stream<ProcessingState> get playerStateStream =>
      _audioPlayer.processingStateStream;

  Future<Duration?> getDuration(String filePath) {
    return _audioPlayer.setFilePath(filePath);
  }

  Stream<bool> get isPlayingStream => _audioPlayer.playingStream;

  void play(Recording recording) {
    ref.read(playingRecordingProvider.notifier).state = recording;
    _audioPlayer.play();
  }

  void pause() {
    ref.read(playingRecordingProvider.notifier).state = null;
    _audioPlayer.pause();
  }

  void stop() {
    ref.read(playingRecordingProvider.notifier).state = null;
    _audioPlayer.stop();
  }
}

final currentPositionProvider = StreamProvider<Duration>((ref) {
  final audioPlayer = ref.watch(audioPlayerProvider);
  return audioPlayer.positionStream;
});

final durationProvider =
    FutureProvider.family<Duration?, String>((ref, filePath) {
  final audioPlayer = ref.watch(audioPlayerProvider);
  return audioPlayer.getDuration(filePath);
});

final playerStateStream = StreamProvider<ProcessingState>((ref) {
  final audioPlayer = ref.watch(audioPlayerProvider);
  return audioPlayer.playerStateStream;
});

final isPlayingStreamProvider = StreamProvider<bool>((ref) {
  final audioPlayer = ref.watch(audioPlayerProvider);
  return audioPlayer.isPlayingStream;
});
