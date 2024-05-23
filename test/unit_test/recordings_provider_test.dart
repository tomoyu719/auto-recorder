import 'package:auto_recorder/features/database.dart';
import 'package:auto_recorder/features/recording/recording_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock/mock_database.dart';
import '../mock/mock_recording.dart';

void main() {
  group('recordings', () {
    test('should return sorted list of recordings', () async {
      // Arrange
      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(MockDatabase(mockRecordings)),
        ],
      );

      // Act
      final result = await container.read(fetchRecordingsProvider.future);

      // Assert
      // result is sorted in descending order
      expect(result, orderedEquals(mockRecordingsDesendingOrder));
    });
  });
}
