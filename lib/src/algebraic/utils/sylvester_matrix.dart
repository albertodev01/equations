import 'dart:math' as math;

import 'package:equations/equations.dart';

/// {@template sylvester_matrix}
/// The Sylvester matrix is used to compute the discriminant of a polynomial
/// of any degree.
/// {@endtemplate}
class SylvesterMatrix {
  /// The polynomial used to build the Sylvester matrix.
  final Algebraic polynomial;

  /// {@macro sylvester_matrix}
  const SylvesterMatrix({required this.polynomial});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is SylvesterMatrix) {
      return runtimeType == other.runtimeType && polynomial == other.polynomial;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => polynomial.hashCode;

  /// Builds the Sylvester matrix associated to the given polynomial.
  ComplexMatrix buildMatrix() {
    // Computing the derivative of the polynomial and the size of the matrix
    final coefficients = polynomial.coefficients;

    // Handle constant polynomial case
    if (coefficients.length <= 1) {
      throw const MatrixException(
        'Cannot build Sylvester matrix for a constant polynomial',
      );
    }

    final derivative = polynomial.derivative().coefficients;
    final size = (coefficients.length - 1) + (derivative.length - 1);

    // Building the matrix with FIXED length lists (optimization)
    final flatData = List<Complex>.generate(
      size * size,
      (_) => const Complex.zero(),
      growable: false,
    );

    // Pre-calculate positions for better performance
    final coeffLength = coefficients.length;
    final derivLength = derivative.length;

    // Place polynomial coefficients
    for (var i = 0; i < size - coeffLength + 1; ++i) {
      for (var j = 0; j < coeffLength; ++j) {
        final value = coefficients[j];
        // Skip near-zero coefficients for numerical stability
        if (value.abs() > 1e-10) {
          flatData[size * i + (j + i)] = value;
        }
      }
    }

    // Place derivative coefficients
    var pos = 0;
    for (var i = size - coeffLength + 1; i < size; ++i) {
      for (var j = 0; j < derivLength; ++j) {
        final value = derivative[j];
        // Skip near-zero coefficients for numerical stability
        if (value.abs() > 1e-10) {
          flatData[size * i + (j + pos)] = value;
        }
      }
      ++pos;
    }

    // Returning the Sylvester matrix.
    return ComplexMatrix.fromFlattenedData(
      rows: size,
      columns: size,
      data: flatData,
    );
  }

  /// Computes the determinant of the Sylvester matrix.
  Complex matrixDeterminant() => buildMatrix().determinant();

  /// The discriminant of a polynomial P(x) is the determinant of the Sylvester
  /// matrix of P and P' (where P' is the derivative of P).
  Complex polynomialDiscriminant() {
    final quarticOrLower =
        polynomial is Constant ||
        polynomial is Linear ||
        polynomial is Quadratic ||
        polynomial is Cubic ||
        polynomial is Quartic;

    if (quarticOrLower) {
      return polynomial.discriminant();
    } else {
      // The determinant of the Sylvester matrix
      final determinant = matrixDeterminant();

      /*
      * Once we got the determinant, we need to make the last calculation to
      * also determine the sign. The formula is the following:
      *
      *  Disc(A) = (-1)^(n*(n-1)/2) * 1/A[n] * Res(A, A')
      *
      * In the above formula, 'n' is the degree of the polynomial, A(x) is the
      * polynomial and A'(x) is the derivative of A(x).
      *
      * Res(A, A') is the resultant of A(x) and A'(x), which is nothing more
      * than the determinant of the Sylvester matrix.
      */
      final coefficients = polynomial.coefficients;
      final degree = coefficients.length - 1;
      final sign = math.pow(-1, degree * (degree - 1) / 2) as double;
      final denominator = coefficients.first;

      // Check for near-zero denominator
      if (denominator.abs() < 1e-10) {
        throw const MatrixException('Leading coefficient is too close to zero');
      }

      // Returning the determinant with the correct sign
      return Complex.fromReal(sign) / denominator * determinant;
    }
  }
}
