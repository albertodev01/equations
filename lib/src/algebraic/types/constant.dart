import 'package:equations/equations.dart';

/// Concrete implementation of [Algebraic] which represents a constant value `a`.
/// It can be real or complex.
///
/// **Examples**:
///
///   - f(x) = 5
///   - f(x) = 3 + 6i
///
/// In the context of a polynomial in one variable, the non-zero constant
/// function is a polynomial of degree 0.
class Constant extends Algebraic {
  /// The constant coefficient
  final Complex a;

  /// The only coefficient of the polynomial is represented by a [Complex]
  /// number [a].
  Constant({this.a = const Complex.fromReal(1)}) : super([a]);

  /// The only coefficient of the polynomial is represented by a [double]
  /// (real) number [a].
  Constant.realEquation({double a = 1})
      : a = Complex.fromReal(a),
        super.realEquation([a]);

  @override
  num get degree => a.isZero ? double.negativeInfinity : 0;

  @override
  Algebraic derivative() => Constant(a: Complex.zero());

  @override
  Complex discriminant() => Complex(double.nan, double.nan);

  @override
  List<Complex> solutions() => [];
}
