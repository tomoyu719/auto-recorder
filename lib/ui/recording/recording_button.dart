import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_settings/app_settings.dart';
import 'package:auto_recorder/providers/is_active.dart';
import 'package:auto_recorder/recording.dart';
import 'package:auto_recorder/sound_monitor.dart';

class RecordingButton extends ConsumerWidget {
  const RecordingButton({Key? key}) : super(key: key);

  void onFinish(Recording recording) {
    print('Recording finished');
  }

  void onConfirmPermission(BuildContext context) async {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Authorization required'),
              icon: const Icon(Icons.info),
              content:
                  const Text('Please allow the app to use the microphone.'),
              actions: [
                TextButton(
                    onPressed: () {
                      AppSettings.openAppSettings();
                      Navigator.pop(context);
                    },
                    child: const Text('Settings')),
              ],
            ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = ref.watch(isActiveProvider);
    return FloatingActionButton(
      onPressed: () {
        final soundMonitor = ref.read(soundMonitorProvider(
            onFinishRecording: onFinish,
            onConfirmPermission: onConfirmPermission));
        isActive ? soundMonitor.passive() : soundMonitor.active();
      },
      child: isActive ? const Icon(Icons.stop) : const Icon(Icons.mic),
    );
  }
}
