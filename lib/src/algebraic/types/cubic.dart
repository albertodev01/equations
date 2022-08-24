import 'dart:math' as math;

import 'package:equations/equations.dart';

/// Concrete implementation of [Algebraic] that represents a third degree
/// polynomial equation in the form `ax^3 + bx^2 + cx + d = 0`.
///
/// This equation exactly has 3 solutions:
///
///  - 3 distinct real roots and 0 complex roots
///  - 3 real roots (some of them are equal) and 0 complex roots
///  - 1 real root and 2 complex conjugate roots
///
/// The above cases depend on the value of the discriminant.
class Cubic extends Algebraic {
  /// These are examples of cubic equations, where the coefficient with the
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
  ///
  /// Use this constructor if you have complex coefficients. If no [Complex]
  /// values are required, then consider using [Cubic.realEquation] for a
  /// less verbose syntax.
  Cubic({
    Complex a = const Complex.fromReal(1),
    Complex b = const Complex.zero(),
    Complex c = const Complex.zero(),
    Complex d = const Complex.zero(),
  }) : super([a, b, c, d]);

  /// These are examples of cubic equations, where the coefficient with the
  /// highest degree goes first:
  ///
  /// ```dart
  /// // f(x) = 2x^3 + x^2 + 5
  /// final eq = Cubic.fromReal(
  ///   a: 2,
  ///   b: 1,
  ///   d: 5,
  /// );
  /// ```
  ///
  /// If the coefficients of your polynomial contain complex numbers, consider
  /// using the [Cubic.new] constructor instead.
  Cubic.realEquation({
    double a = 1,
    double b = 0,
    double c = 0,
    double d = 0,
  }) : super.realEquation([a, b, c, d]);

  @override
  int get degree => 3;

  @override
  Algebraic derivative() => Quadratic(
        a: a * const Complex.fromReal(3),
        b: b * const Complex.fromReal(2),
        c: c,
      );

  @override
  Complex discriminant() {
    final p1 = c * c * b * b;
    final p2 = d * b * b * b * const Complex.fromReal(4);
    final p3 = c * c * c * a * const Complex.fromReal(4);
    final p4 = a * b * c * d * const Complex.fromReal(18);
    final p5 = d * d * a * a * const Complex.fromReal(27);

    return p1 - p2 - p3 + p4 - p5;
  }

  @override
  List<Complex> solutions() {
    const two = Complex.fromReal(2);
    const three = Complex.fromReal(3);
    final sigma = Complex(-1 / 2, 1 / 2 * math.sqrt(3));

    final d0 = b * b - a * c * three;
    final d1 = (b.pow(3) * two) -
        (a * b * c * const Complex.fromReal(9)) +
        (a * a * d * const Complex.fromReal(27));
    final sqrtD = (discriminant() * a * a * const Complex.fromReal(-27)).sqrt();
    final C = ((d1 + sqrtD) / two).nthRoot(3);
    final constTerm = const Complex.fromReal(-1) / (a * three);

    return <Complex>[
      constTerm * (b + C + (d0 / C)),
      constTerm * (b + (C * sigma) + (d0 / (C * sigma))),
      constTerm * (b + (C * sigma.pow(2)) + (d0 / (C * sigma.pow(2)))),
    ];
  }

  /// The first coefficient of the equation in the form
  /// _f(x) = ax^3 + bx^2 + cx + d = 0_
  Complex get a => coefficients.first;

  /// The second coefficient of the equation in the form
  /// _f(x) = ax^3 + bx^2 + cx + d = 0_
  Complex get b => coefficients[1];

  /// The third coefficient of the equation in the form
  /// _f(x) = ax^3 + bx^2 + cx + d = 0_
  Complex get c => coefficients[2];

  /// The fourth coefficient of the equation in the form
  /// _f(x) = ax^3 + bx^2 + cx + d = 0_
  Complex get d => coefficients[3];

  /// Creates a **deep** copy of this object with the given fields replaced
  /// with the new values.
  Cubic copyWith({
    Complex? a,
    Complex? b,
    Complex? c,
    Complex? d,
  }) =>
      Cubic(
        a: a ?? this.a,
        b: b ?? this.b,
        c: c ?? this.c,
        d: d ?? this.d,
      );
}
