import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:auto_recorder/providers/dbfs/dbfs.dart';
import 'package:auto_recorder/providers/threshold/threshold_dbfs.dart';
import 'package:auto_recorder/providers/waiting_time/waiting_time.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dev Screen'),
      ),
      body: Center(
          child: ListView(
        shrinkWrap: true,
        children: const <Widget>[
          WaitingTimeWidget(),
          SoundLevelWidget(),
        ],
      )),
    );
  }
}

class WaitingTimeWidget extends ConsumerWidget {
  const WaitingTimeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final waitingTime = ref.watch(waitingTimeProvider);
    return Column(
      children: [
        const ListTile(title: Text('Waiting Time ')),
        Slider(
          min: WaitingTime.minWaitTime.toDouble(),
          max: WaitingTime.maxWaitTime.toDouble(),
          value: waitingTime.inSeconds.toDouble(),
          onChanged: ref.read(waitingTimeProvider.notifier).onChange,
          onChangeEnd: ref.read(waitingTimeProvider.notifier).onChangeEnd,
        )
      ],
    );
  }
}

class SoundLevelWidget extends ConsumerWidget {
  const SoundLevelWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbSpl = ref.watch(dbSplProvider);
    final threshold = ref.watch(thresholdDbSplProvider);
    return Column(
      children: [
        const ListTile(title: Text('Sound Level & Threshold')),
        dbSpl.when(
          skipLoadingOnReload: true,
          data: (value) => CustomPaint(
              painter: SoundLevelPainter(value, value > threshold),
              child: SizedBox(
                height: 30.0,
                child: Slider(
                  value: threshold.toDouble(),
                  onChanged: ref.read(thresholdDbSplProvider.notifier).onChange,
                  onChangeEnd:
                      ref.read(thresholdDbSplProvider.notifier).onChangeEnd,
                  min: minDb,
                  max: maxDb,
                ),
              )),
          error: (error, _) => Text(error.toString()),
          loading: () => const CircularProgressIndicator(),
        ),
      ],
    );
  }
}

class SoundLevelPainter extends CustomPainter {
  final double soundLevel;
  final bool isExceed;

  const SoundLevelPainter(this.soundLevel, this.isExceed);

  @override
  void paint(Canvas canvas, Size size) {
    final rect =
        Rect.fromLTWH(0, 0, size.width * (soundLevel / maxDb), size.height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(20.0));

    // TODO change color
    final paint = Paint()
      ..color = isExceed ? Colors.red : Colors.blue
      ..strokeWidth = 2.0;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
