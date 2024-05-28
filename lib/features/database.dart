import 'package:auto_recorder/features/recording/model/recording.dart';

import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database.g.dart';

@Riverpod(keepAlive: true)
Database database(DatabaseRef ref) => throw UnimplementedError(
      'databaseProvider must override at main function',
    );

class Database {
  const Database(this._isar);
  final Isar _isar;

  Future<void> add(Recording recording) async {
    await _isar.writeTxn(() async {
      await _isar.recordings.put(recording);
    });
  }

  Future<List<Recording>> getAll() async {
    late final List<Recording> allRecordings;

    await _isar.txn(() async {
      allRecordings = await _isar.recordings.where().findAll();
    });
    return allRecordings;
  }

  Future<void> delete(Recording recording) async {
    await _isar.writeTxn(() async {
      await _isar.recordings.delete(recording.id);
    });
  }
}
