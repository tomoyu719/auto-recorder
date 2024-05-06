import 'package:auto_recorder/ui/recording/recording_item.dart';
import 'package:auto_recorder/ui/recording/recording_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_recording.dart';

void main() {
  group('isSelectingCurrentProvider', () {
    test('should return true when recording is in selectingRecordings', () {
      // Arrange
      final container = ProviderContainer();
      final mockRecording = MockRecording('1');
      container
          .read(selectingRecordingsProvider.notifier)
          .select(mockRecording);

      // Act
      final result = container.read(isSelectingCurrentProvider(mockRecording));

      // Assert
      expect(result, true);
    });

    test('should return false when recording is not in selectingRecordings',
        () {
      final container = ProviderContainer();
      final mockRecording = MockRecording('1');
      container
          .read(selectingRecordingsProvider.notifier)
          .select(mockRecording);

      // Act
      final result =
          container.read(isSelectingCurrentProvider(MockRecording('2')));

      // Assert
      expect(result, false);
    });
  });
}
