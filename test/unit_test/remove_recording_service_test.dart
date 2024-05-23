import 'package:auto_recorder/features/database.dart';
import 'package:auto_recorder/features/recording/widget/recording_list_item.dart';
import 'package:auto_recorder/features/remove_recording_service.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock/mock_database.dart';
import '../mock/mock_recording.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(MockDatabase([])),
      ],
    );
  });
  tearDown(() => container.dispose());

  group('onRemove', () {
    test('should unselect the target recording', () {
      // Arrange
      const index = 0;
      container
          .read(selectingRecordingsProvider.notifier)
          .select(mockRecording);
      expect(container.read(selectingRecordingsProvider), [mockRecording]);

      // Act
      container
          .read(removeRecordingServiceProvider)
          .onRemove(mockRecording, index);

      // Assert
      expect(container.read(selectingRecordingsProvider), isEmpty);
    });
  });
}
