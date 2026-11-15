part of '../algebraic.dart';

/// {@template quartic_algebraic}
/// Concrete implementation of [Algebraic] that represents a fourth-degree
/// polynomial equation in the form _ax^4 + bx^3 + cx^2 + dx + e = 0_.
///
/// This equation has exactly 4 roots, some of which may coincide. When all the
/// coefficients are real, the non-real roots come in complex conjugate pairs,
/// so there are either 4, 2 or 0 real roots (counted with multiplicity). The
/// discriminant is zero if and only if there is a repeated root. A negative
/// discriminant means 2 distinct real roots and 2 complex conjugate roots,
/// while a positive one means that the roots are either all real or all
/// non-real.
///
/// With complex coefficients, there is no such rule.
///
/// The roots are computed with the general closed-form formula, so they are
/// subject to rounding errors. In particular, roots that are very close to
/// each other are sensitive to small changes in the coefficients.
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
///
/// // f(x) = -x^4 - 8x^3 - 1
/// final eq = Quartic.realEquation(
///   a: -1,
///   b: -8,
///   e: -1,
/// );
/// ```
/// {@endtemplate}
final class Quartic extends Algebraic {
  /// {@macro quartic_algebraic}
  ///
  /// {@macro quartic_algebraic_examples}
  ///
  /// Use this constructor if you have complex coefficients. If no [Complex]
  /// values are required, consider using [Quartic.realEquation] for a less
  /// verbose syntax.
  new({
    Complex a = const Complex.fromReal(1),
    Complex b = const Complex.zero(),
    Complex c = const Complex.zero(),
    Complex d = const Complex.zero(),
    Complex e = const Complex.zero(),
  }) : super([a, b, c, d, e]);

  /// {@macro quartic_algebraic}
  ///
  /// {@macro quartic_algebraic_examples}
  ///
  /// If the coefficients of your polynomial contain complex numbers, consider
  /// using the [Quartic.new] constructor instead.
  new realEquation({
    double a = 1,
    double b = 0,
    double c = 0,
    double d = 0,
    double e = 0,
  }) : super.realEquation([a, b, c, d, e]);

  /// The primitive cube root of unity, _omega = e^(2*pi*i/3)_.
  static final _omega = Complex(-1 / 2, sqrt(3) / 2);

  /// The square of [_omega], which is also its conjugate.
  static final _omegaSquared = Complex(-1 / 2, -sqrt(3) / 2);

  /// The relative tolerance used to decide whether a quantity that is the sum
  /// of several terms is zero, up to rounding errors.
  static const _relativeTolerance = 1e-14;

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

  @override
  List<Complex> solutions() {
    // Special case: d = e = 0, so the equation is x^2(ax^2 + bx + c) = 0
    if (d.isZero && e.isZero) {
      return [
        const Complex.zero(),
        const Complex.zero(),
        ...Quadratic(a: a, b: b, c: c).solutions(),
      ];
    }

    // Special case: e = 0, so the equation is x(ax^3 + bx^2 + cx + d) = 0
    if (e.isZero) {
      return [
        const Complex.zero(),
        ...Cubic(a: a, b: b, c: c, d: d).solutions(),
      ];
    }

    // Divide by the leading coefficient to get x^4 + Bx^3 + Cx^2 + Dx + E = 0
    final fb = b / a;
    final fc = c / a;
    final fd = d / a;
    final fe = e / a;
    final shift = fb / const Complex.fromReal(4);

    // The substitution x = y - B/4 gives the depressed quartic
    // y^4 + py^2 + qy + r = 0, where:
    //
    //  p = C - 3B^2/8
    //  q = D - BC/2 + B^3/8
    //  r = E - BD/4 + B^2C/16 - 3B^4/256
    final fb2 = fb * fb;
    final p = fc - const Complex.fromReal(3 / 8) * fb2;
    final halfBC = fb * fc / const Complex.fromReal(2);
    final fb3Over8 = fb2 * fb / const Complex.fromReal(8);
    final q = fd - halfBC + fb3Over8;

    // When q = 0, the depressed quartic is biquadratic: y^4 + py^2 + r = 0.
    // This includes the case b = d = 0. Solving it directly is more accurate,
    // and it is needed because the general formula divides by a quantity that
    // can only be zero when q = 0.
    if (q.abs() <=
        _relativeTolerance * (fd.abs() + halfBC.abs() + fb3Over8.abs())) {
      final r =
          fe -
          fb * fd / const Complex.fromReal(4) +
          fb2 * fc / const Complex.fromReal(16) -
          const Complex.fromReal(3 / 256) * fb2 * fb2;

      return Quadratic(b: p, c: r)
          .solutions()
          .expand((y2) {
            final y = y2.sqrt();
            return [y - shift, -y - shift];
          })
          .toList(growable: false);
    }

    return _solveGeneralQuartic(fb, fc, fd, fe, p, q);
  }

