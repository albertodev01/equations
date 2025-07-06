part of '../algebraic.dart';

/// {@template quartic_algebraic}
/// Concrete implementation of [Algebraic] that represents a fourth degree
/// polynomial equation in the form _ax^4 + bx^3 + cx^2 + dx + e = 0_.
///
/// This equation has 4 solutions, which can be combined as follows:
///
///  - 2 distinct real roots and 2 complex conjugate roots
///  - 4 real roots and 0 complex roots
///  - 0 real roots and 4 complex conjugate roots
///  - Multiple roots which can be all equal or paired (complex or real)
///
/// The above cases depend on the value of the discriminant.
/// {@endtemplate}
///
/// {@template quartic_algebraic_examples}
/// These are examples of quartic equations, where the coefficient with the
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
/// // f(x) = -x^4 - 8x^3 - 1
/// final eq = Quartic.realEquation(
///   a: Complex.fromReal(-1),
///   b: Complex.fromReal(-8),
///   e: Complex.fromReal(-1),
/// );
/// ```
/// {@endtemplate}
final class Quartic extends Algebraic {
  /// The value used to check if a coefficient is very close to zero. In other
  /// words, if `|a| < epsilon`, then `a` is considered to be zero.
  ///
  /// This value is used to avoid numerical instability when solving the cubic
  /// equation.
  static const epsilon = 1e-10;

  /// The maximum value a coefficient can have. If a coefficient is greater
  /// than this value, an exception will be thrown.
  static const maxCoefficient = 1e10;

  /// The minimum value a coefficient can have. If a coefficient is less than
  /// this value, an exception will be thrown.
  static const minCoefficient = 1e-10;

  /// {@macro quartic_algebraic}
  ///
  /// {@macro quartic_algebraic_examples}
  ///
  /// Use this constructor if you have complex coefficients. If no [Complex]
  /// values are required, then consider using [Quartic.realEquation] for a
  /// less verbose syntax.
  Quartic({
    Complex a = const Complex.fromReal(1),
    Complex b = const Complex.zero(),
    Complex c = const Complex.zero(),
    Complex d = const Complex.zero(),
    Complex e = const Complex.zero(),
  }) : super([a, b, c, d, e]) {
    _validateCoefficients();
  }

  /// {@macro quartic_algebraic}
  ///
  /// {@macro quartic_algebraic_examples}
  ///
  /// If the coefficients of your polynomial contain complex numbers, consider
  /// using the [Quartic.new] constructor instead.
  Quartic.realEquation({
    double a = 1,
    double b = 0,
    double c = 0,
    double d = 0,
    double e = 0,
  }) : super.realEquation([a, b, c, d, e]) {
    _validateCoefficients();
  }

  /// Validates the coefficients of the quartic equation
  void _validateCoefficients() {
    // Check for extremely large coefficients that might cause numerical
    // nstability
    for (var i = 0; i < coefficients.length; i++) {
      if (coefficients[i].abs() > maxCoefficient) {
        throw AlgebraicException(
          'Coefficient at index $i is too large (|c| > $maxCoefficient)',
        );
      }
    }
  }

  @override
  int get degree => 4;

  @override
  Algebraic derivative() => Cubic(
    a: a * const Complex.fromReal(4),
    b: b * const Complex.fromReal(3),
    c: c * const Complex.fromReal(2),
    d: d,
  );

