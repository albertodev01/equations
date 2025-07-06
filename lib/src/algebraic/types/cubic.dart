part of '../algebraic.dart';

/// {@template cubic_algebraic}
/// Concrete implementation of [Algebraic] that represents a third degree
/// polynomial equation in the form `ax^3 + bx^2 + cx + d = 0`.
///
/// This equation has 3 solutions, which can be combined as follows:
///
///  - 3 distinct real roots and 0 complex roots
///  - 3 real roots (some of them are equal) and 0 complex roots
///  - 1 real root and 2 complex conjugate roots
///
/// The above cases depend on the value of the discriminant. Some edge cases:
///
///  - If [a] is very close to zero, the equation becomes numerically unstable;
///  - If the discriminant is very close to zero, the roots may be very close to
///    each other;
///  - Very large or very small coefficients may cause numerical overflow or
///    underflow.
///
/// Throws [AlgebraicException] if:
///
///  - [a] is zero (which would make it a quadratic equation);
///  - [a] is very close to zero (less than [epsilon]).
/// {@endtemplate}
///
/// {@template cubic_algebraic_examples}
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
///
/// // f(x) = 2x^3 + x^2 + 5
/// final eq = Cubic.fromReal(
///   a: 2,
///   b: 1,
///   d: 5,
/// );
/// ```
/// {@endtemplate}
final class Cubic extends Algebraic {
  /// The value used to check if a coefficient is very close to zero. In other
  /// words, if `|a| < epsilon`, then `a` is considered to be zero.
  ///
  /// This value is used to avoid numerical instability when solving the cubic
  /// equation.
  static const epsilon = 1e-10;

  /// {@macro cubic_algebraic}
  ///
  /// {@macro cubic_algebraic_examples}
  ///
  /// Use this constructor if you have complex coefficients. If no [Complex]
  /// values are required, consider using [Cubic.realEquation] for a less
  /// verbose syntax.
  Cubic({
    Complex a = const Complex.fromReal(1),
    Complex b = const Complex.zero(),
    Complex c = const Complex.zero(),
    Complex d = const Complex.zero(),
  }) : super([a, b, c, d]) {
    _validateCoefficients(a);
  }

  /// {@macro cubic_algebraic}
  ///
  /// {@macro cubic_algebraic_examples}
  ///
  /// If the coefficients of your polynomial contain complex numbers, consider
  /// using the [Cubic.new] constructor instead.
  Cubic.realEquation({double a = 1, double b = 0, double c = 0, double d = 0})
    : super.realEquation([a, b, c, d]);

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
    // Special case: c = d = 0 (equation in form ax^3 + bx^2 = 0)
    if (c.isZero && d.isZero) {
      return [const Complex.zero(), const Complex.zero(), -b / a];
    }

    // Special case: b = c = 0 (depressed cubic)
    if (b.isZero && c.isZero) {
      return _solveDepressedCubic();
    }

    // General case using Cardano's formula
    return _solveGeneralCubic();
  }

  /// Solves the depressed cubic equation ax³ + d = 0
  List<Complex> _solveDepressedCubic() {
    final solution1 = (d.negate / a).nthRoot(3);
    final omega = Complex(-1 / 2, sqrt(3) / 2);

    return [solution1, solution1 * omega, solution1 * omega.pow(2)];
  }

  /// Solves the general cubic equation using Cardano's formula
  List<Complex> _solveGeneralCubic() {
    const two = Complex.fromReal(2);
    const three = Complex.fromReal(3);
    final omega = Complex(-1 / 2, sqrt(3) / 2);

    // Calculate intermediate values
    final d0 = b * b - a * c * three;
    final d1 =
        (b.pow(3) * two) -
        (a * b * c * const Complex.fromReal(9)) +
        (a * a * d * const Complex.fromReal(27));

    // Calculate discriminant
    final disc = discriminant();

    // Handle case where discriminant is very close to zero
    if (disc.abs() < epsilon) {
      return _handleNearZeroDiscriminant(d0, d1);
    }

    // Calculate C using a more stable formula
    final sqrtD = (disc * a * a * const Complex.fromReal(-27)).sqrt();
    final C = _calculateC(d1, sqrtD);

    // Calculate the constant term
    final constTerm = const Complex.fromReal(-1) / (a * three);

    // Return the three solutions
    return <Complex>[
      constTerm * (b + C + (d0 / C)),
      constTerm * (b + (C * omega) + (d0 / (C * omega))),
      constTerm * (b + (C * omega.pow(2)) + (d0 / (C * omega.pow(2)))),
    ];
  }

  /// Handles the case where the discriminant is very close to zero
  List<Complex> _handleNearZeroDiscriminant(Complex d0, Complex d1) {
    // When discriminant is near zero, we have a triple root or a double root
    final x = -b / (a * const Complex.fromReal(3));

    if (d0.abs() < epsilon) {
      // Triple root
      return [x, x, x];
    } else {
      // Double root and a single root
      final doubleRoot = x;
      final singleRoot = -b / a - const Complex.fromReal(2) * x;
      return [doubleRoot, doubleRoot, singleRoot];
    }
  }

  /// Calculates C in a numerically stable way
  Complex _calculateC(Complex d1, Complex sqrtD) {
    // Use a more stable formula for calculating C
    final sum = d1 + sqrtD;
    final diff = d1 - sqrtD;

    if (sum.abs() > diff.abs()) {
      return (sum / const Complex.fromReal(2)).nthRoot(3);
    } else {
      return (diff / const Complex.fromReal(2)).nthRoot(3);
    }
  }

  /// Validates the coefficients of the cubic equation.
  void _validateCoefficients(Complex a) {
    if (a.isZero) {
      throw const AlgebraicException(
        'The coefficient of x^3 cannot be zero in a cubic equation.',
      );
    }

    // Check if a is very close to zero (for numerical stability)
    if (a.abs() < epsilon) {
      throw const AlgebraicException(
        '"a" is too close to zero, which may cause numerical instability.',
      );
    }
  }

  /// {@macro algebraic_deep_copy}
  Cubic copyWith({Complex? a, Complex? b, Complex? c, Complex? d}) =>
      Cubic(a: a ?? this.a, b: b ?? this.b, c: c ?? this.c, d: d ?? this.d);

  /// {@macro first_coefficient_algebraic}
  /// _f(x) = ax^3 + bx^2 + cx + d = 0_
  Complex get a => coefficients.first;

  /// {@macro second_coefficient_algebraic}
  /// _f(x) = ax^3 + bx^2 + cx + d = 0_
  Complex get b => coefficients[1];

  /// {@macro third_coefficient_algebraic}
  /// _f(x) = ax^3 + bx^2 + cx + d = 0_
  Complex get c => coefficients[2];

  /// {@macro fourth_coefficient_algebraic}
  /// _f(x) = ax^3 + bx^2 + cx + d = 0_
  Complex get d => coefficients[3];
}
