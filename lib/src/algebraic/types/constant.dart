import 'package:equations/equations.dart';

/// Concrete implementation of [Algebraic] which represents a constant value `a`.
/// It can be real or complex.
///
/// **Examples**:
///
///   - f(x) = 5
///   - f(x) = 3 + 6i
///
/// In the context of a polynomial with one variable, the non-zero constant
/// function is a polynomial of degree 0.
class Constant extends Algebraic {
  /// The only coefficient of the polynomial is represented by a [Complex]
  /// number [a].
  Constant({Complex a = const Complex.fromReal(1)}) : super([a]);

  /// The only coefficient of the polynomial is represented by a [double]
  /// (real) number [a].
  Constant.realEquation({double a = 1}) : super.realEquation([a]);

  @override
  num get degree => a.isZero ? double.negativeInfinity : 0;

  @override
  Algebraic derivative() => Constant(a: const Complex.zero());

  @override
  Complex discriminant() => const Complex(double.nan, double.nan);

  @override
  List<Complex> solutions() => [];

  /// The constant coefficient.
  Complex get a => coefficients.first;

  /// Creates a **deep** copy of this object with the given fields replaced
  /// with the new values.
  Constant copyWith({Complex? a}) => Constant(a: a ?? this.a);
}
