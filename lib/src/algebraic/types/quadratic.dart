part of '../algebraic.dart';

/// {@template quadratic_algebraic}
/// Concrete implementation of [Algebraic] that represents a second-degree
/// polynomial equation in the form _ax^2 + bx + c = 0_.
///
/// This equation has exactly 2 roots, which may coincide. When all the
/// coefficients are real, the sign of the discriminant tells whether the roots
/// are two distinct real numbers, a repeated real number, or a pair of complex
/// conjugates. With complex coefficients, there is no such rule: for example,
/// one root can be real while the other is not.
/// {@endtemplate}
///
/// {@template quadratic_algebraic_examples}
/// These are examples of quadratic equations, where the coefficient with the
/// highest degree goes first:
///
/// ```dart
/// // f(x) = 2x^2 - 6x + 5
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
/// // f(x) = 2x^2 - 6x + 5
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
  new({
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
  new realEquation({double a = 1, double b = 0, double c = 0})
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
    // Special case when b = 0 -> x = +/- sqrt(-c/a)
    if (b.isZero) {
      final sqrtTerm = (-c / a).sqrt();
      return <Complex>[sqrtTerm, -sqrtTerm];
    }

    // The roots are x = -h +/- s, where h = b/2a and s = sqrt(h^2 - c/a).
    final h = b / (const Complex.fromReal(2) * a);
    final product = c / a;
    final s = (h * h - product).sqrt();

    final sameDirection = h.real * s.real + h.imaginary * s.imaginary >= 0;
    final largest = sameDirection ? -h - s : -h + s;
    final smallest = product / largest;

    // Return the roots in the -h + s, -h - s order.
    return sameDirection ? [smallest, largest] : [largest, smallest];
  }

  /// {@macro algebraic_deep_copy}
  Quadratic copyWith({
    Complex? a,
    Complex? b,
    Complex? c,
  }) => Quadratic(
    a: a ?? this.a,
    b: b ?? this.b,
    c: c ?? this.c,
  );

  /// {@macro first_coefficient_algebraic}
  /// {@template quadratic.equation_form}
  /// _f(x) = ax^2 + bx + c = 0_
  /// {@endtemplate}
  Complex get a => coefficients.first;

  /// {@macro second_coefficient_algebraic}
  /// {@macro quadratic.equation_form}
  Complex get b => coefficients[1];

  /// {@macro third_coefficient_algebraic}
  /// {@macro quadratic.equation_form}
  Complex get c => coefficients[2];
}