  /// Solves _x^4 + Bx^3 + Cx^2 + Dx + E = 0_ with the general closed-form
  /// formula, where [p] and [q] are coefficients of the depressed quartic (see
  /// [solutions]
  List<Complex> _solveGeneralQuartic(
    Complex fb,
    Complex fc,
    Complex fd,
    Complex fe,
    Complex p,
    Complex q,
  ) {
    const two = Complex.fromReal(2);
    const three = Complex.fromReal(3);
    const four = Complex.fromReal(4);

    // Delta0 = C^2 - 3BD + 12E
    // Delta1 = 2C^3 - 9BCD + 27B^2E + 27D^2 - 72CE
    final d0 = fc * fc - three * fb * fd + const Complex.fromReal(12) * fe;
    final d1 =
        two * fc * fc * fc -
        const Complex.fromReal(9) * fb * fc * fd +
        const Complex.fromReal(27) * (fb * fb * fe + fd * fd) -
        const Complex.fromReal(72) * fc * fe;

    // Choosing the sign that gives the largest magnitude avoids cancellation
    // and guarantees that Q != 0 unless Delta0 = Delta1 = 0.
    final sqrtTerm = (d1 * d1 - four * d0 * d0 * d0).sqrt();
    final sum = d1 + sqrtTerm;
    final diff = d1 - sqrtTerm;
    final q0 = ((sum.abs() > diff.abs() ? sum : diff) / two).nthRoot(3);

    // Any of the 3 cube roots of Q^3 gives the same roots, provided that S is
    // not zero. The one that gives the largest S is the most accurate.
    final minusTwoPOverThree = -two * p / three;
    var s2 = const Complex.zero();
    for (final cubeRoot in [q0, q0 * _omega, q0 * _omegaSquared]) {
      final term = cubeRoot.isZero
          ? const Complex.zero()
          : (cubeRoot + d0 / cubeRoot) / three;
      final candidate = (minusTwoPOverThree + term) / four;

      if (candidate.abs() > s2.abs()) {
        s2 = candidate;
      }
    }

    final s = s2.sqrt();
    final base = -fb / four;
    final radicandBase = -four * s2 - two * p;
    final qOverS = q / s;
    final sqrt1 = (radicandBase + qOverS).sqrt() / two;
    final sqrt2 = (radicandBase - qOverS).sqrt() / two;

    return [
      base - s - sqrt1,
      base - s + sqrt1,
      base + s - sqrt2,
      base + s + sqrt2,
    ];
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
  /// {@template quartic.equation_form}
  /// _f(x) = ax^4 + bx^3 + cx^2 + dx + e = 0_
  /// {@endtemplate}
  Complex get a => coefficients.first;

  /// {@template second_coefficient_algebraic}
  /// The second coefficient of the equation in the form
  /// {@endtemplate}
  /// {@macro quartic.equation_form}
  Complex get b => coefficients[1];

  /// {@template third_coefficient_algebraic}
  /// The third coefficient of the equation in the form
  /// {@endtemplate}
  /// {@macro quartic.equation_form}
  Complex get c => coefficients[2];

  /// {@template fourth_coefficient_algebraic}
  /// The fourth coefficient of the equation in the form
  /// {@endtemplate}
  /// {@macro quartic.equation_form}
  Complex get d => coefficients[3];

  /// {@template fifth_coefficient_algebraic}
  /// The fifth coefficient of the equation in the form
  /// {@endtemplate}
  /// {@macro quartic.equation_form}
  Complex get e => coefficients[4];
}
