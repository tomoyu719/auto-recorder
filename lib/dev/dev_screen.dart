import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:auto_recorder/audio_encoder.dart';
import 'package:auto_recorder/providers/dbfs/dbfs.dart';
import 'package:auto_recorder/providers/elapsed/elapsed.dart';
import 'package:auto_recorder/providers/elapsed_last_detection/elapsed_last_detection.dart';
import 'package:auto_recorder/providers/file_dir.dart';
import 'package:auto_recorder/providers/is_active.dart';
import 'package:auto_recorder/providers/latest_detection/latest_detection.dart';
import 'package:auto_recorder/providers/remain/remain_duration.dart';
import 'package:auto_recorder/providers/threshold/threshold_dbfs.dart';
import 'package:auto_recorder/providers/waiting_time/waiting_time.dart';
import 'package:auto_recorder/recording.dart';
import 'package:auto_recorder/sound_monitor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

import '../providers/is_recording.dart';

class DevScreen extends StatelessWidget {
  const DevScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dev Screen'),
      ),
      body: ListView(
        children: const <Widget>[
          ElapsedWidget(),
          LatestDetectionWidget(),
          ElapsedLastDetectionWidget(),
          RemainWidget(),
          IsRecordingWidget(),
          IsActiveWidget(),
          ThresholdDbWidget(),
          DecibelWidget(),
          // SoundMonitorWidget(),
          CheckDir(),
          DeleteFiles(),
          WaitingTimeWidget(),
          // IsExceedsWidget(),
        ],
      ),
    );
  }
}

class IsRecordingWidget extends ConsumerWidget {
  const IsRecordingWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRecording = ref.watch(isRecordingProvider);
    final notifier = ref.watch(isRecordingProvider.notifier);
    return ListTile(
        title: Text('isRecording: $isRecording'),
        trailing: Switch(
            value: isRecording,
            onChanged: (bool value) => notifier.state = value));
  }
}

class IsActiveWidget extends ConsumerWidget {
  const IsActiveWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = ref.watch(isActiveProvider);
    return ListTile(
        title: Text('isActive: $isActive'),
        trailing: Switch(
            value: isActive,
            onChanged: (bool value) =>
                ref.read(isActiveProvider.notifier).state = value));
  }
}

class ElapsedLastDetectionWidget extends ConsumerWidget {
  const ElapsedLastDetectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final elapsedLastDetection = ref.watch(elapsedLastDetectionProvider);
    // print(elapsedLastDetection.value);

    return elapsedLastDetection.when(
      skipLoadingOnReload: true,
      data: (value) => ListTile(title: Text('elapsedLastDetection: $value')),
      error: (error, _) => Text(error.toString()),
      loading: () => const CircularProgressIndicator(),
    );
  }
}

class LatestDetectionWidget extends ConsumerWidget {
  const LatestDetectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latest = ref.watch(latestDetectionProvider);

    return latest.when(
      skipLoadingOnReload: true,
      data: (value) => ListTile(title: Text('latestDetection: $value')),
      error: (error, _) => Text(error.toString()),
      loading: () {
        return const CircularProgressIndicator();
      },
    );
  }
}

class ElapsedWidget extends ConsumerWidget {
  const ElapsedWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final elapsed = ref.watch(elapsedProvider);
    return elapsed.when(
      skipLoadingOnReload: true,
      data: (value) => ListTile(title: Text('elapsed: $value')),
      error: (error, _) => Text(error.toString()),
      loading: () => const CircularProgressIndicator(),
    );
    // return switch (elapsed) {

    //   AsyncData(:final value) => ListTile(title: Text('elapsed: $value')),
    //   AsyncError(:final error) => Text(error.toString()),
    //   _ => const CircularProgressIndicator(),
    // };
  }
}

