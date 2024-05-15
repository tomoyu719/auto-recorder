import 'package:auto_recorder/recording.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

final databaseProvider = Provider<Database>((ref) => throw UnimplementedError(
    'databaseProvider must override at main function'));

class Database {
  final Isar _isar;

  const Database(this._isar);

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
      final r = await _isar.recordings.delete(recording.id);
      // final r = await _isar.recordings.where().deleteAll();
    });
  }
}
