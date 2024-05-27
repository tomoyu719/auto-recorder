import 'package:auto_recorder/features/recording/model/recording.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'player.g.dart';

/// Provider to determine if it is currently playing.
final isPlayingProvider = Provider<bool>(
  (ref) => ref.watch(audioPlayerProvider.select((value) => value.isPlaying)),
);

/// Provider for the currently playing recording.
final playingRecordingProvider = Provider<Recording?>(
  (ref) =>
      ref.watch(audioPlayerProvider.select((value) => value.currentlyPlaying)),
);

@Riverpod(keepAlive: true)
Player audioPlayer(AudioPlayerRef ref) {
  final player = AudioPlayer();
  ref.onDispose(player.dispose);
  return Player(player);
}

class Player {
  Player(this._audioPlayer)
      : isPlaying = false,
        currentlyPlaying = null;

  final AudioPlayer _audioPlayer;

  bool isPlaying;
  Recording? currentlyPlaying;

  Future<Duration?> getDuration(String filePath) {
    return _audioPlayer.setFilePath(filePath);
  }

  Future<void> play(Recording recording) async {
    currentlyPlaying = recording;
    await _audioPlayer.setFilePath(recording.path!);
    await _audioPlayer.play();
    stop();
  }

  void stop() {
    currentlyPlaying = null;
    _audioPlayer.stop();
  }
}
