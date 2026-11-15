part of '../algebraic.dart';

/// {@template cubic_algebraic}
/// Concrete implementation of [Algebraic] that represents a third-degree
/// polynomial equation in the form _ax^3 + bx^2 + cx + d = 0_.
///
/// This equation has exactly 3 roots, some of which may coincide. When all the
/// coefficients are real, the sign of the discriminant tells which of these
/// cases applies:
///
///  - positive: 3 distinct real roots;
///  - zero: 3 real roots, at least 2 of which are equal;
///  - negative: 1 real root and 2 complex conjugate roots.
///
/// With complex coefficients, there is no such rule.
///
/// The roots are computed with Cardano's formula, so they are subject to
/// rounding errors. In particular, roots that are very close to each other are
/// sensitive to small changes in the coefficients, and very large or very small
/// coefficients may cause overflow or underflow.
///
/// Throws an [AlgebraicException] if [a] is zero, since the equation would not
/// be cubic.
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
/// final eq = Cubic.realEquation(
///   a: 2,
///   b: 1,
///   d: 5,
/// );
/// ```
/// {@endtemplate}
final class Cubic extends Algebraic {
  /// {@macro cubic_algebraic}
  ///
  /// {@macro cubic_algebraic_examples}
  ///
  /// Use this constructor if you have complex coefficients. If no [Complex]
  /// values are required, consider using [Cubic.realEquation] for a less
  /// verbose syntax.
  new({
    Complex a = const Complex.fromReal(1),
    Complex b = const Complex.zero(),
    Complex c = const Complex.zero(),
    Complex d = const Complex.zero(),
  }) : super([a, b, c, d]);

  /// {@macro cubic_algebraic}
  ///
  /// {@macro cubic_algebraic_examples}
  ///
  /// If the coefficients of your polynomial contain complex numbers, consider
  /// using the [Cubic.new] constructor instead.
  new realEquation({double a = 1, double b = 0, double c = 0, double d = 0})
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
    // Special case: c = d = 0, so ax^3 + bx^2 = x^2(ax + b) = 0
    if (c.isZero && d.isZero) {
      return [const Complex.zero(), const Complex.zero(), -b / a];
    }

    // Special case: b = c = 0, so ax^3 + d = 0
    if (b.isZero && c.isZero) {
      return _solvePureCubic();
    }

    // General case using Cardano's formula
    return _solveGeneralCubic();
  }

  /// The primitive cube root of unity, _omega = e^(2*pi*i/3)_.
  static final _omega = Complex(-1 / 2, sqrt(3) / 2);

  /// The square of [_omega], which is also its conjugate.
  static final _omegaSquared = Complex(-1 / 2, -sqrt(3) / 2);

  /// The relative tolerance used to decide whether a quantity that is the sum
  /// of several terms is zero, up to rounding errors.
  static const _relativeTolerance = 1e-14;

  /// Returns `true` when [value], which was computed as a sum whose terms have
  /// magnitudes adding up to [scale], is zero up to rounding errors.
  static bool _isNegligible(Complex value, double scale) =>
      value.abs() <= _relativeTolerance * scale;

  /// Solves _ax^3 + d = 0_, whose roots are the three cube roots of _-d/a_.
  List<Complex> _solvePureCubic() {
    final root = (-d / a).nthRoot(3);

    return [root, root * _omega, root * _omegaSquared];
  }

  /// Solves the general cubic equation using Cardano's formula.
  List<Complex> _solveGeneralCubic() {
    const three = Complex.fromReal(3);
    const nine = Complex.fromReal(9);
    const twentySeven = Complex.fromReal(27);

    final bb = b * b;
    final ac = a * c;
    final abc = ac * b;
    final aad = a * a * d;
    final d0 = bb - three * ac;
    final d1 =
        const Complex.fromReal(2) * bb * b - nine * abc + twentySeven * aad;

    final isTripleRoot =
        _isNegligible(
          d0,
          bb.abs() + 3 * ac.abs(),
        ) &&
        _isNegligible(
          d1,
          2 * bb.abs() * b.abs() + 9 * abc.abs() + 27 * aad.abs(),
        );
    if (isTripleRoot) {
      final root = -b / (three * a);
      return [root, root, root];
    }

    // Delta1^2 - 4*Delta0^3 = -27*a^2*Delta, where Delta is the discriminant.
    // It is computed from Delta0 and Delta1 rather than from discriminant()
    // because the latter sums larger terms that cancel out, which loses
    // precision.
    final d1Squared = d1 * d1;
    final fourD0Cubed = const Complex.fromReal(4) * d0 * d0 * d0;
    final radicand = d1Squared - fourD0Cubed;

    if (_isNegligible(radicand, d1Squared.abs() + fourD0Cubed.abs())) {
      final doubleRoot =
          (nine * a * d - b * c) / (const Complex.fromReal(2) * d0);
      final singleRoot =
          (const Complex.fromReal(4) * abc - nine * aad - bb * b) / (a * d0);
      return [doubleRoot, doubleRoot, singleRoot];
    }

    final C = _calculateC(d1, radicand.sqrt());

    final constTerm = const Complex.fromReal(-1) / (a * three);
    final cOmega = C * _omega;
    final cOmegaSquared = C * _omegaSquared;

    return <Complex>[
      constTerm * (b + C + (d0 / C)),
      constTerm * (b + cOmega + (d0 / cOmega)),
      constTerm * (b + cOmegaSquared + (d0 / cOmegaSquared)),
    ];
  }

  /// Computes Cardano's _C. The sign is chosen so that the radicand has the
  /// largest magnitude.
  Complex _calculateC(Complex d1, Complex sqrtD) {
    final sum = d1 + sqrtD;
    final diff = d1 - sqrtD;
    final radicand = sum.abs() > diff.abs() ? sum : diff;

    return (radicand / const Complex.fromReal(2)).nthRoot(3);
  }

  /// {@macro algebraic_deep_copy}
  Cubic copyWith({
    Complex? a,
    Complex? b,
    Complex? c,
    Complex? d,
  }) => Cubic(
    a: a ?? this.a,
    b: b ?? this.b,
    c: c ?? this.c,
    d: d ?? this.d,
  );

  /// {@macro first_coefficient_algebraic}
  /// {@template cubic.equation_form}
  /// _f(x) = ax^3 + bx^2 + cx + d = 0_
  /// {@endtemplate}
  Complex get a => coefficients.first;

  /// {@macro second_coefficient_algebraic}
  /// {@macro cubic.equation_form}
  Complex get b => coefficients[1];

  /// {@macro third_coefficient_algebraic}
  /// {@macro cubic.equation_form}
  Complex get c => coefficients[2];

  /// {@macro fourth_coefficient_algebraic}
  /// {@macro cubic.equation_form}
  Complex get d => coefficients[3];
}
