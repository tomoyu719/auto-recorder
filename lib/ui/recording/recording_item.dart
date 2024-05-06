import 'package:auto_recorder/providers/player.dart';
import 'package:auto_recorder/providers/recording_player_service.dart';
import 'package:auto_recorder/recording.dart';
import 'package:auto_recorder/ui/recording/appbar.dart';
import 'package:auto_recorder/ui/recording/recording_detail.dart';
import 'package:auto_recorder/ui/recording/recording_list.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentRecordingProvider =
    Provider<Recording>((_) => throw UnimplementedError());

final isSelectingCurrentProvider =
    Provider.family<bool, Recording>((ref, recording) {
  final selectingRecordings = ref.watch(selectingRecordingsProvider);
  return selectingRecordings.contains(recording);
});

typedef OnDismissRecording = void Function(Recording recording);

class RecordingItem extends ConsumerWidget {
  final OnDismissRecording onDismiss;

  final Animation<double> animation;

  const RecordingItem(this.animation, {required this.onDismiss, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recording = ref.watch(currentRecordingProvider);
    final isPlayingCurrent =
        ref.watch(isPlayingCurrentRecordingProvider(recording));
    final isSelectingCurrent = ref.watch(isSelectingCurrentProvider(recording));

    return SizeTransition(
        sizeFactor: animation,
        child: Dismissible(
          key: UniqueKey(),
          onDismissed: (_) => onDismiss(recording),
          child: ListTile(
            title: Text('Recording ${recording.id}'),
            subtitle: const Text('Subtitle'),
            leading: isSelectingCurrent
                ? const Icon(Icons.check)
                : isPlayingCurrent
                    ? IconButton(
                        icon: const Icon(Icons.pause),
                        onPressed: () => ref.read(audioPlayerProvider).pause(),
                      )
                    : IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: () =>
                            ref.read(audioPlayerProvider).play(recording),
                      ),
            // const Icon(Icons.play_arrow),
            onTap: () => isSelectingCurrent
                ? ref
                    .read(selectingRecordingsProvider.notifier)
                    .unSelect(recording)
                : ref.watch(isSelectingProvider)
                    ? ref
                        .read(selectingRecordingsProvider.notifier)
                        .select(recording)
                    : Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (context) => const RecordingDetail())),
            onLongPress: () => isSelectingCurrent
                ? null
                : ref
                    .read(selectingRecordingsProvider.notifier)
                    .select(recording),
          ),
        ));
  }
}
