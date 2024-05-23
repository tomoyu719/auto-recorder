import 'dart:io';

import 'package:auto_recorder/features/database.dart';
import 'package:auto_recorder/features/recording/model/recording.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import '../mock/mock_recording.dart';

void main() {
  group('Database', () {
    late Database database;
    late Isar isar;

    setUp(() async {
      // Initialize the database instance
      await Isar.initializeIsarCore(download: true);
      final dir = await Directory.systemTemp.createTemp();
      isar = await Isar.open([RecordingSchema], directory: dir.path);
      database = Database(isar);
    });

    tearDown(() async {
      await isar.close();
    });

    test('onAdd should add a recording to the database', () async {
      await database.add(mockRecording);

      expect((await database.getAll()).length, 1);
    });

    test('getAll should return all recordings from the database', () async {
      for (final recording in mockRecordings) {
        await database.add(recording);
      }

      final allRecordings = await database.getAll();

      expect(allRecordings.length, mockRecordings.length);
    });

    test('delete should remove a recording from the database', () async {
      for (final recording in mockRecordings) {
        await database.add(recording);
      }

      await database.delete((await database.getAll()).first);

      final allRecordings = await database.getAll();

      expect(allRecordings.length, 2);
    });
  });
}
