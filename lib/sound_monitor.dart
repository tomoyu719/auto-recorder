import 'dart:math';
import 'dart:ui';

import 'package:auto_recorder/audio_encoder.dart';
import 'package:auto_recorder/providers/is_active.dart';
import 'package:auto_recorder/providers/permission/permission.dart';
import 'package:auto_recorder/providers/recording_signal/recording_signal.dart';
import 'package:auto_recorder/recording.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'providers/is_recording.dart';
import 'record_service.dart';

part 'sound_monitor.g.dart';

typedef RecordingFinishedCallBack = void Function(Recording);
typedef DialogCallback = void Function(BuildContext);

@Riverpod(keepAlive: true)
SoundMonitor soundMonitor(
  SoundMonitorRef ref, {
  RecordingFinishedCallBack? onFinishRecording,
  DialogCallback? onConfirmPermission,
}) =>
    SoundMonitor(ref, onFinishRecording, onConfirmPermission);

class SoundMonitor {
  SoundMonitor(this.ref, this.onFinishRecording, this.onConfirmPermission)
      : recorder = RecordService(),
        encoder = AudioEncoder();

  final RecordingFinishedCallBack? onFinishRecording;
  final DialogCallback? onConfirmPermission;

  final Ref ref;

  final RecordService recorder;
  final AudioEncoder encoder;

  ProviderSubscription? _startRecordingSignalSubscription;
  ProviderSubscription? _stopRecordingSignalSubscription;

  void active() async {
    final hasPermission = await handlePermission(onConfirmPermission);
    if (!hasPermission) return;
    ref.read(isActiveProvider.notifier).state = true;
    _startRecordingSignalSubscription ??=
        ref.listen(startRecordingProvider.future, (_, isStart) async {
      if (await isStart) {
        ref.read(isRecordingProvider.notifier).state = true;
      }
    });
    _stopRecordingSignalSubscription ??=
        ref.listen(stopRecordingProvider.future, (_, isStop) async {
      if (await isStop) {
        ref.read(isRecordingProvider.notifier).state = false;
      }
    });
  }

  void passive() {
    // final isRecording = ref.watch(isRecordingProvider);
    // if (isRecording) {
    //   _onFinishRecord();
    // }
    ref.read(isActiveProvider.notifier).state = false;
    ref.read(isRecordingProvider.notifier).state = false;
    _startRecordingSignalSubscription?.close();
    _startRecordingSignalSubscription = null;
    _stopRecordingSignalSubscription?.close();
    _stopRecordingSignalSubscription = null;
  }

  void _onStartRecord() {
    ref.read(isRecordingProvider.notifier).state = true;
    // final fileDir = ref.read(fileDirProvider);
    // final tempFile = TempFile(fileDir);
    // final file = tempFile.outputFile(DateTime.now());
    // recorder.record(ref.read(pcmProvider), file);
  }

  void _onFinishRecord() async {
    ref.read(isRecordingProvider.notifier).state = false;
    final recording = recorder.stop();
    await encoder.encode(recording);
    onFinishRecording?.call(recording);
  }
}
