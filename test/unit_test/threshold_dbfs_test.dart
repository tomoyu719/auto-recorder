import 'package:auto_recorder/features/recording/sound_monitor/sound_util.dart';
import 'package:auto_recorder/features/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

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
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('build should initialize state with default value', () {
      final threshold = container.read(thresholdDbfsProvider);
      expect(threshold, ThresholdDbfs.initialThresholdDbfs);
    });

    test('''onChange should update state with the ceiling value of 
    the given double''', () {
      container.read(thresholdDbfsProvider.notifier).onChange(45.5);
      expect(container.read(thresholdDbfsProvider), 46);
    });

    test('''onChangeEnd should update state and save the value to 
       SharedPreferences''', () {
      container.read(thresholdDbfsProvider.notifier).onChangeEnd(50.2);
      expect(container.read(thresholdDbfsProvider), 50);

      final savedValue =
          sharedPreferences.getInt(ThresholdDbfs.thresholdDbfsPrefsKey);
      expect(savedValue, 50);
    });
  });
}
