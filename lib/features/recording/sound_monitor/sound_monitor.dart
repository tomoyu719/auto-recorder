import 'dart:async';

import 'package:auto_recorder/features/database.dart';
import 'package:auto_recorder/features/recorder.dart';
import 'package:auto_recorder/features/recording/model/recording.dart';
import 'package:auto_recorder/features/recording/sound_monitor/sound_util.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sound_monitor.g.dart';

@Riverpod(keepAlive: true)
class IsActive extends _$IsActive {
  @override
  bool build() => false;

  void onActive() => state = true;
  void onPassive() => state = false;
}

@Riverpod(keepAlive: true)
class IsRecording extends _$IsRecording {
  @override
  bool build() => false;

  void onRecording() => state = true;
  void onFinish() => state = false;
}

typedef RecordingFinishedCallBack = void Function(Recording);

@Riverpod(keepAlive: true)
SoundMonitor soundMonitor(
  SoundMonitorRef ref, {
  required RecordingFinishedCallBack onFinishRecording,
}) =>
    SoundMonitor(ref, onFinishRecording: onFinishRecording);

/// A class that monitors sound and handles recording functionality.
class SoundMonitor {
  SoundMonitor(this.ref, {required this.onFinishRecording});

  final RecordingFinishedCallBack onFinishRecording;

  final Ref ref;
  IsActive get isActiveNotifier => ref.read(isActiveProvider.notifier);
  IsRecording get isRecordingNotifier => ref.read(isRecordingProvider.notifier);
  bool get isActive => ref.read(isActiveProvider);
  bool get isRecording => ref.read(isRecordingProvider);

  Recorder get recorder => ref.read(recorderProvider);

  ProviderSubscription? _recordingSignalSubscription;

  /// Activates the sound monitor.
  ///
  /// This method checks for permission to record audio
  /// and playback status, then starts monitoring the recording signal.
  /// If the user does not grant permission, the method
  /// returns without activating the sound monitor.
  Future<void> active({required VoidCallback onConfirmPermission}) async {
    final hasPermission = await _handlePermission(onConfirmPermission);
    if (!hasPermission) {
      return;
    }
    isActiveNotifier.onActive();
    _recordingSignalSubscription =
        ref.listen(recordingSignalProvider.future, (_, value) async {
      final signal = await value;
      switch (signal) {
        case RecordingSignals.startRecording:
          _startRecording();
        case RecordingSignals.stopRecording:
          await _finishRecording();
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
    if (isRecording) {
      await _finishRecording();
    }
    isActiveNotifier.onPassive();
    _recordingSignalSubscription?.close();
    _recordingSignalSubscription = null;
  }

  void _startRecording() {
    isRecordingNotifier.onRecording();
    final recordStart = DateTime.now();
    recorder.record(recordStart);
  }

  Future<void> _finishRecording() async {
    isRecordingNotifier.onFinish();
    final recording = await recorder.finish();
    if (recording == null) {
      return;
    }
    onFinishRecording(recording);
    await ref.read(databaseProvider).add(recording);
  }
}

Future<bool> _handlePermission(VoidCallback openAppSettings) async {
  final status = await Permission.microphone.status;
  if (status.isPermanentlyDenied) {
    openAppSettings();
    return false;
  } else {
    await Permission.microphone.request();
  }
  return status.isGranted;
}
