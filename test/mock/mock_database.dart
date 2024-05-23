import 'package:auto_recorder/features/database.dart';
import 'package:auto_recorder/features/recording/model/recording.dart';

import 'package:flutter_test/flutter_test.dart';

class MockDatabase extends Fake implements Database {
  MockDatabase(this.mockRecordings);
  final List<Recording> mockRecordings;
  @override
  Future<List<Recording>> getAll() async {
    return mockRecordings;
  }

  @override
  Future<void> delete(Recording recording) async {}
}