class WaitingTimeWidget extends ConsumerWidget {
  const WaitingTimeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final waitingTime = ref.watch(waitingTimeProvider);
    return Column(
      children: [
        ListTile(title: Text('waitingTime: $waitingTime')),
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

class RemainWidget extends ConsumerWidget {
  const RemainWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remain = ref.watch(remainProvider);
    return remain.when(
      skipLoadingOnReload: true,
      data: (value) => ListTile(title: Text('remain: $value')),
      error: (error, _) => Text(error.toString()),
      loading: () => const CircularProgressIndicator(),
    );
  }
}

class ThresholdDbWidget extends ConsumerWidget {
  const ThresholdDbWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thresholdDecibel = ref.watch(thresholdDbSplProvider);
    return Column(children: [
      ListTile(title: Text('thresholdDbfs: $thresholdDecibel')),
      Slider(
        value: thresholdDecibel.toDouble(),
        onChanged: ref.read(thresholdDbSplProvider.notifier).onChange,
        onChangeEnd: ref.read(thresholdDbSplProvider.notifier).onChangeEnd,
        min: minDb,
        max: maxDb,
      ),
    ]);
  }
}

class DecibelWidget extends ConsumerWidget {
  const DecibelWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbfs = ref.watch(dbSplProvider);
    return dbfs.when(
      skipLoadingOnReload: true,
      data: (value) => Column(children: [
        ListTile(
          title: Text('dbfs: $value'),
        ),
        Slider(
          value: value,
          onChanged: null,
          min: minDb,
          max: maxDb,
        ),
      ]),
      error: (error, _) => Text(error.toString()),
      loading: () => const CircularProgressIndicator(),
    );
  }
}

class SoundMonitorWidget extends ConsumerStatefulWidget {
  const SoundMonitorWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SoundMonitorWidget();
}

class _SoundMonitorWidget extends ConsumerState {
  late final SoundMonitor soundMonitor;
  @override
  void initState() {
    super.initState();
    soundMonitor = throw UnimplementedError();
    // soundMonitor = ref.read(
    //   soundMonitorProvider(
    //     onFinishRecording: onFinish,
    //     onConfirmPermission: onConfirmPermission,
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final isActive = ref.watch(isActiveProvider);
    return ListTile(
      title: const Text('soundMonitor'),
      trailing: IconButton(
        icon: isActive ? const Icon(Icons.mic_off) : const Icon(Icons.mic),
        onPressed: () async {
          final path = ref.read(fileDirProvider);
          final i = join(path, 'pcm_16bit_mono.raw');
          final o = join(path, 'pcm_16bit_mono.wav');
          AudioEncoder().x(i, o);
          //   final x = await rootBundle.load('assets/pcm_16bit_mono.raw');
          //   final bytes = x.buffer.asUint8List();
          //   final path = ref.read(fileDirProvider);
          //   File(join(path, 'pcm_16bit_mono.raw'))
          //       .writeAsBytes(bytes, flush: true);
        },
        // onPressed: isActive ? soundMonitor.passive : soundMonitor.active,
      ),
    );
  }

  void onFinish(Recording recording) {
    print('Recording finished');
  }

  void onConfirmPermission() async {
    //   showDialog(
    //       context: context,
    //       builder: (_) => AlertDialog(
    //             title: const Text('Authorization required'),
    //             icon: const Icon(Icons.info),
    //             content:
    //                 const Text('Please allow the app to use the microphone.'),
    //             actions: [
    //               TextButton(
    //                   onPressed: () {
    //                     AppSettings.openAppSettings();
    //                     Navigator.pop(context);
    //                   },
    //                   child: const Text('Settings')),
    //             ],
    //           ));
  }
}

class CheckDir extends ConsumerWidget {
  const CheckDir({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileDir = ref.watch(fileDirProvider);

    return ListTile(
        title: const Text('fileDir'),
        trailing: IconButton(
          // icon: const Icon(Icons.check),
          icon: const Icon(Icons.check),
          onPressed: () {
            final dir = Directory(fileDir);
            final l = dir.listSync();
            print('dir: $l');
          },
        ));
  }
}

class DeleteFiles extends ConsumerWidget {
  const DeleteFiles({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileDir = ref.watch(fileDirProvider);
    return ListTile(
        title: const Text('delete files'),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            final dir = Directory(fileDir);
            dir.listSync().forEach((element) {
              if (element is File) {
                element.deleteSync();
              }
            });
          },
        ));
  }
}

// class CanStartWidget extends ConsumerWidget {
//   const CanStartWidget({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final canStart = ref.watch(canStartRecordingProvider);
//     return StreamBuilder(
//         stream: canStart,
//         builder: (_, snapshot) {
//           if (snapshot.hasData) {
//             return ListTile(
//               title: Text('canStart: ${snapshot.data}'),
//             );
//           } else {
//             return const CircularProgressIndicator();
//           }
//         });
//   }
// }

// class RecordingSignalWidget extends ConsumerWidget {
//   const RecordingSignalWidget({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final recordingSignal = ref.watch(recordingSignalProvider);
//     return StreamBuilder(
//         stream: recordingSignal,
//         builder: (_, snapshot) {
//           if (snapshot.hasData) {
//             return ListTile(
//               title: Text('recordingSignal: ${snapshot.data}'),
//             );
//           } else {
//             return const CircularProgressIndicator();
//           }
//         });
//   }
// }
