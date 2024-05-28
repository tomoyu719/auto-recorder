import 'package:auto_recorder/features/recording/model/recording.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'player.g.dart';

/// Provider to determine if it is currently playing.
final isPlayingProvider = StateProvider<bool>((_) => false);

/// Provider for the currently playing recording.
final playingRecordingProvider = StateProvider<Recording?>((_) => null);

@Riverpod(keepAlive: true)
Player audioPlayer(AudioPlayerRef ref) {
  final player = AudioPlayer();
  ref.onDispose(player.dispose);
  return Player(player, ref);
}

typedef RecordingCallBack = void Function(Recording);

class Player {
  const Player(this._audioPlayer, this.ref);

  final Ref ref;
  final AudioPlayer _audioPlayer;

  Future<Duration?> getDuration(String filePath) {
    return _audioPlayer.setFilePath(filePath);
  }

  Future<void> play(Recording recording) async {
    ref.read(isPlayingProvider.notifier).state = true;
    ref.read(playingRecordingProvider.notifier).state = recording;
    await _audioPlayer.setFilePath(recording.path!);
    await _audioPlayer.play();
    await stop();
  }

  Future<void> stop() async {
    ref.read(isPlayingProvider.notifier).state = false;
    ref.read(playingRecordingProvider.notifier).state = null;

    await _audioPlayer.stop();
  }
}
