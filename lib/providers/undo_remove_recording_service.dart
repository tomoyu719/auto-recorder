import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:auto_recorder/recording.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final undoRemoveRecordingServiceProvider =
    Provider((ref) => UndoRemoveRecordingService(ref));

typedef OnUndoRemoveRecording = void Function(int index, Recording target);

class UndoRemoveRecordingService {
  Recording? removedRecording;
  int? removedIndex;
  // Uint8List? removedAudio;

  final Ref ref;
  UndoRemoveRecordingService(this.ref);

  void onRemove(int index, Recording target) {
    removedIndex = index;
    removedRecording = target;
    // if (removedIndex != null && removedRecording != null
    //     // &&removedAudio != null
    //     ) {
    //   removedIndex = index;
    //   removedRecording = target;
    //   // removedAudio = File(target.path!).readAsBytesSync();
    // }
  }

  void undo({required OnUndoRemoveRecording onUndo}) {
    print('removedIndex: $removedIndex');
    if (removedIndex != null && removedRecording != null
        // &&removedAudio != null
        ) {
      onUndo(removedIndex!, removedRecording!);
      // File(removedRecording!.path!).writeAsBytesSync(removedAudio!);
      removedIndex = null;
      removedRecording = null;
      // removedAudio = null;
    }
  }
}
