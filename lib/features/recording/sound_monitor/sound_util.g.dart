// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sound_util.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dbfsHash() => r'29aed03daa2333a56f475f0aa5691d17c0742dde';

/// A StreamProvider that emits the decibel full scale (dBFS) values.
///
/// The [dbfs] stream emits the dBFS values based on the microphone input.
/// It uses the [MicStream.microphone] stream from the audio package to capture
/// the microphone audio and convert it to dBFS values.
///
/// The [minDb] and [maxDb] parameters define the minimum and
/// maximum dBFS values that the emitted values will be clamped to.
///
/// Copied from [dbfs].
@ProviderFor(dbfs)
final dbfsProvider = StreamProvider<double>.internal(
  dbfs,
  name: r'dbfsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dbfsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DbfsRef = StreamProviderRef<double>;
String _$elapsedLastDetectionHash() =>
    r'82cd686bdc35bb1225256cda843abfe0d846cc20';

/// A StreamProvider that emits the elapsed time since
/// the last loudness detection.
/// This provider to calculate the time remaining until the end of
/// recording [remainProvider].
///
/// This stream emits a [Duration] representing the time elapsed since
/// the last detection.
/// If the noise detection is not active, emits a [Duration] of zero.
/// If the noise detection is active, it calculates the difference between
/// the elapsed time and the time of the latest detection.
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
String _$elapsedHash() => r'476fb4c5485ee1530369e473689b989fe3862416';

/// A StreamProvider that emits the elapsed time. Used to display recording
/// time and terminate recordings that are too long
///
/// This emits the elapsed time periodically based on the [monitorDuration].
/// It only emits the elapsed time when the recording is in progress.
/// If the recording is not in progress, it emits a duration of zero.
///
/// Copied from [elapsed].
@ProviderFor(elapsed)
final elapsedProvider = StreamProvider<Duration>.internal(
  elapsed,
  name: r'elapsedProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$elapsedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ElapsedRef = StreamProviderRef<Duration>;
String _$latestDetectionTimeHash() =>
    r'bfefab9891f44501f9b15cb1e2693735faeb4892';

/// StreamProvider that emits the latest loudness detection time.
///
/// The [latestDetectionStateProvider] state provider is used to store and
/// access the latest detection duration.
///
/// Copied from [latestDetectionTime].
@ProviderFor(latestDetectionTime)
final latestDetectionTimeProvider = StreamProvider<Duration>.internal(
  latestDetectionTime,
  name: r'latestDetectionTimeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$latestDetectionTimeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LatestDetectionTimeRef = StreamProviderRef<Duration>;
String _$recordingSignalHash() => r'2ecb2cb324c82e628f13cbe4e5638e883fd2f818';

/// A streamProvider that emits [RecordingSignals] based on
/// the provided conditions. Used to end and start recordings.
///
/// This emits [RecordingSignals.startRecording] when the current decibel
/// level is greater than the threshold and recording is not in progress.
///
/// This emits [RecordingSignals.stopRecording] when the elapsed time
/// exceeds the maximum wait time and recording is in progress.
///
/// This also emits [RecordingSignals.stopRecording] when the remaining time
/// is less than or equal to zero and recording is in progress.
///
/// Otherwise, this emits [RecordingSignals.none].
///
/// Copied from [recordingSignal].
@ProviderFor(recordingSignal)
final recordingSignalProvider = StreamProvider<RecordingSignals>.internal(
  recordingSignal,
  name: r'recordingSignalProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recordingSignalHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RecordingSignalRef = StreamProviderRef<RecordingSignals>;
String _$remainHash() => r'3fd70366e1859d28039a63447b3afc0ce8602a42';

/// A streamProvider that emits the remaining duration until the end of
/// recording. Used to display and terminate recordings.
///
/// Copied from [remain].
@ProviderFor(remain)
final remainProvider = StreamProvider<Duration>.internal(
  remain,
  name: r'remainProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$remainHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RemainRef = StreamProviderRef<Duration>;
String _$latestDetectionStateHash() =>
    r'90cf1519fcfc8101b73a2213a98d17a66620a6e6';

/// See also [LatestDetectionState].
@ProviderFor(LatestDetectionState)
final latestDetectionStateProvider =
    NotifierProvider<LatestDetectionState, Duration>.internal(
  LatestDetectionState.new,
  name: r'latestDetectionStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$latestDetectionStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LatestDetectionState = Notifier<Duration>;
String _$thresholdDbfsHash() => r'e1422d9d6519428189c7d7d8a295f9b4f0cc73a7';

/// See also [ThresholdDbfs].
@ProviderFor(ThresholdDbfs)
final thresholdDbfsProvider = NotifierProvider<ThresholdDbfs, int>.internal(
  ThresholdDbfs.new,
  name: r'thresholdDbfsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$thresholdDbfsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ThresholdDbfs = Notifier<int>;
String _$waitingTimeHash() => r'83f38be4731562dc5a974ca6f160de527f49abb6';

/// See also [WaitingTime].
@ProviderFor(WaitingTime)
final waitingTimeProvider = NotifierProvider<WaitingTime, Duration>.internal(
  WaitingTime.new,
  name: r'waitingTimeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$waitingTimeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WaitingTime = Notifier<Duration>;
String _$recordingTimeLimitHash() =>
    r'91d440866db6d20f3e228e099402aa9aec2982d6';

/// See also [RecordingTimeLimit].
@ProviderFor(RecordingTimeLimit)
final recordingTimeLimitProvider =
    NotifierProvider<RecordingTimeLimit, Duration>.internal(
  RecordingTimeLimit.new,
  name: r'recordingTimeLimitProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recordingTimeLimitHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RecordingTimeLimit = Notifier<Duration>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
