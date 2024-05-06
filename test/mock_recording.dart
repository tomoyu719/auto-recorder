import 'package:auto_recorder/recording.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRecording extends Fake implements Recording {
  @override
  final String id;
  MockRecording(this.id);
}
// class MockRecording implements Recording {
//   @override
//   // TODO: implement date
//   DateTime get date => throw UnimplementedError();
// }
