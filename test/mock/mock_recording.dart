import 'package:auto_recorder/features/recording/model/recording.dart';

final mockRecording =
    Recording(date: DateTime(1994, 7, 19), path: 'tmp.wav', milliSeconds: 0);
final otherMockRecording =
    Recording(date: DateTime(1991, 8, 14), path: '', milliSeconds: 0);

final mockRecordings = [
  Recording(date: DateTime(1999, 12, 31, 23, 57), path: '', milliSeconds: 0),
  Recording(date: DateTime(1999, 12, 31, 23, 59), path: '', milliSeconds: 0),
  Recording(date: DateTime(1999, 12, 31, 23, 58), path: '', milliSeconds: 0),
];
final mockRecordingsDesendingOrder = [
  Recording(date: DateTime(1999, 12, 31, 23, 59), path: '', milliSeconds: 0),
  Recording(date: DateTime(1999, 12, 31, 23, 58), path: '', milliSeconds: 0),
  Recording(date: DateTime(1999, 12, 31, 23, 57), path: '', milliSeconds: 0),
];
