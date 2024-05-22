import 'package:auto_recorder/features/player.dart';
import 'package:auto_recorder/features/recording/model/recording.dart';
import 'package:auto_recorder/features/recording/widget/recording_header.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recording_item.g.dart';

final recordingListItemProvider =
    Provider<Recording>((_) => throw UnimplementedError());

final isPlayingCurrentRecordingProvider =
    Provider.family<bool, Recording>((ref, recording) {
  final currentPlaying = ref.watch(playingRecordingProvider);
  return currentPlaying == recording;
});

final isSelectingCurrentProvider =
    Provider.family<bool, Recording>((ref, recording) {
  final selectingRecordings = ref.watch(selectingRecordingsProvider);
  return selectingRecordings.contains(recording);
});

@Riverpod(keepAlive: true)
class SelectingRecordings extends _$SelectingRecordings {
  @override
  List<Recording> build() => [];

  void unSelectAll() {
    state = [];
  }

  void select(Recording recording) {
    if (!state.contains(recording)) {
      state = [...state, recording];
    }
  }

  void unSelect(Recording recording) {
    if (state.contains(recording)) {
      state = state.where((r) => r != recording).toList();
    }
  }

  void onRemove(Recording recording) {
    if (state.contains(recording)) {
      state = state.where((r) => r != recording).toList();
    }
  }
}

typedef OnDismissRecording = void Function(Recording recording);

// class RecordingItem extends ConsumerStatefulWidget {
//   const RecordingItem(this.animation, {this.onDismiss, super.key});
//   final OnDismissRecording? onDismiss;

//   final Animation<double> animation;

//   @override
//   RecordingItemState createState() => RecordingItemState();
// }

class RecordingItem extends ConsumerWidget {
  const RecordingItem(this.animation, {this.onDismiss, super.key});

  final OnDismissRecording? onDismiss;

  final Animation<double> animation;
  String _formatDuration(int milliSeconds) {
    final seconds = milliSeconds ~/ 1000;
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    final minuteString = minutes.toString().padLeft(2, '0');
    final secondString = remainingSeconds.toString().padLeft(2, '0');
    return '$minuteString:$secondString';
  }

  String _formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('yyyy-MM-dd – kk:mm');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Widget build(BuildContext context, WidgetRef ref) {
    final recording = ref.watch(recordingListItemProvider);
    final isPlayingCurrent =
        ref.watch(isPlayingCurrentRecordingProvider(recording));
    final isSelectingCurrent = ref.watch(isSelectingCurrentProvider(recording));

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: Dismissible(
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          child: const Icon(Icons.delete),
        ),
        key: UniqueKey(),
        onDismissed: (_) => onDismiss?.call(recording),
        child: ListTile(
          onTap: () => isSelectingCurrent
              ? ref
                  .read(selectingRecordingsProvider.notifier)
                  .unSelect(recording)
              : ref.watch(isSelectingModeProvider)
                  ? ref
                      .read(selectingRecordingsProvider.notifier)
                      .select(recording)
                  : null,
          onLongPress: () => isSelectingCurrent
              ? null
              : ref
                  .read(selectingRecordingsProvider.notifier)
                  .select(recording),
          title: Text(_formatDateTime(recording.date!)),
          subtitle: Text(_formatDuration(recording.milliSeconds!)),
          leading: isSelectingCurrent
              ? const Icon(Icons.check)
              : isPlayingCurrent
                  ? IconButton(
                      icon: const Icon(Icons.stop),
                      onPressed: () => ref.read(audioPlayerProvider).stop(),
                    )
                  : IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () =>
                          ref.read(audioPlayerProvider).play(recording),
                    ),
        ),
      ),
    );
  }
}
