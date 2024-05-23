import 'package:auto_recorder/app.dart';
import 'package:auto_recorder/features/recording/recording_page.dart';
import 'package:auto_recorder/features/recording/sound_monitor/sound_monitor.dart';
import 'package:auto_recorder/features/recording/widget/recording_list_item.dart';

import 'package:auto_recorder/features/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mock/mock_recording.dart';

void main() {
  SharedPreferences.setMockInitialValues({});
  late SharedPreferences sharedPreferences;
  setUp(() async {
    sharedPreferences = await SharedPreferences.getInstance();
  });

  testWidgets('RecordingItem displays correct UI', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          fetchRecordingsProvider.overrideWith((ref) => [mockRecording]),
          recordingListItemProvider.overrideWithValue(mockRecording),
          isPlayingCurrentRecordingProvider.overrideWith((ref, arg) => false),
          isSelectingCurrentProvider.overrideWith((ref, arg) => false),
        ],
        child: const App(),
      ),
    );

    expect(find.byIcon(Icons.check), findsNothing);
    expect(find.byIcon(Icons.stop), findsNothing);
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
  });

  testWidgets('RecordingItem displays correct UI when selecting',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          fetchRecordingsProvider.overrideWith((ref) => [mockRecording]),
          recordingListItemProvider.overrideWithValue(mockRecording),
          isPlayingCurrentRecordingProvider.overrideWith((ref, arg) => false),
          isSelectingCurrentProvider.overrideWith((ref, arg) => true),
        ],
        child: const App(),
      ),
    );

    expect(find.byIcon(Icons.check), findsOneWidget);
    expect(find.byIcon(Icons.stop), findsNothing);
    expect(find.byIcon(Icons.play_arrow), findsNothing);
  });

  testWidgets('RecordingItem displays correct UI when playing', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          fetchRecordingsProvider.overrideWith((ref) => [mockRecording]),
          recordingListItemProvider.overrideWithValue(mockRecording),
          isPlayingCurrentRecordingProvider.overrideWith((ref, arg) => true),
          isSelectingCurrentProvider.overrideWith((ref, arg) => false),
          isActiveProvider.overrideWith((ref) => false),
        ],
        child: const App(),
      ),
    );

    expect(find.byIcon(Icons.check), findsNothing);
    expect(find.byIcon(Icons.stop), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow), findsNothing);
  });
}
