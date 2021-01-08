import 'dart:math' as math;
import 'package:collection/collection.dart';
import 'package:equations/equations.dart';

/// A Sylvester matrix is used to compute the discriminant of a polynomial
/// starting from its coefficients.
class SylvesterMatrix {
  /// Internally stores the coefficients of the polynomial
  final List<Complex> _coefficients;

  /// The coefficients of the polynomial from which the Sylvester matrix will
  /// be built. The list is unmodifiable.
  List<Complex> get coefficients => _coefficients;

  /// The constructor requires complex [coefficients] for the polynomial P(x).
  SylvesterMatrix({required List<Complex> coefficients})
      : _coefficients = UnmodifiableListView(coefficients);

  /// The constructor requires real [coefficients] for the polynomial P(x).
  SylvesterMatrix.fromReal({required List<double> coefficients})
      : _coefficients = UnmodifiableListView(
            coefficients.map((c) => Complex.fromReal(c)).toList());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is SylvesterMatrix) {
      // The lengths of the coefficients must match
      if (_coefficients.length != other._coefficients.length) {
        return false;
      }

      // Each successful comparison increases a counter by 1. If all elements are
      // equal, then the counter will match the actual length of the coefficients
      // list.
      var equalsCount = 0;

      for (var i = 0; i < _coefficients.length; ++i) {
        if (_coefficients[i] == other._coefficients[i]) {
          ++equalsCount;
        }
      }

      // They must have the same runtime type AND all items must be equal.
      return runtimeType == other.runtimeType &&
          equalsCount == _coefficients.length;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = 17;

    // Like we did in operator== iterating over all elements ensures that the
    // hashCode is properly calculated.
    for (var i = 0; i < _coefficients.length; ++i) {
      result = 37 * result + _coefficients[i].hashCode;
    }

    return result;
  }

  /// Computes the determinant of the Sylvester matrix.
  Complex matrixDeterminant() {
    // Computing the derivative of the polynomial and the size of the matrix
    final derivative = Algebraic.from(_coefficients).derivative().coefficients;
    final size = (_coefficients.length - 1) + (derivative.length - 1);
    var pos = 0;

    // Building the matrix with FIXED length lists (optimization)
    final data = List<List<Complex>>.generate(
        size,
        (index) => List<Complex>.generate(size, (_) => Complex.zero(),
            growable: false),
        growable: false);

    // Iterating over the coefficients and placing them in the matrix
    for (var i = 0; i < size - _coefficients.length + 1; ++i) {
      for (var j = 0; j < _coefficients.length; ++j) {
        data[i][j + i] = _coefficients[j];
      }
    }
    for (var i = size - _coefficients.length + 1; i < size; ++i) {
      for (var j = 0; j < derivative.length; ++j) {
        data[i][j + pos] = derivative[j];
      }
      ++pos;
    }

    // Computing the determinant of the Sylvester matrix
    return ComplexMatrix.fromData(
      rows: size,
      columns: size,
      data: data,
    ).determinant();
  }

  /// The discriminant of a polynomial P(x) is the determinant of the Sylvester
  /// matrix of P and P' (where P' is the derivative of P).
  ///
  /// By default, the [optimize] parameter is set to `true` so that the Sylvester
  /// matrix is not computed for polynomials whose degree is 4 or lower. To be
  /// more precise:
  ///
  ///  - With `optimize = true`, if the degree of the polynomial is lower than
  ///  4 then the Sylvester matrix is not built. The computation of its determinant
  ///  can be computationally heavy so we can just avoid such complexity by
  ///  using the simple formulas for lower degree polynomials.
  ///
  /// - With `optimize = true`, the Sylvester matrix and its determinant are
  /// always computed regardless the degree of the polynomial.
  ///
  /// You should
  /// keep the default value of [optimize].
  Complex polynomialDiscriminant({bool optimize = true}) {
    // In case the optimization flag were 'true' and the degree of the
    // polynomial is <= 4, then go for the easy way.
    if (optimize && (_coefficients.length <= 5)) {
      return Algebraic.from(coefficients).discriminant();
    } else {
      // The determinant of the Sylvester matrix
      final determinant = matrixDeterminant();

      /*
      * Once we got the determinant, we need to make the last calculation to also
      * determine the sign. The formula is the following:
      *
      *  Disc(A) = (-1)^(n*(n-1)/2) * 1/A[n] * Res(A, A')
      *
      * In the above formula, 'n' is the degree of the polynomial, A(x) is the
      * polynomial and A'(x) is the derivative of A(x).
      *
      * Res(A, A') is the resultant of A(x) and A'(x), which is nothing more than
      * the determinant of the Sylvester matrix.
      */
      final degree = _coefficients.length - 1;
      final sign = math.pow(-1, degree * (degree - 1) / 2) as double;
      final denominator = _coefficients[0];

      // Returning the determinant with the correct sign
      return Complex.fromReal(sign) / denominator * determinant;
    }
  }
}
