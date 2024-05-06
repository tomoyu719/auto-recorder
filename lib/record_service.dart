import 'dart:io';
import 'dart:typed_data';

import 'package:auto_recorder/recording.dart';

class RecordService {
  IOSink? sink;

  void record(Stream<Uint8List> pcm, File file) {
    sink = file.openWrite();
    sink!.addStream(pcm);
    // pcm.listen((pcm) {
    //   sink?.add(pcm);
    // });
  }

  Recording stop() {
    sink?.close();
    sink = null;
    final recording = Recording();
    return recording;
  }
}
