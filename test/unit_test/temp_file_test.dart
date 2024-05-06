import 'package:auto_recorder/temp_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';

void main() {
  test('TempFile outputFile should return a File with the correct file path',
      () {
    const fileDir = '/path/to/directory';
    const tempFile = TempFile(fileDir);
    final date = DateTime(2022, 1, 1, 12, 0, 0);
    const expectedFileName = '2022-01-01_12-00-00';
    final expectedFilePath = join(fileDir, expectedFileName);

    final outputFile = tempFile.outputFile(date);

    expect(outputFile.path, expectedFilePath);
  });
}
