part of '../algebraic.dart';

/// Concrete implementation of [Algebraic] that represents a second degree
/// polynomial equation in the form _ax^2 + bx + c = 0_.
///
/// This equation has exactly 2 roots, both real or both complex, depending
/// on the value of the discriminant.
final class Quadratic extends Algebraic {
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
  /// ```
  ///
  /// Use this constructor if you have complex coefficients. If no [Complex]
  /// values are required, then consider using [Quadratic.realEquation] for a
  /// less verbose syntax.
  Quadratic({
    Complex a = const Complex.fromReal(1),
    Complex b = const Complex.zero(),
    Complex c = const Complex.zero(),
  }) : super([a, b, c]);

  /// This is an example of a quadratic equation, where the coefficient with the
  /// highest degree goes first:
  ///
  /// ```dart
  /// // f(x) = x^2 - 6x + 5
  /// final eq = Quadratic.realEquation(
  ///   a: 2,
  ///   b: -6,
  ///   c: 5,
  /// );
  /// ```
  ///
  /// If the coefficients of your polynomial contain complex numbers, consider
  /// using the [Quadratic.new] constructor instead.
  Quadratic.realEquation({
    double a = 1,
    double b = 0,
    double c = 0,
  }) : super.realEquation([a, b, c]);

  @override
  int get degree => 2;

  @override
  Algebraic derivative() => Linear(
        a: a * const Complex.fromReal(2),
        b: b,
      );

  @override
  Complex discriminant() => (b * b) - const Complex.fromReal(4) * a * c;

  @override
  List<Complex> solutions() {
    final disc = discriminant();
    final twoA = const Complex.fromReal(2) * a;

    return <Complex>[
      (b.negate + disc.sqrt()) / twoA,
      (b.negate - disc.sqrt()) / twoA,
    ];
  }

  /// The first coefficient of the equation in the form
  /// _f(x) = ax^2 + bx + c = 0_
  Complex get a => coefficients.first;

  /// The second coefficient of the equation in the form
  /// _f(x) = ax^2 + bx + c = 0_
  Complex get b => coefficients[1];

  /// The third coefficient of the equation in the form
  /// _f(x) = ax^2 + bx + c = 0_
  Complex get c => coefficients[2];

  /// {@macro algebraic_deep_copy}
  Quadratic copyWith({
    Complex? a,
    Complex? b,
    Complex? c,
  }) =>
      Quadratic(
        a: a ?? this.a,
        b: b ?? this.b,
        c: c ?? this.c,
      );
}
