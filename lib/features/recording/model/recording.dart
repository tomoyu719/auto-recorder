import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'recording.freezed.dart';
part 'recording.g.dart';

/// A dataclass representing a recording.
///
/// This class is used to store information about a recording, including
/// its ID, date, file path, and duration in milliseconds.
@freezed
@Collection(ignore: {'copyWith'})
class Recording with _$Recording {
  const factory Recording({
    @Default(Isar.autoIncrement) Id id,
    required DateTime? date,
    required String? path,
    required int? milliSeconds,
  }) = _Recording;
  const Recording._();

  @override
  // ignore: unnecessary_overrides
  Id get id => super.id;
}
