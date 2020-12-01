import 'dart:math' as math;
import 'package:equations/equations.dart';

/// Concrete implementation of [Algebraic] that represents a third degree
/// polynomial equation in the form _ax^3 + bx^2 + cx + d = 0_.
///
/// This equation has exactly 3 solutions which can be:
///
///  - 3 distinct real roots and 0 complex roots
///  - 3 real roots (some of them are equal) and 0 complex roots
///  - 1 real root and 2 complex conjugate roots
///
/// The above cases depend on the value of the discriminant.
class Cubic extends Algebraic {
  /// The first coefficient of the equation in the form
  /// _f(x) = ax^3 + bx^2 + cx + d = 0_
  final Complex a;

  /// The second coefficient of the equation in the form
  /// _f(x) = ax^3 + bx^2 + cx + d = 0_
  final Complex b;

  /// The third coefficient of the equation in the form
  /// _f(x) = ax^3 + bx^2 + cx + d = 0_
  final Complex c;

  /// The fourth coefficient of the equation in the form
  /// _f(x) = ax^3 + bx^2 + cx + d = 0_
  final Complex d;

  /// This is an example of a cubic equation, where the coefficient with the
  /// highest degree goes first:
  ///
  /// ```dart
  /// // f(x) = 2x^3 + x^2 + 5
  /// final eq = Cubic(
  ///   a: Complex.fromReal(2),
  ///   b: Complex.fromReal(1),
  ///   d: Complex.fromReal(5),
  /// );
  ///
  /// // f(x) = x^3 + (-2 + 6i)x
  /// final eq = Cubic(
  ///   a: Complex.fromReal(1),
  ///   c: Complex(-2, 6),
  /// );
  /// ```
  Cubic({
    this.a = const Complex.fromReal(1),
    this.b = const Complex.zero(),
    this.c = const Complex.zero(),
    this.d = const Complex.zero(),
  }) : super([a, b, c, d]);

  @override
  int get degree => 3;

  @override
  Algebraic derivative() =>
      Quadratic(a: a * Complex.fromReal(3), b: b * Complex.fromReal(2), c: c);

  @override
  Complex discriminant() {
    final p1 = c * c * b * b;
    final p2 = d * b * b * b * Complex.fromReal(4);
    final p3 = c * c * c * a * Complex.fromReal(4);
    final p4 = a * b * c * d * Complex.fromReal(18);
    final p5 = d * d * a * a * Complex.fromReal(27);

    return p1 - p2 - p3 + p4 - p5;
  }

  @override
  List<Complex> solutions() {
    final two = Complex.fromReal(2);
    final three = Complex.fromReal(3);
    final sigma = Complex(-1 / 2, 1 / 2 * math.sqrt(3));

    final d0 = b * b - a * c * three;
    final d1 = (b.pow(3) * two) -
        (a * b * c * Complex.fromReal(9)) +
        (a * a * d * Complex.fromReal(27));
    final sqrtD = (discriminant() * a * a * Complex.fromReal(-27)).sqrt();
    final C = ((d1 + sqrtD) / two).nthRoot(3);
    final constTerm = Complex.fromReal(-1) / (a * three);

    return <Complex>[
      constTerm * (b + C + (d0 / C)),
      constTerm * (b + (C * sigma) + (d0 / (C * sigma))),
      constTerm * (b + (C * sigma.pow(2)) + (d0 / (C * sigma.pow(2)))),
    ];
  }
}
