/// This class efficiently computes the factorial of a number using a cache.
///
/// The factorial of a non-negative integer `n`, denoted by `n!`, is the product
/// of all positive integers less than or equal to `n`. For example:
///
///  - 5! = 5 * 4 * 3 * 2 * 1 = 120
///
/// If you want to compute the factorial of large values with more precision,
/// consider
final class Factorial {
  /// A cache with the most common factorial values.
  static const _factorialsCache = <int, int>{
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

  /// A cache with the most common big int factorial values.
  static final _bigIntfactorialsCache = <int, BigInt>{
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

  /// Creates a [Factorial] object.
  const Factorial();

  /// Efficiently computes the factorial of a number with [int] precision.
  ///
  ///  - When [n] is greater than `20`, consider using [computeBigInt] if you
  ///    want more precision.
  ///
  ///  - When [n] is less than or equal to `20`, this method executes in O(1)
  ///    time.
  int compute(int n) => _factorialsCache[n] ?? n * compute(n - 1);

  /// Efficiently computes the factorial of a number with [BigInt] precision.
  ///
  /// When [n] is less than or equal to `30`, this method executes in O(1) time.
  BigInt computeBigInt(int n) {
    final bigValue = BigInt.from(n);
    return _bigIntfactorialsCache[n] ?? bigValue * computeBigInt(n - 1);
  }
}
