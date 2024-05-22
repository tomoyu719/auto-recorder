import 'dart:io';

import 'package:auto_recorder/features/database.dart';
import 'package:auto_recorder/features/recording/model/recording.dart';
import 'package:auto_recorder/features/recording/widget/recording_list_item.dart';
import 'package:auto_recorder/features/undelete_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final removeRecordingServiceProvider = Provider(RemoveRecordingService.new);

class RemoveRecordingService {
  RemoveRecordingService(this.ref);
  final Ref ref;

  void onRemove(Recording target, int index, {bool isRequiredUndo = true}) {
    ref.read(selectingRecordingsProvider.notifier).unSelect(target);
    if (isRequiredUndo) {
      ref.read(undeleteServiceProvider).onRemove(index, target);
    }
    try {
      File(target.path!).delete();
    } on PathNotFoundException catch (_) {
      // debugPrint('Error deleting file: $e');
    }
    ref.read(databaseProvider).delete(target);
  }
}
