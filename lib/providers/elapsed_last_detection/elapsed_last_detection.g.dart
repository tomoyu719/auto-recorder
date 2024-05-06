// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'elapsed_last_detection.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$elapsedLastDetectionHash() =>
    r'7badb496b7ba2d8d9badaa1d24225a38c05f23bd';

/// A stream provider that emits the latest detection duration.　This provider is intended to be used by other providers, not the UI.
///
/// This provider listens to changes in the [isRecordingProvider] and [thresholdDbfsProvider]
/// and emits the elapsed duration since the last detection. If recording is not in progress,
/// it emits a duration of zero.
///
/// The [elapsedProvider] is used to determine if the current audio level exceeds the threshold.
/// The [latestDetectionProvider] is used to prevent this provider from being updated by itself.
///
/// Copied from [elapsedLastDetection].
@ProviderFor(elapsedLastDetection)
final elapsedLastDetectionProvider = StreamProvider<Duration>.internal(
  elapsedLastDetection,
  name: r'elapsedLastDetectionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$elapsedLastDetectionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ElapsedLastDetectionRef = StreamProviderRef<Duration>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
