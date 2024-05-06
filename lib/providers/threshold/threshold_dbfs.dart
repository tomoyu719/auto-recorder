import 'package:auto_recorder/providers/dbfs/dbfs.dart';
import 'package:auto_recorder/providers/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'threshold_dbfs.g.dart';

@Riverpod(keepAlive: true)
class ThresholdDbSpl extends _$ThresholdDbSpl {
  static const thresholdDbfsPrefsKey = 'thresholdDbfsPrefsKey';
  static const initialThresholdDbfs = (minDb + maxDb) ~/ 2;

  @override
  int build() {
    state =
        ref.watch(sharedPreferencesProvider).getInt(thresholdDbfsPrefsKey) ??
            initialThresholdDbfs;
    return state;
  }

  void onChange(double value) => state = value.round();

  void onChangeEnd(double value) {
    state = value.round();
    ref.watch(sharedPreferencesProvider).setInt(thresholdDbfsPrefsKey, state);
  }
}
