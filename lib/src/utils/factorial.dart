/// {@template factorial}
/// Computes the factorial of a non-negative integer.
///
/// The factorial of a non-negative integer `n`, denoted by `n!`, is the product
/// of all positive integers less than or equal to `n`, and `0! = 1`. For
/// example:
///
///  - 5! = 5 * 4 * 3 * 2 * 1 = 120
///
/// Use [compute] when `n <= 20`, so that the result fits in an [int], and
/// [computeBigInt] for any `n`.
/// {@endtemplate}
final class Factorial {
  /// {@macro factorial}
  const new();

  /// The factorials from `0!` to `20!`, which is the largest factorial that
  /// fits in a 64-bit [int].
  static const _intFactorials = <int>[
    1,
    1,
    2,
    6,
    24,
    120,
    720,
    5040,
    40320,
    362880,
    3628800,
    39916800,
    479001600,
    6227020800,
    87178291200,
    1307674368000,
    20922789888000,
    355687428096000,
    6402373705728000,
    121645100408832000,
    2432902008176640000,
  ];

  /// The largest `n` whose factorial is precomputed in [_bigIntFactorials].
  static const _maxPrecomputedBigInt = 30;

  /// The factorials from `0!` to `30!`, precomputed so that they're returned
  /// in constant time.
  static final List<BigInt> _bigIntFactorials = () {
    final values = [BigInt.one];
    for (var i = 1; i <= _maxPrecomputedBigInt; ++i) {
      values.add(values.last * BigInt.from(i));
    }
    return List<BigInt>.unmodifiable(values);
  }();

  /// When a range of [_product] has at most this many integers, they're
  /// multiplied one by one instead of splitting the range again.
  static const _productLeafSize = 16;

  /// Returns the product of all integers from [low] to [high], both included.
  /// [low] must be less than or equal to [high].
  ///
  /// The range is split in two halves whose products are multiplied together.
  /// This way, the two factors of each multiplication have similar sizes,
  /// which is much faster than multiplying a huge number by a small integer
  /// `high - low` times.
  static BigInt _product(int low, int high) {
    if (high - low < _productLeafSize) {
      var result = BigInt.from(low);
      for (var i = low + 1; i <= high; ++i) {
        result *= BigInt.from(i);
      }
      return result;
    }
    final middle = low + (high - low) ~/ 2;
    return _product(low, middle) * _product(middle + 1, high);
  }

  /// Computes the factorial of [n] with [int] precision, in constant time.
  ///
  /// Throws a [RangeError] if [n] is negative or greater than `20`, because
  /// `21!` doesn't fit in a 64-bit [int]. Use [computeBigInt] for larger
  /// values.
  int compute(int n) {
    RangeError.checkValueInInterval(n, 0, _intFactorials.length - 1, 'n');
    return _intFactorials[n];
  }

  /// Computes the factorial of [n] with [BigInt] precision.
  ///
  /// When [n] is less than or equal to `30`, this method executes in O(1)
  /// time. Larger values are computed by splitting the product into halves,
  /// which is much faster than multiplying the integers one by one when [n]
  /// is large.
  ///
  /// Throws a [RangeError] if [n] is negative.
  BigInt computeBigInt(int n) {
    RangeError.checkNotNegative(n, 'n');
    if (n <= _maxPrecomputedBigInt) {
      return _bigIntFactorials[n];
    }
    return _bigIntFactorials.last * _product(_maxPrecomputedBigInt + 1, n);
  }
}
