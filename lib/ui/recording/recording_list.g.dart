// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recording_list.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recordingsHash() => r'367211fc2d39031f818326ec32d85130928e2634';

/// See also [recordings].
@ProviderFor(recordings)
final recordingsProvider = FutureProvider<List<Recording>>.internal(
  recordings,
  name: r'recordingsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$recordingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RecordingsRef = FutureProviderRef<List<Recording>>;
String _$selectingRecordingsHash() =>
    r'fd20e76b5cddf445655ee1d5a943a5c77f873486';

/// See also [SelectingRecordings].
@ProviderFor(SelectingRecordings)
final selectingRecordingsProvider =
    NotifierProvider<SelectingRecordings, List<Recording>>.internal(
  SelectingRecordings.new,
  name: r'selectingRecordingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectingRecordingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectingRecordings = Notifier<List<Recording>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
