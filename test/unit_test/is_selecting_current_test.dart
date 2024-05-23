import 'package:auto_recorder/features/recording/widget/recording_list_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock/mock_recording.dart';

void main() {
  group('isSelectingCurrentProvider', () {
    test('should return true when recording is in selectingRecordings', () {
      // Arrange
      final container = ProviderContainer();

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

      container
          .read(selectingRecordingsProvider.notifier)
          .select(mockRecording);

      // Act
      final result =
          container.read(isSelectingCurrentProvider(otherMockRecording));

      // Assert
      expect(result, false);
    });
  });
}
