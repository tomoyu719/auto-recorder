// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sound_monitor.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$soundMonitorHash() => r'366c3e0be8576b5d8214f2d3e318e1870fc882f0';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [soundMonitor].
@ProviderFor(soundMonitor)
const soundMonitorProvider = SoundMonitorFamily();

/// See also [soundMonitor].
class SoundMonitorFamily extends Family<SoundMonitor> {
  /// See also [soundMonitor].
  const SoundMonitorFamily();

  /// See also [soundMonitor].
  SoundMonitorProvider call({
    required void Function(Recording) onFinishRecording,
  }) {
    return SoundMonitorProvider(
      onFinishRecording: onFinishRecording,
    );
  }

  @override
  SoundMonitorProvider getProviderOverride(
    covariant SoundMonitorProvider provider,
  ) {
    return call(
      onFinishRecording: provider.onFinishRecording,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'soundMonitorProvider';
}

/// See also [soundMonitor].
class SoundMonitorProvider extends Provider<SoundMonitor> {
  /// See also [soundMonitor].
  SoundMonitorProvider({
    required void Function(Recording) onFinishRecording,
  }) : this._internal(
          (ref) => soundMonitor(
            ref as SoundMonitorRef,
            onFinishRecording: onFinishRecording,
          ),
          from: soundMonitorProvider,
          name: r'soundMonitorProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$soundMonitorHash,
          dependencies: SoundMonitorFamily._dependencies,
          allTransitiveDependencies:
              SoundMonitorFamily._allTransitiveDependencies,
          onFinishRecording: onFinishRecording,
        );

  SoundMonitorProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.onFinishRecording,
  }) : super.internal();

  final void Function(Recording) onFinishRecording;

  @override
  Override overrideWith(
    SoundMonitor Function(SoundMonitorRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SoundMonitorProvider._internal(
        (ref) => create(ref as SoundMonitorRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        onFinishRecording: onFinishRecording,
      ),
    );
  }

  @override
  ProviderElement<SoundMonitor> createElement() {
    return _SoundMonitorProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SoundMonitorProvider &&
        other.onFinishRecording == onFinishRecording;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, onFinishRecording.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SoundMonitorRef on ProviderRef<SoundMonitor> {
  /// The parameter `onFinishRecording` of this provider.
  void Function(Recording) get onFinishRecording;
}

class _SoundMonitorProviderElement extends ProviderElement<SoundMonitor>
    with SoundMonitorRef {
  _SoundMonitorProviderElement(super.provider);

  @override
  void Function(Recording) get onFinishRecording =>
      (origin as SoundMonitorProvider).onFinishRecording;
}

String _$isActiveHash() => r'8d8a278c94c74fa1bbf4e453da4f5f4c53f83694';

/// See also [IsActive].
@ProviderFor(IsActive)
final isActiveProvider = NotifierProvider<IsActive, bool>.internal(
  IsActive.new,
  name: r'isActiveProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isActiveHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$IsActive = Notifier<bool>;
String _$isRecordingHash() => r'28de3246515e356778720e34088d78789b6b6dba';

/// See also [IsRecording].
@ProviderFor(IsRecording)
final isRecordingProvider = NotifierProvider<IsRecording, bool>.internal(
  IsRecording.new,
  name: r'isRecordingProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isRecordingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$IsRecording = Notifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
