// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'latest_detection.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$latestDetectionHash() => r'6277a2295a4f14cf69590bae89a3487efd0d64a2';

/// A stream provider that emits the latest detection duration.　This provider is intended to be used by other providers, not the UI.
///
/// This provider listens to changes in the [isRecordingProvider] and [thresholdDbSplProvider]
/// and emits the elapsed duration since the last detection. If recording is not in progress,
/// it emits a duration of zero.
///
/// The [dbSplProvider] is used to determine if the current audio level exceeds the threshold.
/// The [elapsedProvider] is used to prevent this provider from being updated by itself.
///
/// Copied from [latestDetection].
@ProviderFor(latestDetection)
final latestDetectionProvider = StreamProvider<Duration>.internal(
  latestDetection,
  name: r'latestDetectionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$latestDetectionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LatestDetectionRef = StreamProviderRef<Duration>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
