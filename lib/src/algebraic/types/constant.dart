part of '../algebraic.dart';

/// {@template constant_algebraic}
/// Concrete implementation of [Algebraic] that represents a constant value `a`.
/// It can be either a real or a complex number, such as:
///
///   - f(x) = 5
///   - f(x) = 3 + 6i
///
/// In the context of a polynomial with one variable, a non-zero constant
/// function is a polynomial of degree 0. By convention, the zero polynomial
/// has degree negative infinity.
/// {@endtemplate}
final class Constant extends Algebraic {
  /// {@macro constant_algebraic}
  ///
  /// The only coefficient of the polynomial is represented by [a].
  new({Complex a = const Complex.fromReal(1)}) : super([a]);

  /// {@macro constant_algebraic}
  ///
  /// The only real coefficient of the polynomial is represented by [a].
  new realEquation({double a = 1}) : super.realEquation([a]);

  @override
  num get degree => a.isZero ? double.negativeInfinity : 0;

  @override
  Algebraic derivative() => Constant(a: const Complex.zero());

  @override
  Complex discriminant() => const Complex(double.nan, double.nan);

  /// A non-zero constant has no roots, so this method returns an empty list.
  ///
  /// The zero polynomial is satisfied by every value of `x`, so its roots
  /// cannot be listed. An empty list is returned in this case as well.
  @override
  List<Complex> solutions() => const [];

  /// The constant coefficient.
  Complex get a => coefficients.first;

  /// {@template algebraic_deep_copy}
  /// Creates a **deep** copy of this object, replacing the old values with the
  /// given ones (when non-null).
  /// {@endtemplate}
  Constant copyWith({Complex? a}) => Constant(a: a ?? this.a);
}
