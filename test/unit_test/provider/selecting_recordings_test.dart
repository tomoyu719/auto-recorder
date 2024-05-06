import 'package:auto_recorder/recording.dart';
import 'package:auto_recorder/ui/recording/recording_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_recording.dart';

void main() {
  group('SelectingRecordings', () {
    late ProviderContainer container;

    late List<Recording> mockRecordings;
    setUp(() {
      container = ProviderContainer();

      mockRecordings = [
        MockRecording('1'),
        MockRecording('2'),
        MockRecording('3'),
      ];
    });

    tearDown(() {
      container.dispose();
    });

    test('unSelectAll should clear the state', () {
      final notifier = container.read(selectingRecordingsProvider.notifier);
      for (var recording in mockRecordings) {
        notifier.select(recording);
      }

      notifier.unSelectAll();
      final selectingRecordings = container.read(selectingRecordingsProvider);

      expect(selectingRecordings, isEmpty);
    });

    test('select should add the recording to the state', () {
      final notifier = container.read(selectingRecordingsProvider.notifier);
      final mockRecording = MockRecording('1');
      notifier.select(mockRecording);
      notifier.select(mockRecording);
      final selectingRecordings = container.read(selectingRecordingsProvider);
      expect(selectingRecordings, unorderedEquals([mockRecording]));
    });

    test('unSelect should remove the recording from the state', () {
      final notifier = container.read(selectingRecordingsProvider.notifier);
      for (var recording in mockRecordings) {
        notifier.select(recording);
      }

      final recordingToRemove = mockRecordings[1];

      notifier.unSelect(recordingToRemove);
      final selectingRecordings = container.read(selectingRecordingsProvider);

      expect(selectingRecordings,
          unorderedEquals([mockRecordings[0], mockRecordings[2]]));
    });
  });
}
