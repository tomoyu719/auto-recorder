import 'package:auto_recorder/features/recording/sound_monitor/sound_monitor.dart';
import 'package:auto_recorder/features/recording/widget/fade_transition.dart';
import 'package:auto_recorder/features/recording/widget/header_title.dart';
import 'package:auto_recorder/features/recording/widget/recording_list_item.dart';
import 'package:auto_recorder/features/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isSelectingModeProvider = Provider<bool>((ref) {
  final selectingRecordings = ref.watch(selectingRecordingsProvider);
  return selectingRecordings.isNotEmpty;
});

class RecordingHeader extends ConsumerWidget implements PreferredSizeWidget {
  const RecordingHeader(
    this.soundMonitor, {
    required this.onTapRemove,
    super.key,
  });
  final VoidCallback onTapRemove;
  final SoundMonitor soundMonitor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelecting = ref.watch(isSelectingModeProvider);
    return isSelecting
        ? AppBar(
            title: Text(
              '${ref.watch(selectingRecordingsProvider).length} selected',
            ),
            centerTitle: true,
            actions: [
              Tooltip(
                message: 'Delete',
                child: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Delete'),
                        content: const Text('Are you sure you want to delete?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              onTapRemove();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Tooltip(
                message: 'Unselect all',
                child: IconButton(
                  icon: const Icon(Icons.select_all),
                  onPressed: ref
                      .read(selectingRecordingsProvider.notifier)
                      .unSelectAll,
                ),
              ),
            ],
          )
        : AppBar(
            title: const HeaderTitle(),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  soundMonitor.passive();
                  ref.read(isActiveProvider.notifier).state = true;
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      fullscreenDialog: true,
                      builder: (context) => const SettingScreen(),
                    ),
                  );
                  ref.read(isActiveProvider.notifier).state = false;
                },
              ),
            ],
          );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
