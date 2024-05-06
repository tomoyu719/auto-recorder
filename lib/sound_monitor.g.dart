// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sound_monitor.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$soundMonitorHash() => r'5564f153c91d629e34b048bc1619d12c71465847';

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
    void Function(Recording)? onFinishRecording,
    void Function(BuildContext)? onConfirmPermission,
  }) {
    return SoundMonitorProvider(
      onFinishRecording: onFinishRecording,
      onConfirmPermission: onConfirmPermission,
    );
  }

  @override
  SoundMonitorProvider getProviderOverride(
    covariant SoundMonitorProvider provider,
  ) {
    return call(
      onFinishRecording: provider.onFinishRecording,
      onConfirmPermission: provider.onConfirmPermission,
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
    void Function(Recording)? onFinishRecording,
    void Function(BuildContext)? onConfirmPermission,
  }) : this._internal(
          (ref) => soundMonitor(
            ref as SoundMonitorRef,
            onFinishRecording: onFinishRecording,
            onConfirmPermission: onConfirmPermission,
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
          onConfirmPermission: onConfirmPermission,
        );

  SoundMonitorProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.onFinishRecording,
    required this.onConfirmPermission,
  }) : super.internal();

  final void Function(Recording)? onFinishRecording;
  final void Function(BuildContext)? onConfirmPermission;

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
        onConfirmPermission: onConfirmPermission,
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
        other.onFinishRecording == onFinishRecording &&
        other.onConfirmPermission == onConfirmPermission;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, onFinishRecording.hashCode);
    hash = _SystemHash.combine(hash, onConfirmPermission.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SoundMonitorRef on ProviderRef<SoundMonitor> {
  /// The parameter `onFinishRecording` of this provider.
  void Function(Recording)? get onFinishRecording;

  /// The parameter `onConfirmPermission` of this provider.
  void Function(BuildContext)? get onConfirmPermission;
}

class _SoundMonitorProviderElement extends ProviderElement<SoundMonitor>
    with SoundMonitorRef {
  _SoundMonitorProviderElement(super.provider);

  @override
  void Function(Recording)? get onFinishRecording =>
      (origin as SoundMonitorProvider).onFinishRecording;
  @override
  void Function(BuildContext)? get onConfirmPermission =>
      (origin as SoundMonitorProvider).onConfirmPermission;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
