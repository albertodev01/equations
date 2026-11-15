import 'package:equations/equations.dart';

/// {@template sylvester_matrix}
/// The Sylvester matrix is used to compute the discriminant of a polynomial of
/// any degree.
/// {@endtemplate}
final class SylvesterMatrix {
  /// {@macro sylvester_matrix}
  const new({
    required this.polynomial,
  });

  /// The polynomial used to build the Sylvester matrix.
  final Algebraic polynomial;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is SylvesterMatrix && polynomial == other.polynomial;
  }

  @override
  int get hashCode => polynomial.hashCode;

  /// Builds the Sylvester matrix of the polynomial `P` and its derivative `P'`.
  ///
  /// When `P` has degree `n`, the matrix is `(2n - 1) x (2n - 1)`. The first
  /// `n - 1` rows contain the coefficients of `P` and the last `n` rows contain
  /// the coefficients of `P'`. Each row is shifted one column to the right
  /// with respect to the previous one of the same kind.
  ComplexMatrix buildMatrix() {
    final coefficients = polynomial.coefficients;

    if (coefficients.length <= 1) {
      throw const MatrixException(
        'Cannot build Sylvester matrix for a constant polynomial',
      );
    }

    final derivative = polynomial.derivative().coefficients;
    final degree = coefficients.length - 1;
    final size = 2 * degree - 1;
    final data = List<Complex>.filled(size * size, const Complex.zero());

    // The 'n - 1' rows with the coefficients of P.
    for (var row = 0; row < degree - 1; ++row) {
      for (var j = 0; j < coefficients.length; ++j) {
        data[size * row + row + j] = coefficients[j];
      }
    }

    // The 'n' rows with the coefficients of P'.
    for (var shift = 0; shift < degree; ++shift) {
      final row = degree - 1 + shift;
      for (var j = 0; j < derivative.length; ++j) {
        data[size * row + shift + j] = derivative[j];
      }
    }

    return ComplexMatrix.fromFlattenedData(
      rows: size,
      columns: size,
      data: data,
    );
  }

  /// Computes the determinant of the Sylvester matrix.
  Complex matrixDeterminant() => buildMatrix().determinant();

  /// The discriminant of a polynomial P(x) is the determinant of the Sylvester
  /// matrix of P and P' (where P' is the derivative of P).
  ///
  /// Polynomials of degree 4 or lower use their closed-form discriminant.
  Complex polynomialDiscriminant() {
    final coefficients = polynomial.coefficients;

    // Closed-form formulas exist up to degree 4. Going through 'Algebraic.from'
    // guarantees that a low degree 'GenericAlgebraic' (whose discriminant is
    // computed by this class) does not recurse back here.
    if (coefficients.length <= 5) {
      return Algebraic.from(coefficients).discriminant();
    }

    /*
     * The discriminant is computed from the resultant of P and P', which is
     * the determinant of the Sylvester matrix:
     *
     *  Disc(P) = (-1)^(n*(n-1)/2) * 1/a_n * Res(P, P')
     *
     * where 'n' is the degree of P and 'a_n' its leading coefficient. Since
     * n*(n-1) is always even, the sign only depends on the parity of the
     * integer n*(n-1)/2.
     */
    final degree = coefficients.length - 1;
    final sign = (degree * (degree - 1) ~/ 2).isEven ? 1.0 : -1.0;

    return Complex.fromReal(sign) / coefficients.first * matrixDeterminant();
  }
}
