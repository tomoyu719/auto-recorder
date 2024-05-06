import 'package:auto_recorder/providers/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'waiting_time.g.dart';

@Riverpod(keepAlive: true)
class WaitingTime extends _$WaitingTime {
  static const waitingTimePrefsKey = 'waitingTime';
  static const initialWaitingTime = 5;
  static const maxWaitTime = 60;
  static const minWaitTime = 5;

  @override
  Duration build() {
    state = Duration(
        seconds:
            ref.watch(sharedPreferencesProvider).getInt(waitingTimePrefsKey) ??
                initialWaitingTime);
    return state;
  }

  void onChange(double value) => state = Duration(seconds: value.round());

  void onChangeEnd(double value) {
    final seconds = value.round();

    state = Duration(seconds: seconds);
    ref.watch(sharedPreferencesProvider).setInt(waitingTimePrefsKey, seconds);
  }
}
