part of '../algebraic.dart';

/// Concrete implementation of [Algebraic] that represents a constant value
/// `a`. It can be either real or complex.
///
/// For example:
///
///   - f(x) = 5
///   - f(x) = 3 + 6i
///
/// In the context of a polynomial with one variable, the non-zero constant
/// function is a polynomial of degree 0.
final class Constant extends Algebraic {
  /// The only coefficient of the polynomial is represented by a [Complex]
  /// number [a].
  Constant({
    Complex a = const Complex.fromReal(1),
  }) : super([a]);

  /// The only coefficient of the polynomial is represented by a [double]
  /// (real) number [a].
  Constant.realEquation({
    double a = 1,
  }) : super.realEquation([a]);

  @override
  num get degree => a.isZero ? double.negativeInfinity : 0;

  @override
  Algebraic derivative() => Constant(a: const Complex.zero());

  @override
  Complex discriminant() => const Complex(double.nan, double.nan);

  @override
  List<Complex> solutions() => const [];

  /// The constant coefficient.
  Complex get a => coefficients.first;

  /// {@template algebraic_deep_copy}
  /// Creates a **deep** copy of this object and replaces (if non-null) the
  /// given values with the old ones.
  /// {@endtemplate}
  Constant copyWith({Complex? a}) => Constant(a: a ?? this.a);
}
