import 'package:equations/equations.dart';

/// {@template polynomial_long_division}
/// Implements the polynomial long division algorithm, which divides one
/// polynomial by another polynomial.
///
/// Given a numerator `N(x)` and a non-zero denominator `D(x)`, the division
/// finds the unique quotient `Q(x)` and remainder `R(x)` such that
/// `N(x) = Q(x) * D(x) + R(x)`, where `R(x)` is the zero polynomial or has a
/// degree lower than the degree of `D(x)`.
///
/// A [PolynomialLongDivisionException] is thrown if the denominator is the
/// zero polynomial.
///
/// ## Algorithm Overview
///
/// The polynomial long division algorithm works similarly to numerical long
/// division:
///
///  1. Divide the leading term of the numerator by the leading term of the
///     denominator
///  2. Multiply the entire denominator by this quotient
///  3. Subtract the result from the numerator
///  4. Repeat until the degree of the remainder is less than the degree of the
///     denominator
///
/// ## Example
/// ```dart
/// final division = PolynomialLongDivision(
///   polyNumerator: Algebraic.fromReal([1, 3, -6]), // P(x) = x^2 + 3x - 6
///   polyDenominator: Algebraic.fromReal([1, 7]),   // Q(x) = x + 7
/// );
///
/// final result = division.divide();
/// // result.quotient = x - 4
/// // result.remainder = 22
/// ```
/// {@endtemplate}
class PolynomialLongDivision {
  /// {@macro polynomial_long_division}
  const new({
    required this.polyNumerator,
    required this.polyDenominator,
  });

  /// The polynomial to be divided (numerator).
  final Algebraic polyNumerator;

  /// The polynomial to divide by (denominator).
  final Algebraic polyDenominator;

  /// Performs polynomial long division of [polyNumerator] by [polyDenominator].
  ///
  /// Returns an [AlgebraicDivision] containing both the quotient and remainder
  /// of the division. The remainder is either the zero polynomial or has a
  /// degree lower than the degree of [polyDenominator].
  ///
  /// Throws a [PolynomialLongDivisionException] if [polyDenominator] is the
  /// zero polynomial.
  ///
  /// ## Special Cases
  /// - If the degree of [polyNumerator] is lower than the degree of
  ///   [polyDenominator] (this includes the zero polynomial as numerator), the
  ///   quotient is 0 and the remainder is [polyNumerator]
  /// - If both polynomials are constants, the quotient is their ratio and the
  ///   remainder is 0
  ///
  /// ## Example
  /// ```dart
  /// final division = PolynomialLongDivision(
  ///   // 3x^3 - 5x^2 + 10x - 3
  ///   polyNumerator: Algebraic.fromReal([3, -5, 10, -3]),
  ///   // 3x + 1
  ///   polyDenominator: Algebraic.fromReal([3, 1]),
  /// );
  /// final result = division.divide();
  /// // result.quotient = x^2 - 2x + 4
  /// // result.remainder = -7
  /// ```
  AlgebraicDivision divide() {
    final numerator = polyNumerator.coefficients;
    final denominator = polyDenominator.coefficients;

    // The leading coefficient of a valid polynomial is zero only for the zero
    // polynomial.
    final denominatorLeading = denominator.first;
    if (denominatorLeading.isZero) {
      throw const PolynomialLongDivisionException(
        'Division by zero is not allowed.',
      );
    }

    // Both lists store the coefficients from the highest degree to the
    // lowest. Counting the zero polynomial as degree 0 here is fine: if the
    // denominator is a constant, the loop below yields a zero quotient and
    // otherwise the early return below handles it.
    final n = numerator.length - 1;
    final m = denominator.length - 1;

    if (n < m) {
      return (
        quotient: Constant(a: const Complex.zero()),
        remainder: Algebraic.from(numerator),
      );
    }

    final remainder = List<Complex>.of(numerator, growable: false);
    final quotient = List<Complex>.filled(n - m + 1, const Complex.zero());

    // At step k, the term of degree n - k is eliminated by subtracting
    // q * x^(n - m - k) * D(x).
    for (var k = 0; k <= n - m; ++k) {
      final q = remainder[k] / denominatorLeading;
      quotient[k] = q;

      for (var i = 0; i <= m; ++i) {
        remainder[k + i] -= q * denominator[i];
      }
    }

    // The remainder is made of the last m coefficients. Remove its leading
    // zeros (the ones with the highest degree) so that it's a valid polynomial.
    final trimmedRemainder = remainder
        .skip(n - m + 1)
        .skipWhile((c) => c.isZero)
        .toList(growable: false);

    return (
      quotient: Algebraic.from(quotient),
      remainder: Algebraic.from(
        trimmedRemainder.isEmpty ? const [Complex.zero()] : trimmedRemainder,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is PolynomialLongDivision) {
      return runtimeType == other.runtimeType &&
          polyNumerator == other.polyNumerator &&
          polyDenominator == other.polyDenominator;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(polyNumerator, polyDenominator);

  @override
  String toString() {
    final num = '$polyNumerator'.replaceAll('f(x) = ', '');
    final den = '$polyDenominator'.replaceAll('f(x) = ', '');

    return '($num) / ($den)';
  }
}
