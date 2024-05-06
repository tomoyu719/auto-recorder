import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart';

class TempFile {
  static final formatter = DateFormat('yyyy-MM-dd_HH-mm-ss');
  final String fileDir;
  const TempFile(this.fileDir);
  String _parse(DateTime date) => formatter.format(date);
  String _fileName(DateTime date) => _parse(date);

  File outputFile(DateTime date) {
    final fileName = _fileName(date);
    final outputfilePath = join(fileDir, fileName);
    return File(outputfilePath);
  }
}
