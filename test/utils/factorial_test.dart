import 'package:equations/src/utils/factorial.dart';
import 'package:test/test.dart';

void main() {
  late final Factorial factorial;

  final values = <int, int>{
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

  final bigIntValues = <int, BigInt>{
    0: BigInt.one,
    1: BigInt.one,
    2: BigInt.two,
    3: BigInt.from(6),
    4: BigInt.from(24),
    5: BigInt.from(120),
    6: BigInt.from(720),
    7: BigInt.from(5040),
    8: BigInt.from(40320),
    9: BigInt.from(362880),
    10: BigInt.from(3628800),
    11: BigInt.from(39916800),
    12: BigInt.from(479001600),
    13: BigInt.from(6227020800),
    14: BigInt.from(87178291200),
    15: BigInt.from(1307674368000),
    16: BigInt.from(20922789888000),
    17: BigInt.from(355687428096000),
    18: BigInt.from(6402373705728000),
    19: BigInt.from(121645100408832000),
    20: BigInt.from(2432902008176640000),
    21: BigInt.parse('51090942171709440000'),
    22: BigInt.parse('1124000727777607680000'),
    23: BigInt.parse('25852016738884976640000'),
    24: BigInt.parse('620448401733239439360000'),
    25: BigInt.parse('15511210043330985984000000'),
    26: BigInt.parse('403291461126605635584000000'),
    27: BigInt.parse('10888869450418352160768000000'),
    28: BigInt.parse('304888344611713860501504000000'),
    29: BigInt.parse('8841761993739701954543616000000'),
    30: BigInt.parse('265252859812191058636308480000000'),
  };

  setUpAll(() {
    factorial = const Factorial();
  });

  group('Factorial', () {
    test('compute()', () {
      for (final entry in values.entries) {
        expect(factorial.compute(entry.key), equals(entry.value));
      }
    });

    test('computeBigInt()', () {
      for (final entry in bigIntValues.entries) {
        expect(factorial.computeBigInt(entry.key), equals(entry.value));
      }
    });

    test(
      'compute() with value bigger than 21 but the result is not exact',
      () {
        final value = factorial.compute(21);
        expect(
          value.toStringAsExponential(),
          equals('-4.249290049419215e+18'),
        );

        // Check that the value is cached
        final value2 = factorial.compute(21);
        expect(
          value2.toStringAsExponential(),
          equals('-4.249290049419215e+18'),
        );
      },
    );

    test(
      'computeBigInt() with value bigger than 31',
      () {
        final value = factorial.computeBigInt(31);
        expect(
          value.toString(),
          equals('8222838654177922817725562880000000'),
        );

        // Check that the value is cached
        final value2 = factorial.computeBigInt(31);
        expect(
          value2.toString(),
          equals('8222838654177922817725562880000000'),
        );
      },
    );

    test(
      'compute() and computeBigInt() return the same values',
      () {
        final bigEntries = bigIntValues.entries.toList();
        final entries = values.entries.toList();

        for (var i = 0; i < entries.length; ++i) {
          expect(entries[i].key, equals(bigEntries[i].key));
          expect(entries[i].value, equals(bigEntries[i].value.toInt()));
        }
      },
    );

    test(
      'compute() with dynamic cache',
      () {
        final value1 = factorial.compute(25);
        expect(value1, isNotNull);

        final value2 = factorial.compute(25);
        expect(value2, equals(value1));

        final value3 = factorial.compute(26);
        expect(value3, isNotNull);
        expect(value3, equals(value1 * 26));
      },
    );

    test(
      'computeBigInt() with dynamic cache',
      () {
        final value1 = factorial.computeBigInt(31);
        expect(value1, isNotNull);

        final value2 = factorial.computeBigInt(31);
        expect(value2, equals(value1));

        final value3 = factorial.computeBigInt(32);
        expect(value3, isNotNull);
        expect(value3, equals(value1 * BigInt.from(32)));
      },
    );
  });
}
