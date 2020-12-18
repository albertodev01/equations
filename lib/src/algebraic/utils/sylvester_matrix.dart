import 'package:collection/collection.dart';
import 'package:equations/equations.dart';

/// A Sylvester matrix is used to compute the discriminant of a polynomial
/// starting from its coefficients. This class builds the Sylvester matrix
/// starting from the coefficients of a polynomial.
class SylvesterMatrix {
  /// Internally stores the coefficients of the polynomial
  final List<Complex> _coefficients;

  /// TODO
  SylvesterMatrix({
    required List<Complex> coefficients
  }) : _coefficients = UnmodifiableListView(coefficients);

  /// TODO
  Complex matrixDeterminant() {
    // The derivative of the polynomial
    final derivative = Algebraic.from(_coefficients).derivative().coefficients;
    final size = (_coefficients.length - 1) + (derivative.length - 1);

    // Building the matrix
    final data = List<List<Complex>>.generate(size,
       (index) => List<Complex>.generate(size, (_) => Complex.zero())
    );

    // Putting polynomials in the matrix
    for (var i = 0; i < size - _coefficients.length + 1; ++i) {
      for(var j = 0; j < _coefficients.length; ++j) {
        data[i][j+i] = _coefficients[j];
      }
    }

    var pos = 0;
    for (var i = size - _coefficients.length + 1; i < size; ++i) {
      for(var j = 0; j < derivative.length; ++j) {
        data[i][j+pos] = derivative[j];
      }
      ++pos;
    }

    return Complex.i();
  }

  /// TODO
  Complex polynomialDiscriminant() {
    final determinant = matrixDeterminant();

    final degree = _coefficients.length - 1;
    final exp = 0.5 * degree * (degree - 1);

    return Complex.fromReal(-1).pow(exp) * Complex.fromReal(1 / degree) * determinant;
  }
}