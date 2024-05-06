import 'dart:async';
import 'dart:typed_data';
import 'package:auto_recorder/recording.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:file/file.dart';
import 'package:file/memory.dart';

import 'package:auto_recorder/record_service.dart';

void main() {
  group('RecordService', () {
    late RecordService recordService;
    late StreamController<Uint8List> streamController;
    late File outputFile;
    late Stream<Uint8List> mockPcmStream;
    late FileSystem fs;

    setUp(() async {
      recordService = RecordService();
      streamController = StreamController<Uint8List>();
      mockPcmStream = streamController.stream;

      fs = MemoryFileSystem();
      final tmp = await fs.systemTempDirectory.createTemp('example_');
      outputFile = tmp.childFile('output');
    });

    test('record should write pcmStream to file', () async {
      streamController.add(Uint8List.fromList([1, 2, 3, 4, 5]));

      recordService.record(mockPcmStream, outputFile);
      await Future.delayed(const Duration(seconds: 1));
      recordService.stop();
      expect(outputFile.existsSync(), true);
      expect(outputFile.readAsBytesSync(), [1, 2, 3, 4, 5]);
    });

    test('stop should close the file and return a Recording object', () async {
      recordService.record(mockPcmStream, outputFile);
      final recording = recordService.stop();

      expect(recording, isA<Recording>());
    });
  });
}
