import 'package:auto_recorder/features/recording/model/recording.dart';
import 'package:auto_recorder/features/recording/recording_page.dart';
import 'package:auto_recorder/features/recording/widget/recording_list_item.dart';
import 'package:auto_recorder/features/remove_recording_service.dart';
import 'package:auto_recorder/features/undelete_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecordingList extends ConsumerWidget {
  const RecordingList(this._list, this._listKey, {super.key});
  final GlobalKey<AnimatedListState> _listKey;
  final ListModel<Recording> _list;

  void _showSnackBar(
    Recording recording,
    BuildContext context, {
    required VoidCallback onUndelete,
  }) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Recording deleted'),
          action: SnackBarAction(label: 'Undelete?', onPressed: onUndelete),
        ),
      );

  void _onUndeleteRemoveRecording(int index, Recording recording) {
    _list.insert(index, recording);
  }

  void _showUndeleteFailedSnackBar(BuildContext context) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Undelete failed.')));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () => ref.refresh(fetchRecordingsProvider.future),
      child: AnimatedList(
        key: _listKey,
        initialItemCount: _list.length,
        itemBuilder: (context, index, animation) {
          final recording = _list[index];
          final screenWidth = MediaQuery.of(context).size.width;
          final indent = screenWidth * 0.1;
          return ProviderScope(
            overrides: [
              recordingListItemProvider.overrideWithValue(recording),
            ],
            child: Column(
              children: [
                if (index < _list.length)
                  Divider(indent: indent, endIndent: indent),
                RecordingItem(
                  animation,
                  onDismiss: (recording) {
                    _list.remove(index, isDoAnimation: false);
                    ref
                        .read(removeRecordingServiceProvider)
                        .onRemove(recording, index);
                    _showSnackBar(
                      recording,
                      context,
                      onUndelete: () {
                        ref.read(undeleteServiceProvider).undelete(
                              onUndelete: _onUndeleteRemoveRecording,
                              onUndeleteFailed: () =>
                                  _showUndeleteFailedSnackBar(context),
                            );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
