import 'package:equations/equations.dart';

/// Concrete implementation of [Algebraic] that represents a first degree
/// polynomial equation in the form _ax + b = 0_.
///
/// This equation has exactly 1 solution, which can be real or complex.
class Linear extends Algebraic {
  /// The first coefficient of the equation in the form _f(x) = ab + b_
  final Complex a;

  /// The second coefficient of the equation in the form _f(x) = ab + b_
  final Complex b;

  /// This is an example of a linear equation, where the coefficient with the
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
  Linear({
    this.a = const Complex.fromReal(1),
    this.b = const Complex.zero(),
  }) : super([a, b]);

  @override
  int get degree => 1;

  @override
  Algebraic derivative() => Constant(a: a);

  @override
  Complex discriminant() => const Complex.fromReal(1);

  @override
  List<Complex> solutions() => [b.negate / a];
}
