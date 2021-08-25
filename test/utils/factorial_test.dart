import 'package:equations/src/utils/factorial.dart';
import 'package:test/test.dart';

void main() {
  late final Factorial factorial;
  late final Map<int, int> values;

  setUpAll(() {
    factorial = const Factorial();

    values = <int, int>{
      0: 1,
      1: 1,
      2: 2,
      3: 6,
      4: 24,
      5: 120,
      6: 720,
      7: 5040,
      8: 40320,
      9: 362880,
      10: 3628800,
      11: 39916800,
      12: 479001600,
      13: 6227020800,
      14: 87178291200,
      15: 1307674368000,
      16: 20922789888000,
      17: 355687428096000,
      18: 6402373705728000,
      19: 121645100408832000,
      20: 2432902008176640000,
    };
  });

  group("Testing the 'Factorial' class", () {
    test("Making sure that 'compute' works properly", () {
      for (final entry in values.entries) {
        expect(factorial.compute(entry.key), equals(entry.value));
      }
    });

    test(
        "Making sure that 'compute' works with value bigger than 21 but the "
        'result is not exact', () {
      final value = factorial.compute(21);
      expect(
        value.toStringAsExponential(),
        equals('-4.249290049419215e+18'),
      );
    });
  });
}
