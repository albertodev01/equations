import 'package:equations/equations.dart';

/// {@template polynomial_long_division}
/// Implements the polynomial long division algorithm, which divides one
/// polynomial by another polynomial.
///
/// This implementation requires that the degree of the denominator be less than
/// or equal to the degree of the numerator. If this condition is not met, a
/// [PolynomialLongDivisionException] will be thrown.
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
  /// of the division.
  ///
  /// Throws a [PolynomialLongDivisionException] if the degree of
  /// [polyDenominator] is greater than the degree of [polyNumerator].
  ///
  /// Special cases:
  /// - If both polynomials are equal, returns a quotient of 1 and remainder of
  ///   0.
  /// - If both polynomials are constants, performs regular division
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
  AlgebraicDivision _handleEqualPolynomials() => (
    quotient: Constant(),
    remainder: Constant(a: const Complex.zero()),
  );

  /// Handles division of constant polynomials.
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

    // Perform the division
    while (numDegree >= denomDegree) {
      // Clear tempDen efficiently
      for (var i = 0; i < tempDen.length; i++) {
        tempDen[i] = const Complex.zero();
      }

      // Set up the temporary denominator
      for (var i = 0; i <= denomDegree; i++) {
        tempDen[i + numDegree - denomDegree] = denominator[i];
      }

      // Calculate the quotient coefficient
      quotient[numDegree - denomDegree] =
          numerator[numDegree] / tempDen[numDegree];

      // Update the temporary denominator
      for (var i = 0; i < numDegree - denomDegree + 1; i++) {
        tempDen[i] = tempDen[i] * quotient[numDegree - denomDegree];
      }

      // Subtract from numerator
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

    // If all coefficients were zero, add a single zero
    if (remainder.isEmpty) {
      remainder.add(const Complex.zero());
    }

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
