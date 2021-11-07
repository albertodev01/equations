import 'package:equations/equations.dart';

/// Concrete implementation of [Algebraic] that represents a first degree
/// polynomial equation in the form _ax + b = 0_.
///
/// This equation has exactly 1 solution, which can be real or complex.
class Linear extends Algebraic {
  /// These are examples of linear equations, where the coefficient with the
  /// highest degree goes first:
  ///
  /// ```dart
  /// // f(x) = 2x + 5
  /// final eq = Linear(
  ///   a: Complex.fromReal(2),
  ///   b: Complex.fromReal(5),
  /// );
  ///
  /// // f(x) = (3 + i)x + 6
  /// final eq = Linear(
  ///   a: Complex(3, 1),
  ///   b: Complex.fromReal(6),
  /// );
  /// ```
  ///
  /// Use this constructor if you have complex coefficients. If no [Complex]
  /// values are required, then consider using [Linear.realEquation()] for a
  /// less verbose syntax.
  Linear({
    Complex a = const Complex.fromReal(1),
    Complex b = const Complex.zero(),
  }) : super([a, b]);

  /// The only coefficient of the polynomial is represented by a [double]
  /// (real) number [a].
  Linear.realEquation({
    double a = 1,
    double b = 0,
  }) : super.realEquation([a, b]);

  @override
  int get degree => 1;

  @override
  Algebraic derivative() => Constant(a: a);

  @override
  Complex discriminant() => const Complex.fromReal(1);

  @override
  List<Complex> solutions() => [b.negate / a];

  /// The first coefficient of the equation in the form _f(x) = ab + b_.
  Complex get a => coefficients.first;

  /// The second coefficient of the equation in the form _f(x) = ab + b_.
  Complex get b => coefficients[1];

  /// Creates a **deep** copy of this object with the given fields replaced
  /// with the new values.
  Linear copyWith({
    Complex? a,
    Complex? b,
  }) =>
      Linear(
        a: a ?? this.a,
        b: b ?? this.b,
      );
}
