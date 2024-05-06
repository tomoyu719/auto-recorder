import 'package:auto_recorder/providers/undo_remove_recording_service.dart';
import 'package:auto_recorder/recording.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final removeRecordingServiceProvider =
    Provider((ref) => RemoveRecordingService(ref));

class RemoveRecordingService {
  final Ref ref;

  RemoveRecordingService(this.ref);
  void remove(Recording target, int index) {
    ref.read(undoRemoveRecordingServiceProvider).onRemove(index, target);
    // throw UnimplementedError();
  }
}
