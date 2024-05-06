import 'package:auto_recorder/app.dart';
import 'package:auto_recorder/recording.dart';
import 'package:auto_recorder/ui/recording/recording_item.dart';
import 'package:auto_recorder/ui/recording/recording_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('RecordingItem displays correct UI', (tester) async {
    const recording = Recording(id: '1'); // Create a sample recording

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recordingsProvider.overrideWith((ref) => [recording]),
          currentRecordingProvider.overrideWithValue(recording),
          isPlayingCurrentRecordingProvider.overrideWith((ref, arg) => false),
          isSelectingCurrentProvider.overrideWith((ref, arg) => false),
        ],
        child: const App(),
      ),
    );

    expect(find.byIcon(Icons.check), findsNothing);
    expect(find.byIcon(Icons.pause), findsNothing);
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
  });

  testWidgets('RecordingItem displays correct UI when selecting',
      (tester) async {
    const recording = Recording(id: '1'); // Create a sample recording

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recordingsProvider.overrideWith((ref) => [recording]),
          currentRecordingProvider.overrideWithValue(recording),
          isPlayingCurrentRecordingProvider.overrideWith((ref, arg) => false),
          isSelectingCurrentProvider.overrideWith((ref, arg) => true),
        ],
        child: const App(),
      ),
    );

    expect(find.byIcon(Icons.check), findsOneWidget);
    expect(find.byIcon(Icons.pause), findsNothing);
    expect(find.byIcon(Icons.play_arrow), findsNothing);
  });

  testWidgets('RecordingItem displays correct UI when playing', (tester) async {
    const recording = Recording(id: '1');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recordingsProvider.overrideWith((ref) => [recording]),
          currentRecordingProvider.overrideWithValue(recording),
          isPlayingCurrentRecordingProvider.overrideWith((ref, arg) => true),
          isSelectingCurrentProvider.overrideWith((ref, arg) => false),
        ],
        child: const App(),
      ),
    );

    expect(find.byIcon(Icons.check), findsNothing);
    expect(find.byIcon(Icons.pause), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow), findsNothing);
  });
}
