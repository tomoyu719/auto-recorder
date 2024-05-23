import 'package:auto_recorder/features/recording/sound_monitor/sound_monitor.dart';
import 'package:auto_recorder/features/recording/sound_monitor/sound_util.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class HeaderTitle extends ConsumerWidget {
  const HeaderTitle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = ref.watch(isActiveProvider);
    final style = Theme.of(context).textTheme.headlineMedium;

    return !isActive
        ? Text('Noise Recorder', style: style)
        : ref.watch(remainProvider).when(
              skipLoadingOnReload: true,
              data: (remain) {
                final minutesText = remain.inMinutes.toString().padLeft(2, '0');
                final secondsText =
                    (remain.inSeconds % 60).toString().padLeft(2, '0');
                return Text(
                  '$minutesText:$secondsText',
                  style: style,
                );
              },
              loading: () => Text('--:--', style: style),
              error: (error, _) => Text(
                'Error: $error',
                style: style,
              ),
            );
  }
}