  @override
  Complex discriminant() {
    final b2 = b * b;
    final c2 = c * c;
    final d2 = d * d;
    final a2 = a * a;
    final b3 = b2 * b;
    final c3 = c2 * c;
    final d3 = d2 * d;

    final k =
        (b2 * c2 * d2) -
        (d3 * b3 * const Complex.fromReal(4)) -
        (d2 * c3 * a * const Complex.fromReal(4)) +
        (d3 * c * b * a * const Complex.fromReal(18)) -
        (d2 * d2 * a2 * const Complex.fromReal(27)) +
        (e * e * e * a2 * a * const Complex.fromReal(256));

    final p =
        e *
        ((c3 * b2 * const Complex.fromReal(-4)) +
            (b3 * c * d * const Complex.fromReal(18)) +
            (c2 * c2 * a * const Complex.fromReal(16)) -
            (d * c2 * b * a * const Complex.fromReal(80)) -
            (d2 * b2 * a * const Complex.fromReal(6)) +
            (d2 * a2 * c * const Complex.fromReal(144)));

    final r =
        (e * e) *
        (b2 * b2 * const Complex.fromReal(-27) +
            b2 * c * a * const Complex.fromReal(144) -
            a2 * c2 * const Complex.fromReal(128) -
            d * b * a2 * const Complex.fromReal(192));

    return k + p + r;
  }

  /// Normalizes coefficients to improve numerical stability
  List<Complex> _normalizeCoefficients() {
    final maxCoeff = coefficients
        .map((c) => c.abs())
        .reduce((a, b) => a > b ? a : b);

    if (maxCoeff > maxCoefficient) {
      final scale = Complex.fromReal(maxCoefficient / maxCoeff);
      return coefficients.map((c) => c * scale).toList();
    }

    return coefficients;
  }

  @override
  List<Complex> solutions() {
    // Normalize coefficients for better numerical stability
    final normalizedCoeffs = _normalizeCoefficients();
    final a = normalizedCoeffs[0];
    final b = normalizedCoeffs[1];
    final c = normalizedCoeffs[2];
    final d = normalizedCoeffs[3];
    final e = normalizedCoeffs[4];

    // Special case: all coefficients are zero
    if (b.abs() < epsilon &&
        c.abs() < epsilon &&
        d.abs() < epsilon &&
        e.abs() < epsilon) {
      return [
        const Complex.zero(),
        const Complex.zero(),
        const Complex.zero(),
        const Complex.zero(),
      ];
    }

    // Special case: ax^4 + e = 0
    if (b.abs() < epsilon && c.abs() < epsilon && d.abs() < epsilon) {
      // This reduces to ax^4 + e = 0
      // Solutions are the fourth roots of -e/a
      final solutions = <Complex>[];
      final root = (e.negate / a).pow(0.25);

      // Add all four fourth roots
      solutions
        ..add(root)
        ..add(root * const Complex.i())
        ..add(root.negate)
        ..add(root * const Complex.i().negate);

      return solutions;
    }

    // Special case: ax^4 + cx^2 + e = 0
    if (b.abs() < epsilon && d.abs() < epsilon) {
      // This reduces to ax^4 + cx^2 + e = 0
      // Using substitution y = x^2, we get ay^2 + cy + e = 0
      final solutions = <Complex>[];
      final quadratic = Quadratic(a: a, b: c, c: e);
      final roots = quadratic.solutions();

      for (final root in roots) {
        if (root.abs() < epsilon) {
          solutions.add(const Complex.zero());
        } else {
          final sqrt = root.sqrt();
          solutions
            ..add(sqrt)
            ..add(sqrt.negate);
        }
      }
      return solutions;
    }

    // Special case: ax^4 + bx^3 + cx^2 = 0
    if (d.abs() < epsilon && e.abs() < epsilon) {
      // This reduces to x^2(ax^2 + bx + c) = 0
      // One solution is x = 0 (double root)
      // The other two solutions come from ax^2 + bx + c = 0
      final quadratic = Quadratic(a: a, b: b, c: c);
      final roots = quadratic.solutions();

      return [const Complex.zero(), const Complex.zero(), ...roots];
    }

    // Normalize by leading coefficient
    final fb = b / a;
    final fc = c / a;
    final fd = d / a;
    final fe = e / a;

    // Calculate intermediate values for the quartic formula. These values are
    // part of the Ferrari's method for solving quartic equations.
    final q1 =
        (fc * fc) -
        (fb * fd * const Complex.fromReal(3)) +
        (fe * const Complex.fromReal(12));

    final q2 =
        (fc.pow(3) * const Complex.fromReal(2)) -
        (fb * fc * fd * const Complex.fromReal(9)) +
        (fd.pow(2) * const Complex.fromReal(27)) +
        (fb.pow(2) * fe * const Complex.fromReal(27)) -
        (fc * fe * const Complex.fromReal(72));

    final q3 =
        (fb * fc * const Complex.fromReal(8)) -
        (fd * const Complex.fromReal(16)) -
        (fb.pow(3) * const Complex.fromReal(2));

    final q4 =
        (fb.pow(2) * const Complex.fromReal(3)) -
        (fc * const Complex.fromReal(8));

    // Calculate the first part of the roots with improved numerical stability.
    var temp = (q2 * q2 / const Complex.fromReal(4)) - (q1.pow(3));
    if (temp.abs() < epsilon) {
      temp = const Complex.fromReal(epsilon);
    }
    final q5 = (temp.sqrt() + (q2 / const Complex.fromReal(2))).pow(1.0 / 3.0);
    final q6 = ((q1 / q5) + q5) / const Complex.fromReal(3);
    temp = (q4 / const Complex.fromReal(12)) + q6;
    if (temp.abs() < epsilon) {
      temp = const Complex.fromReal(epsilon);
    }
    final q7 = temp.sqrt() * const Complex.fromReal(2);

    // Calculate the second part of the roots.
    temp =
        ((q4 * const Complex.fromReal(4)) / const Complex.fromReal(6)) -
        (q6 * const Complex.fromReal(4)) -
        (q3 / q7);

    if (temp.abs() < epsilon) {
      temp = const Complex.fromReal(epsilon);
    }

    final solutions = [
      (fb.negate - q7 - temp.sqrt()) / const Complex.fromReal(4),
      (fb.negate - q7 + temp.sqrt()) / const Complex.fromReal(4),
    ];

    // Calculate the third and fourth parts of the roots.
    temp =
        ((q4 * const Complex.fromReal(4)) / const Complex.fromReal(6)) -
        (q6 * const Complex.fromReal(4)) +
        (q3 / q7);

    if (temp.abs() < epsilon) {
      temp = const Complex.fromReal(epsilon);
    }

    solutions
      ..add((fb.negate + q7 - temp.sqrt()) / const Complex.fromReal(4))
      ..add((fb.negate + q7 + temp.sqrt()) / const Complex.fromReal(4));

    return solutions;
  }

