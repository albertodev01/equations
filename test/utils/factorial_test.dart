import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  const factorial = Factorial();

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

  /// Computes n! by multiplying the integers one by one.
  BigInt naiveFactorial(int n) {
    var result = BigInt.one;

    for (var i = 2; i <= n; ++i) {
      result *= BigInt.from(i);
    }

    return result;
  }

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

    test('compute() throws when the result does not fit in an int', () {
      expect(() => factorial.compute(21), throwsRangeError);
      expect(() => factorial.compute(100), throwsRangeError);
    });

    test('compute() and computeBigInt() throw with negative values', () {
      expect(() => factorial.compute(-1), throwsRangeError);
      expect(() => factorial.computeBigInt(-1), throwsRangeError);
      expect(() => factorial.computeBigInt(-50), throwsRangeError);
    });

    test('computeBigInt() with values bigger than 30', () {
      expect(
        factorial.computeBigInt(31).toString(),
        equals('8222838654177922817725562880000000'),
      );
      expect(
        factorial.computeBigInt(100).toString(),
        equals(
          '93326215443944152681699238856266700490715968264381621468592963895217'
          '59999322991560894146397615651828625369792082722375825118521091686400'
          '0000000000000000000000',
        ),
      );
    });

    test('computeBigInt() agrees with the naive product', () {
      // Covers both sides of the precomputed table and ranges that are split
      // into halves several times.
      for (final n in [31, 32, 46, 47, 48, 63, 64, 65, 200, 1000]) {
        expect(
          factorial.computeBigInt(n),
          equals(naiveFactorial(n)),
          reason: 'n = $n',
        );
      }
    });

    test('compute() and computeBigInt() return the same values', () {
      for (final entry in values.entries) {
        expect(
          factorial.computeBigInt(entry.key),
          equals(BigInt.from(entry.value)),
        );
      }
    });
  });
}
