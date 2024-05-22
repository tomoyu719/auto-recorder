import 'package:auto_recorder/features/file_dir.dart';
import 'package:auto_recorder/features/player.dart';
import 'package:auto_recorder/features/recording/model/recording.dart';
import 'package:auto_recorder/features/recording/sound_monitor/sound_util.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sound_monitor.g.dart';

final isActiveProvider = StateProvider<bool>((_) => false);

final isRecordingProvider = StateProvider<bool>((_) => false);

typedef RecordingFinishedCallBack = void Function(Recording);

@Riverpod(keepAlive: true)
SoundMonitor soundMonitor(
  SoundMonitorRef ref, {
  required RecordingFinishedCallBack onFinishRecording,
  required VoidCallback openAppSettings,
}) =>
    SoundMonitor(ref, onFinishRecording, openAppSettings);

/// A class that monitors sound and handles recording functionality.
class SoundMonitor {
  SoundMonitor(this.ref, this.onFinishRecording, this.onConfirmPermission)
      : recorder = AudioRecorder();

  final RecordingFinishedCallBack onFinishRecording;
  final VoidCallback onConfirmPermission;
  final Ref ref;
  final AudioRecorder recorder;

  ProviderSubscription? _recordingSignalSubscription;

  DateTime? _startRecordingTime;
  String? _outputFileName;
  String? _outputFilePath;

  /// Activates the sound monitor.
  ///
  /// This method checks for permission to record audio
  /// and playback status, then starts monitoring the recording signal.
  /// If the user does not grant permission, the method
  /// returns without activating the sound monitor.
  Future<void> active() async {
    final hasPermission = await handlePermission(onConfirmPermission);
    if (!hasPermission) {
      return;
    }
    final isPlaying = ref.read(isPlayingProvider);
    if (isPlaying) {
      ref.read(audioPlayerProvider).stop();
    }
    ref.read(isActiveProvider.notifier).state = true;
    _recordingSignalSubscription =
        ref.listen(recordingSignalProvider.future, (_, value) async {
      final signal = await value;
      switch (signal) {
        case RecordingSignals.startRecording:
          _onStartRecord();
        case RecordingSignals.stopRecording:
          await _onFinishRecord();
        case RecordingSignals.none:
          break;
      }
    });
  }

  /// Deactivates the sound monitor.
  ///
  /// This method stops monitoring the recording signal and
  /// sets the active state to false.
  /// If a recording is in progress, it is finished before deactivating
  /// the sound monitor.
  Future<void> passive() async {
    ref.read(isActiveProvider.notifier).state = false;
    if (ref.read(isRecordingProvider)) {
      await _onFinishRecord();
    }
    ref.read(isRecordingProvider.notifier).state = false;
    _recordingSignalSubscription?.close();
    _recordingSignalSubscription = null;
  }

  void _onStartRecord() {
    if (ref.read(isRecordingProvider)) {
      return;
    }
    ref.read(isRecordingProvider.notifier).state = true;
    _startRecordingTime = DateTime.now();
    _outputFileName =
        'recording_${_startRecordingTime!.millisecondsSinceEpoch}.m4a';
    _outputFilePath = join(ref.read(audiosFileDirProvider), _outputFileName);
    recorder.start(const RecordConfig(), path: _outputFilePath!);
  }

  Future<void> _onFinishRecord() async {
    if (!ref.read(isRecordingProvider)) {
      return;
    }
    ref.read(isRecordingProvider.notifier).state = false;

    await recorder.stop();
    final duration =
        await ref.read(audioPlayerProvider).getDuration(_outputFilePath!);
    if (duration == null) {
      return;
    }
    final recording = Recording(
      date: _startRecordingTime,
      path: _outputFilePath,
      milliSeconds: duration.inMilliseconds,
    );
    onFinishRecording(recording);
  }
}

Future<bool> handlePermission(VoidCallback openAppSettings) async {
  final status = await Permission.microphone.status;
  if (status.isPermanentlyDenied) {
    openAppSettings();
    return false;
  } else {
    await Permission.microphone.request();
  }
  return status.isGranted;
}
