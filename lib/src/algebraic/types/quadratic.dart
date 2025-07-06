part of '../algebraic.dart';

/// {@template quadratic_algebraic}
/// Concrete implementation of [Algebraic] that represents a second degree
/// polynomial equation in the form _ax^2 + bx + c = 0_.
///
/// This equation has exactly 2 roots, both real or both complex, depending
/// on the value of the discriminant.
/// {@endtemplate}
///
/// {@template quadratic_algebraic_examples}
/// These are examples of quadratic equations, where the coefficient with the
/// highest degree goes first:
///
/// ```dart
/// // f(x) = x^2 - 6x + 5
/// final eq = Quadratic(
///   a: Complex.fromReal(2),
///   b: Complex.fromReal(-6),
///   c: Complex.fromReal(5),
/// );
///
/// // f(x) = ix^2 - 3
/// final eq = Quadratic(
///   a: Complex.fromImaginary(1),
///   c: Complex.fromReal(-3),
/// );
///
/// // f(x) = x^2 - 6x + 5
/// final eq = Quadratic.realEquation(
///   a: 2,
///   b: -6,
///   c: 5,
/// );
/// ```
/// {@endtemplate}
final class Quadratic extends Algebraic {
  /// {@macro quadratic_algebraic}
  ///
  /// {@macro quadratic_algebraic_examples}
  ///
  /// Use this constructor if you have complex coefficients. If no [Complex]
  /// values are required, consider using [Quadratic.realEquation] for a less
  /// verbose syntax.
  Quadratic({
    Complex a = const Complex.fromReal(1),
    Complex b = const Complex.zero(),
    Complex c = const Complex.zero(),
  }) : super([a, b, c]);

  /// {@macro quadratic_algebraic}
  ///
  /// {@macro quadratic_algebraic_examples}
  ///
  /// If the coefficients of your polynomial contain complex numbers, consider
  /// using the [Quadratic.new] constructor instead.
  Quadratic.realEquation({double a = 1, double b = 0, double c = 0})
    : super.realEquation([a, b, c]);

  @override
  int get degree => 2;

  @override
  Algebraic derivative() => Linear(a: a * const Complex.fromReal(2), b: b);

  @override
  Complex discriminant() {
    const four = Complex.fromReal(4);
    return b * b - four * a * c;
  }

  @override
  List<Complex> solutions() {
    final twoA = const Complex.fromReal(2) * a;

    // For better numerical stability, we use a different approach based on the
    // value of b
    if (b.isZero) {
      // Special case when b = 0 -> x = +/- sqrt(-c/a)
      final sqrtTerm = (-c / a).sqrt();
      return <Complex>[sqrtTerm, -sqrtTerm];
    }

    // Use the more stable form of the quadratic formula:
    //
    // x = (-b/2a) ± sqrt((b/2a)^2 - c/a)
    final halfBOverA = b / twoA;
    final sqrtTerm = (halfBOverA * halfBOverA - c / a).sqrt();
    final root1 = -halfBOverA + sqrtTerm;

    // Use Vieta's formulas to compute the other root more accurately
    final product = c / a;
    final betterRoot2 = product / root1;

    return [root1, betterRoot2];
  }

  /// {@macro algebraic_deep_copy}
  Quadratic copyWith({Complex? a, Complex? b, Complex? c}) =>
      Quadratic(a: a ?? this.a, b: b ?? this.b, c: c ?? this.c);

  /// {@macro first_coefficient_algebraic}
  /// _f(x) = ax^2 + bx + c = 0_
  Complex get a => coefficients.first;

  /// {@macro second_coefficient_algebraic}
  /// _f(x) = ax^2 + bx + c = 0_
  Complex get b => coefficients[1];

  /// {@macro third_coefficient_algebraic}
  /// _f(x) = ax^2 + bx + c = 0_
  Complex get c => coefficients[2];
}
