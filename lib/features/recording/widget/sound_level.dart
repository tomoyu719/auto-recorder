import 'package:auto_recorder/constants/decibel.dart';
import 'package:auto_recorder/features/recording/sound_monitor/sound_monitor.dart';
import 'package:auto_recorder/features/recording/sound_monitor/sound_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SoundLevelWidget extends ConsumerWidget {
  const SoundLevelWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbSpl = ref.watch(dbfsProvider);
    final threshold = ref.watch(thresholdDbfsProvider);
    final isActive = ref.watch(isActiveProvider);
    return isActive
        ? ColoredBox(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: dbSpl.when(
                skipLoadingOnReload: true,
                data: (value) => CustomPaint(
                  painter: SoundLevelPainter(
                    value,
                    isExceed: value > threshold,
                    min: minDb,
                    max: maxDb,
                  ),
                  child: SizedBox(
                    height: 30,
                    child: Slider(
                      value: threshold.toDouble(),
                      onChanged:
                          ref.read(thresholdDbfsProvider.notifier).onChange,
                      onChangeEnd:
                          ref.read(thresholdDbfsProvider.notifier).onChangeEnd,
                      min: minDb,
                      max: maxDb,
                    ),
                  ),
                ),
                error: (error, _) => Text(error.toString()),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}

class SoundLevelPainter extends CustomPainter {
  const SoundLevelPainter(
    this.soundLevel, {
    required this.isExceed,
    required this.min,
    required this.max,
  });
  final double soundLevel;
  final bool isExceed;
  final double min;
  final double max;

  @override
  void paint(Canvas canvas, Size size) {
    final diff = (max - min).abs();
    final ratio = (soundLevel - min).abs() / diff;

    final rect = Rect.fromLTWH(0, 0, size.width * ratio, size.height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(20));

    // TODO(tmy): change color depends on theme.
    final paint = Paint()
      ..color = isExceed ? Colors.red : Colors.blue
      ..strokeWidth = 2.0;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
