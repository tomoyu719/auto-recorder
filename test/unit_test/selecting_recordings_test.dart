import 'package:auto_recorder/features/recording/widget/recording_list_item.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock/mock_recording.dart';

void main() {
  group('SelectingRecordings', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('unSelectAll should clear the state', () {
      final notifier = container.read(selectingRecordingsProvider.notifier);
      mockRecordings.forEach(notifier.select);

      notifier.unSelectAll();
      final selectingRecordings = container.read(selectingRecordingsProvider);

      expect(selectingRecordings, isEmpty);
    });

    test('select should add the recording to the state', () {
      container
          .read(selectingRecordingsProvider.notifier)
          .select(mockRecording);
      final selectingRecordings = container.read(selectingRecordingsProvider);
      expect(selectingRecordings, unorderedEquals([mockRecording]));
    });

    test('unSelect should remove the recording from the state', () {
      final notifier = container.read(selectingRecordingsProvider.notifier);
      mockRecordings.forEach(notifier.select);

      final recordingToRemove = mockRecordings[1];

      notifier.unSelect(recordingToRemove);
      final selectingRecordings = container.read(selectingRecordingsProvider);

      expect(
        selectingRecordings,
        unorderedEquals([mockRecordings[0], mockRecordings[2]]),
      );
    });
  });
}
