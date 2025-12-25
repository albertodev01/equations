import 'package:equations/equations.dart';

/// {@template polynomial_long_division}
/// Implements the polynomial long division algorithm, which divides one
/// polynomial by another polynomial.
///
/// This implementation requires that the degree of the denominator be less than
/// or equal to the degree of the numerator. If this condition is not met, a
/// [PolynomialLongDivisionException] will be thrown.
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
  /// The polynomial to be divided (numerator).
  final Algebraic polyNumerator;

  /// The polynomial to divide by (denominator).
  final Algebraic polyDenominator;

  /// {@macro polynomial_long_division}
  const PolynomialLongDivision({
    required this.polyNumerator,
    required this.polyDenominator,
  });

  /// Performs polynomial long division of [polyNumerator] by [polyDenominator].
  ///
  /// Returns an [AlgebraicDivision] containing both the quotient and remainder
  /// of the division. The remainder will always have a degree less than the
  /// denominator polynomial.
  ///
  /// Throws a [PolynomialLongDivisionException] if the degree of
  /// [polyDenominator] is greater than the degree of [polyNumerator].
  ///
  /// ## Special Cases
  /// - If both polynomials are equal, returns a quotient 1 and remainder 0
  /// - If both polynomials are constants, performs regular division
  /// - If the denominator is zero, throws a division by zero exception
  ///
  /// ## Example
  /// ```dart
  /// final division = PolynomialLongDivision(
  ///   polyNumerator: Algebraic.fromReal([3, -5, 10, -3]),  // 3x³ - 5x² + 10x - 3
  ///   polyDenominator: Algebraic.fromReal([3, 1]),          // 3x + 1
  /// );
  /// final result = division.divide();
  /// // result.quotient = x² - 2x + 4
  /// // result.remainder = -7
  /// ```
  AlgebraicDivision divide() {
    if (polyNumerator.degree < polyDenominator.degree) {
      throw const PolynomialLongDivisionException(
        'The denominator degree cannot exceed the numerator degree.',
      );
    }

    // Handle special cases
    if (polyNumerator == polyDenominator) {
      return _handleEqualPolynomials();
    }

    if (polyNumerator is Constant && polyDenominator is Constant) {
      return _handleConstantDivision();
    }

    return _performLongDivision();
  }

  /// Handles the case where both polynomials are equal.
  ///
  /// When dividing a polynomial by itself, the result is always:
  /// - quotient = 1 (constant polynomial with value 1)
  /// - remainder = 0 (zero polynomial)
  AlgebraicDivision _handleEqualPolynomials() => (
    quotient: Constant(),
    remainder: Constant(a: const Complex.zero()),
  );

  /// Handles division of constant polynomials (degree 0).
  ///
  /// This is equivalent to regular division of complex numbers.
  /// Throws a [PolynomialLongDivisionException] if attempting to divide by 0.
  AlgebraicDivision _handleConstantDivision() {
    final denominator = (polyDenominator as Constant).a;
    if (denominator == const Complex.zero()) {
      throw const PolynomialLongDivisionException(
        'Division by zero is not allowed.',
      );
    }

    return (
      quotient: Constant(a: (polyNumerator as Constant).a / denominator),
      remainder: Constant(a: const Complex.zero()),
    );
  }

  /// Performs the actual polynomial long division algorithm.
  ///
  /// This method implements the standard polynomial long division algorithm:
  /// 1. Reverse coefficient arrays (highest degree first)
  /// 2. Iteratively divide leading terms and subtract multiples of the den.
  /// 3. Continue until the remainder has degree less than the denominator
  /// 4. Clean up the remainder by removing leading zeros
  ///
  /// The algorithm uses pre-allocated lists for better performance and
  /// avoids creating unnecessary intermediate objects.
  AlgebraicDivision _performLongDivision() {
    final numerator = polyNumerator.coefficients.reversed.toList(
      growable: false,
    );
    final denominator = polyDenominator.coefficients.reversed.toList(
      growable: false,
    );

    var numDegree = polyNumerator.degree as int;
    final denomDegree = polyDenominator.degree as int;

    // Pre-allocate lists for better performance
    final tempDen = List<Complex>.generate(
      numDegree + 1,
      (_) => const Complex.zero(),
      growable: false,
    );

    final quotient = List<Complex>.generate(
      numDegree - denomDegree + 1,
      (_) => const Complex.zero(),
      growable: false,
    );

    // Perform the division algorithm
    while (numDegree >= denomDegree) {
      // Clear tempDen efficiently for reuse
      for (var i = 0; i < tempDen.length; i++) {
        tempDen[i] = const Complex.zero();
      }

      // Set up the temporary denominator aligned with current position
      for (var i = 0; i <= denomDegree; i++) {
        tempDen[i + numDegree - denomDegree] = denominator[i];
      }

      // Calculate the quotient coefficient for current degree
      quotient[numDegree - denomDegree] =
          numerator[numDegree] / tempDen[numDegree];

      // Scale the temporary denominator by the quotient coefficient
      for (var i = 0; i < numDegree - denomDegree + 1; i++) {
        tempDen[i] = tempDen[i] * quotient[numDegree - denomDegree];
      }

      // Subtract the scaled denominator from the numerator
      for (var i = 0; i < numDegree + 1; i++) {
        numerator[i] = numerator[i] - tempDen[i];
      }

      numDegree--;
    }

    // Process the remainder, skipping leading zeros
    final remainder = <Complex>[];
    var foundNonZero = false;

    for (var i = 0; i <= numDegree; i++) {
      if (!foundNonZero && numerator[i] == const Complex.zero()) {
        continue;
      }
      foundNonZero = true;
      remainder.add(numerator[i]);
    }

    // If all coefficients were zero, add a single zero to represent zero
    // polynomial
    if (remainder.isEmpty) {
      remainder.add(const Complex.zero());
    }

    // Convert back to normal coefficient order (lowest degree first)
    return (
      quotient: Algebraic.from(quotient.reversed.toList()),
      remainder: Algebraic.from(remainder.reversed.toList()),
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
