import 'dart:typed_data';

import 'package:auto_recorder/providers/is_active.dart';
import 'package:mic_stream/mic_stream.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:audio_streamer/audio_streamer.dart';

part 'pcm.g.dart';

const sampleRate = 44100;

@Riverpod(keepAlive: true)
Raw<Stream<List<double>>> pcm(PcmRef ref) {
  final isActive = ref.watch(isActiveProvider);
  return isActive
      ? AudioStreamer().audioStream
      : Stream<List<double>>.value([0.0]).asBroadcastStream();
}
// @Riverpod(keepAlive: true)
// Raw<Stream<Uint8List>> pcm(PcmRef ref) {
//   final isActive = ref.watch(isActiveProvider);
//   return isActive
//       ? MicStream.microphone(
//               sampleRate: sampleRate,
//               audioFormat: AudioFormat.ENCODING_PCM_16BIT,
//               audioSource: AudioSource.MIC)
//           .asBroadcastStream()
//       : Stream.value(Uint8List(0)).asBroadcastStream();
// }
