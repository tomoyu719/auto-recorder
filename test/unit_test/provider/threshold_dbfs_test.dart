import 'package:auto_recorder/providers/shared_preferences.dart';
import 'package:auto_recorder/providers/threshold/threshold_dbfs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ThresholdDbfs', () {
    late ProviderContainer container;
    late SharedPreferences sharedPreferences;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
      container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences)
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('build should initialize state with default value', () {
      final threshold = container.read(thresholdDbSplProvider);
      expect(threshold, ThresholdDbSpl.initialThresholdDbfs);
    });

    test(
        'onChange should update state with the ceiling value of the given double',
        () {
      container.read(thresholdDbSplProvider.notifier).onChange(45.5);
      expect(container.read(thresholdDbSplProvider), 46);
    });

    test(
        'onChangeEnd should update state and save the value to SharedPreferences',
        () {
      container.read(thresholdDbSplProvider.notifier).onChangeEnd(50.2);
      expect(container.read(thresholdDbSplProvider), 50);

      final savedValue =
          sharedPreferences.getInt(ThresholdDbSpl.thresholdDbfsPrefsKey);
      expect(savedValue, 50);
    });
  });
}
