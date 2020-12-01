import 'package:equations/equations.dart';

import 'cubic.dart';

/// Concrete implementation of [Algebraic] that represents a fourth degree
/// polynomial equation in the form _ax^4 + bx^3 + cx^2 + dx + e = 0_.
///
/// This equation has exactly 4 solutions which can be:
///
///  - 2 distinct real roots and 2 complex conjugate roots
///  - 4 real roots and 0 complex roots
///  - 0 real roots and 4 complex conjugate roots
///  - Multiple roots which can be all equal or paired (complex or real)
///
/// The above cases depend on the value of the discriminant.
class Quartic extends Algebraic {
  /// The first coefficient of the equation in the form
  /// _f(x) = ax^4 + bx^3 + cx^2 + dx + e = 0_
  final Complex a;

  /// The second coefficient of the equation in the form
  /// _f(x) = ax^4 + bx^3 + cx^2 + dx + e = 0_
  final Complex b;

  /// The third coefficient of the equation in the form
  /// _f(x) = ax^4 + bx^3 + cx^2 + dx + e = 0_
  final Complex c;

  /// The fourth coefficient of the equation in the form
  /// _f(x) = ax^4 + bx^3 + cx^2 + dx + e = 0_
  final Complex d;

  /// The fifth coefficient of the equation in the form
  /// _f(x) = ax^4 + bx^3 + cx^2 + dx + e = 0_
  final Complex e;

  /// This is an example of a quartic equation, where the coefficient with the
  /// highest degree goes first:
  ///
  /// ```dart
  /// // f(x) = -x^4 - 8x^3 - 1
  /// final eq = Quartic(
  ///   a: Complex.fromReal(-1),
  ///   b: Complex.fromReal(-8),
  ///   e: Complex.fromReal(-1),
  /// );
  ///
  /// // f(x) = ix^4 - ix^2 + 6
  /// final eq = Quartic(
  ///   a: Complex.fromImaginary(1),
  ///   c: Complex.fromImaginary(-1),
  ///   e: Complex.fromReal(6),
  /// );
  /// ```
  Quartic({
    this.a = const Complex.fromReal(1),
    this.b = const Complex.zero(),
    this.c = const Complex.zero(),
    this.d = const Complex.zero(),
    this.e = const Complex.zero(),
  }) : super([a, b, c, d, e]);

  @override
  int get degree => 4;

  @override
  Algebraic derivative() => Cubic(
      a: a * Complex.fromReal(4),
      b: b * Complex.fromReal(3),
      c: c * Complex.fromReal(2),
      d: d);

  @override
  Complex discriminant() {
    final k = (b * b * c * c * d * d) -
        (d * d * d * b * b * b * Complex.fromReal(4)) -
        (d * d * c * c * c * a * Complex.fromReal(4)) +
        (d * d * d * c * b * a * Complex.fromReal(18)) -
        (d * d * d * d * a * a * Complex.fromReal(27)) +
        (e * e * e * a * a * a * Complex.fromReal(256));

    final p = e *
        ((c * c * c * b * b * Complex.fromReal(-4)) +
            (b * b * b * c * d * Complex.fromReal(18)) +
            (c * c * c * c * a * Complex.fromReal(16)) -
            (d * c * c * b * a * Complex.fromReal(80)) -
            (d * d * b * b * a * Complex.fromReal(6)) +
            (d * d * a * a * c * Complex.fromReal(144)));

    final r = (e * e) *
        (b * b * b * b * Complex.fromReal(-27) +
            b * b * c * a * Complex.fromReal(144) -
            a * a * c * c * Complex.fromReal(128) -
            d * b * a * a * Complex.fromReal(192));

    return k + p + r;
  }

  @override
  List<Complex> solutions() {
    final Fb = b / a;
    final Fc = c / a;
    final Fd = d / a;
    final Fe = e / a;

    final Q1 = (Fc * Fc) -
        (Fb * Fd * Complex.fromReal(3)) +
        (Fe * Complex.fromReal(12));
    final Q2 = (Fc.pow(3) * Complex.fromReal(2)) -
        (Fb * Fc * Fd * Complex.fromReal(9)) +
        (Fd.pow(2) * Complex.fromReal(27)) +
        (Fb.pow(2) * Fe * Complex.fromReal(27)) -
        (Fc * Fe * Complex.fromReal(72));
    final Q3 = (Fb * Fc * Complex.fromReal(8)) -
        (Fd * Complex.fromReal(16)) -
        (Fb.pow(3) * Complex.fromReal(2));
    final Q4 = (Fb.pow(2) * Complex.fromReal(3)) - (Fc * Complex.fromReal(8));

    var temp = (Q2 * Q2 / Complex.fromReal(4)) - (Q1.pow(3));
    final Q5 = (temp.sqrt() + (Q2 / Complex.fromReal(2))).pow(1.0 / 3.0);
    final Q6 = ((Q1 / Q5) + Q5) / Complex.fromReal(3);
    temp = (Q4 / Complex.fromReal(12)) + Q6;
    final Q7 = temp.sqrt() * Complex.fromReal(2);
    temp = ((Q4 * Complex.fromReal(4)) / Complex.fromReal(6)) -
        (Q6 * Complex.fromReal(4)) -
        (Q3 / Q7);

    final solutions = [
      (Fb.negate - Q7 - temp.sqrt()) / Complex.fromReal(4),
      (Fb.negate - Q7 + temp.sqrt()) / Complex.fromReal(4),
    ];

    temp = ((Q4 * Complex.fromReal(4)) / Complex.fromReal(6)) -
        (Q6 * Complex.fromReal(4)) +
        (Q3 / Q7);

    solutions
      ..add((Fb.negate + Q7 - temp.sqrt()) / Complex.fromReal(4))
      ..add((Fb.negate + Q7 + temp.sqrt()) / Complex.fromReal(4));

    return solutions;
  }
}
