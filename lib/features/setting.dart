import 'package:auto_recorder/features/recording/sound_monitor/sound_util.dart';
import 'package:auto_recorder/features/recording/widget/sound_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
      ),
      body: ListView(
        shrinkWrap: true,
        children: const <Widget>[
          RecordingTimeLimitWidget(),
          SoundLevelWidget(),
          WaitingTimeWidget(),
          RestoreDefaultButton(),
        ],
      ),
    );
  }
}

class RestoreDefaultButton extends ConsumerWidget {
  const RestoreDefaultButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () {
        ref.read(recordingTimeLimitProvider.notifier).restoreDefault();
        ref.read(thresholdDbfsProvider.notifier).restoreDefault();
        ref.read(waitingTimeProvider.notifier).restoreDefault();
      },
      child: const Text('Restore Default'),
    );
  }
}

class WaitingTimeWidget extends ConsumerWidget {
  const WaitingTimeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final waitingTime = ref.watch(waitingTimeProvider);
    const div = WaitingTime.maxWaitSeconds - WaitingTime.minWaitSeconds;
    return Column(
      children: [
        const ListTile(title: Text('Waiting Time [sec]')),
        Slider(
          label: '${waitingTime.inSeconds}',
          divisions: div,
          min: WaitingTime.minWaitSeconds.toDouble(),
          max: WaitingTime.maxWaitSeconds.toDouble(),
          value: waitingTime.inSeconds.toDouble(),
          onChanged: ref.read(waitingTimeProvider.notifier).onChange,
          onChangeEnd: ref.read(waitingTimeProvider.notifier).onChangeEnd,
        ),
      ],
    );
  }
}

class RecordingTimeLimitWidget extends ConsumerWidget {
  const RecordingTimeLimitWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordingTimeLimit = ref.watch(recordingTimeLimitProvider);
    const diff = RecordingTimeLimit.maxRecordingTimeLimitInSeconds -
        RecordingTimeLimit.minRecordingTimeLimitInSeconds;
    return Column(
      children: [
        const ListTile(title: Text('Recording Time Limit [sec]')),
        Slider(
          label: '${recordingTimeLimit.inSeconds}',
          divisions: diff ~/ 5,
          max: RecordingTimeLimit.maxRecordingTimeLimitInSeconds.toDouble(),
          min: RecordingTimeLimit.minRecordingTimeLimitInSeconds.toDouble(),
          value: recordingTimeLimit.inSeconds.toDouble(),
          onChanged: ref.read(recordingTimeLimitProvider.notifier).onChange,
          onChangeEnd:
              ref.read(recordingTimeLimitProvider.notifier).onChangeEnd,
        ),
      ],
    );
  }
}
