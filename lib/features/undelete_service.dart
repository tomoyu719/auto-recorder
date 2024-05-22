import 'dart:io';
import 'dart:typed_data';

import 'package:auto_recorder/features/recording/model/recording.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final undeleteServiceProvider = Provider(UndeleteService.new);

typedef OnUndeleteCallback = void Function(int index, Recording target);

class UndeleteService {
  UndeleteService(this.ref);
  Recording? _removedRecording;
  int? _removedIndex;
  Uint8List? _removedAudio;

  final Ref ref;

  void onRemove(int index, Recording target) {
    _removedIndex = index;
    _removedRecording = target;
    try {
      _removedAudio = File(target.path!).readAsBytesSync();
    } on PathNotFoundException catch (e) {
      debugPrint('Error reading file: $e');
    }
  }

  void undelete({
    required OnUndeleteCallback onUndelete,
    required VoidCallback onUndeleteFailed,
  }) {
    if (_removedIndex != null &&
        _removedRecording != null &&
        _removedAudio != null) {
      onUndelete(_removedIndex!, _removedRecording!);
      File(_removedRecording!.path!).writeAsBytesSync(_removedAudio!);
      _removedIndex = null;
      _removedRecording = null;
      _removedAudio = null;
    } else {
      onUndeleteFailed();
    }
  }
}