  /// {@macro algebraic_deep_copy}
  Quartic copyWith({
    Complex? a,
    Complex? b,
    Complex? c,
    Complex? d,
    Complex? e,
  }) => Quartic(
    a: a ?? this.a,
    b: b ?? this.b,
    c: c ?? this.c,
    d: d ?? this.d,
    e: e ?? this.e,
  );

  /// {@template first_coefficient_algebraic}
  /// The first coefficient of the equation in the form
  /// {@endtemplate}
  /// _f(x) = ax^4 + bx^3 + cx^2 + dx + e = 0_
  Complex get a => coefficients.first;

  /// {@template second_coefficient_algebraic}
  /// The second coefficient of the equation in the form
  /// {@endtemplate}
  /// _f(x) = ax^4 + bx^3 + cx^2 + dx + e = 0_
  Complex get b => coefficients[1];

  /// {@template third_coefficient_algebraic}
  /// The third coefficient of the equation in the form
  /// {@endtemplate}
  /// _f(x) = ax^4 + bx^3 + cx^2 + dx + e = 0_
  Complex get c => coefficients[2];

  /// {@template fourth_coefficient_algebraic}
  /// The fourth coefficient of the equation in the form
  /// {@endtemplate}
  /// _f(x) = ax^4 + bx^3 + cx^2 + dx + e = 0_
  Complex get d => coefficients[3];

  /// {@template fifth_coefficient_algebraic}
  /// The fifth coefficient of the equation in the form
  /// {@endtemplate}
  /// _f(x) = ax^4 + bx^3 + cx^2 + dx + e = 0_
  Complex get e => coefficients[4];
}
