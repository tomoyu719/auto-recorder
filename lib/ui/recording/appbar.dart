import 'package:auto_recorder/providers/is_active.dart';
import 'package:auto_recorder/sound_monitor.dart';
import 'package:auto_recorder/ui/recording/recording_list.dart';
import 'package:auto_recorder/ui/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isSelectingProvider = Provider<bool>((ref) {
  final selectingRecordings = ref.watch(selectingRecordingsProvider);
  return selectingRecordings.isNotEmpty;
});

// TODO rename
class MyAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelecting = ref.watch(isSelectingProvider);
    return isSelecting
        ? AppBar(
            title: Text('${ref.watch(selectingRecordingsProvider).length}'),
            actions: [
              Tooltip(
                message: 'Delete',
                child: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Delete'),
                          content:
                              const Text('Are you sure you want to delete?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // throw UnimplementedError();
                                Navigator.of(context).pop();
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      }),
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
              )
            ],
          )
        : AppBar(
            title: const Text('Auto Recorder'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () async {
                  ref.read(soundMonitorProvider()).passive();
                  ref.read(isActiveProvider.notifier).state = true;
                  await Navigator.of(context).push(MaterialPageRoute<void>(
                    fullscreenDialog: true,
                    builder: (context) => const SettingScreen(),
                  ));
                  ref.read(isActiveProvider.notifier).state = false;
                },
              ),
            ],
          );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
