/// This class simply computes the factorial of a number and performs some speed
/// optimizations by using a cache.
///
/// The factorial of a non-negative integer `n`, denoted by `n!`, is the product
/// of all positive integers less than or equal to `n`. For example:
///
///  - 5! = 5 * 4 * 3 * 2 * 1 = 120
class Factorial {
  /// The cache of the most common factorial numbers.
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

  /// Creates a [Factorial] instance.
  const Factorial();

  /// Efficiently computes the factorial of a number.
  ///
  /// When [n] is greater than 20, values start to be approximated.
  int compute(int n) {
    // If it's in the cache, return it immediately.
    if (_factorialsCache.containsKey(n)) {
      return _factorialsCache[n]!;
    }

    // Classic recursive factorial calculation.
    return n * compute(n - 1);
  }
}
