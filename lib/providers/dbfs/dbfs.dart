import 'dart:math';
import 'package:auto_recorder/providers/is_active.dart';
import 'package:auto_recorder/providers/pcm/pcm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dbfs.g.dart';

const maxDb = 100.0;
const minDb = 0.0;

@Riverpod(keepAlive: true)
Stream<double> dbSpl(DbSplRef ref) async* {
  final isActive = ref.watch(isActiveProvider);
  if (isActive) {
    yield* ref
        .watch(pcmProvider)
        .map((pcm) => pcmToDB(pcm).clamp(minDb, maxDb));
  }
  yield minDb;
}

final maxAmp = pow(2, 12) + 0.0;
double pcmToDB(List<double> samples) {
  final maxValue = samples.fold(
      0.0, (previousValue, element) => max(previousValue, element.abs()));

  return 20 * log(maxAmp * maxValue) * log10e;
  // // print({'$db, $maxValue'});
  // return db;
}

// double pcmToDBFS(Uint8List samples) {
//   final amps = List<double>.filled(samples.length ~/ 2, 0);
//   for (int i = 0; i < amps.length; i++) {
//     int msb = samples[i * 2 + 1];
//     int lsb = samples[i * 2];
//     if (msb > 128) msb -= 255;
//     if (lsb > 128) lsb -= 255;
//     amps[i] = lsb + msb * 128;
//   }
//   final rms = sqrt(amps
//           .map((amp) => pow(amp, 2))
//           .fold(0.0, (previousValue, element) => previousValue + element) /
//       amps.length);
//   final db = 20 * log10(rms / 32768);
//   return db;
// }
