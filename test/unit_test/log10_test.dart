import 'package:flutter_test/flutter_test.dart';
import 'package:auto_recorder/providers/dbfs/log10.dart';

void main() {
  test('log10 of 10 should be 1', () {
    closeTo(log10(10), 1);
  });

  test('log10 of 100 should be 2', () {
    closeTo(log10(100), 2);
  });

  test('log10 of 1000 should be 3', () {
    closeTo(log10(1000), 3);
  });

  test('log10 of 1 should be 0', () {
    expect(log10(1), equals(0));
  });

  test('log10 of 0 should be negativeInfinity', () {
    expect(log10(0), double.negativeInfinity);
  });
}
