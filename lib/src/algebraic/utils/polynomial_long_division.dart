import 'package:equations/equations.dart';

/// The "Polynomial long division" algorithm divides a polynomial by another
/// polynomial of the same or lower degree.
///
/// The only constraint of this procedure is that the degree of the denominator
/// cannot exceed the degree of the numerator. If this condition is not
/// satisfied, an exception will be thrown.
class PolynomialLongDivision {
  /// The numerator.
  final Algebraic polyNumerator;

  /// The denominator.
  final Algebraic polyDenominator;

  /// Creates a [PolynomialLongDivision] instance.
  const PolynomialLongDivision({
    required this.polyNumerator,
    required this.polyDenominator,
  });

  /// Divides [polyNumerator] by [polyDenominator] and wraps quotient and
  /// remainder in the [AlgebraicDivision] class.
  ///
  /// An exception of type [PolynomialLongDivisionException] is thrown if the
  /// degree of the denominator cannot exceed the degree of the numerator.
  AlgebraicDivision divide() {
    if (polyNumerator.degree < polyDenominator.degree) {
      throw const PolynomialLongDivisionException(
        'The denominator degree cannot exceed the numerator degree.',
      );
    }

    // If both are equals, just return 1 with a remainder of 0
    if (polyNumerator == polyDenominator) {
      return AlgebraicDivision(
        quotient: Constant(),
        remainder: Constant(
          a: const Complex.zero(),
        ),
      );
    }

    // If both are constant values, just do a regular 'double' division.
    if (polyNumerator is Constant && polyDenominator is Constant) {
      return AlgebraicDivision(
        quotient: Constant(
          a: polyNumerator[0] / polyDenominator[0],
        ),
        remainder: Constant(
          a: const Complex.zero(),
        ),
      );
    }

    // Polynomial long division algorithm starts here!
    final numerator = polyNumerator.coefficients.reversed.toList(
      growable: false,
    );
    final denominator = polyDenominator.coefficients.reversed.toList(
      growable: false,
    );

    var numDegree = polyNumerator.degree as int;
    final denomDegree = polyDenominator.degree as int;

    // Support list.
    var tempDen = List<Complex>.generate(
      numDegree + 1,
      (_) => const Complex.zero(),
      growable: false,
    );

    // The results (quotient and remainder).
    final quotient = List<Complex>.generate(
      numDegree - denomDegree + 1,
      (_) => const Complex.zero(),
      growable: false,
    );

    // Polynomial long division algorithm that produces.
    if (numDegree >= denomDegree) {
      while (numDegree >= denomDegree) {
        tempDen = List<Complex>.generate(
          tempDen.length,
          (_) => const Complex.zero(),
          growable: false,
        );

        for (var i = 0; i <= denomDegree; i++) {
          tempDen[i + numDegree - denomDegree] = denominator[i];
        }

        quotient[numDegree - denomDegree] =
            numerator[numDegree] / tempDen[numDegree];

        for (var i = 0; i < numDegree - denomDegree + 1; i++) {
          tempDen[i] = tempDen[i] * quotient[numDegree - denomDegree];
        }

        for (var i = 0; i < numDegree + 1; i++) {
          numerator[i] = numerator[i] - tempDen[i];
        }

        numDegree--;
      }
    }

    // Creating the remainder array.
    final remainder = <Complex>[];

    // Skipping leading zeroes which will raise an exception when reversing the
    // contents of the list.
    for (var i = 0; i <= numDegree; i++) {
      if (numerator[i] == const Complex.zero()) {
        continue;
      }

      remainder.add(numerator[i]);
    }

    // Returning the results.
    return AlgebraicDivision(
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
  int get hashCode {
    var result = 2011;

    result = result * 37 + polyNumerator.hashCode;

    return result * 37 + polyDenominator.hashCode;
  }

  @override
  String toString() {
    final num = '$polyNumerator'.replaceAll('f(x) = ', '');
    final den = '$polyDenominator'.replaceAll('f(x) = ', '');

    return '($num) / ($den)';
  }
}
