import 'package:equations/equations.dart';

/// {@template algebraic_inequality_solver}
/// Solves an inequality in the form _P(x) < 0_, _P(x) <= 0_, _P(x) > 0_ or
/// _P(x) >= 0_, where _P(x)_ is a polynomial with real coefficients.
///
/// ## Algorithm Overview
///
/// The sign of _P(x)_ can only change at its real roots, so the roots split
/// the real line into regions where the sign of _P(x)_ is constant:
///
///  1. The real part of every root of _P(x)_ is a boundary between two
///     regions. This includes complex roots, because a real root computed
///     numerically can have a small imaginary part (for example, the roots of
///     `(x - 2)^5`). A boundary that is not a real root has the same sign on
///     both sides, so it disappears in step 4.
///  2. A boundary is a root when _P(x)_ is zero up to [precision], relative to
///     the size of the terms of _P(x)_.
///  3. The sign of _P(x)_ is tested once inside each region. Roots that are
///     only separated by values of _P(x)_ that are zero up to floating point
///     rounding are merged into a single root.
///  4. Consecutive regions and boundaries where the inequality holds are
///     joined, so the returned solutions never touch each other.
///
/// ## Example
/// ```dart
/// final solver = AlgebraicInequalitySolver(
///   // (x - 1)^2 * (x - 3)
///   polynomial: Algebraic.fromReal([1, -5, 7, -3]),
///   inequalityType: AlgebraicInequalityType.lessThanOrEqualTo,
/// );
///
/// final solutions = solver.solve();
/// // [AlgebraicInequalitySmallerThan(value: 3, isInclusive: true)]
/// ```
/// {@endtemplate}
final class AlgebraicInequalitySolver {
  /// {@macro algebraic_inequality_solver}
  const new({
    required this.polynomial,
    required this.inequalityType,
    this.precision = 1.0e-10,
  });

  /// The polynomial _P(x)_ of the inequality.
  final Algebraic polynomial;

  /// The kind of inequality to solve.
  final AlgebraicInequalityType inequalityType;

  /// The relative tolerance used to decide whether a boundary is a root.
  final double precision;

  /// The difference between 1 and the next representable double.
  static const _machineEpsilon = 2.220446049250313e-16;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is AlgebraicInequalitySolver &&
        polynomial == other.polynomial &&
        inequalityType == other.inequalityType &&
        precision == other.precision;
  }

  @override
  int get hashCode => Object.hash(polynomial, inequalityType, precision);

  /// Solves the inequality.
  ///
  /// Returns the solutions sorted in ascending order. They never overlap or
  /// touch each other. For `<=` and `>=` every solution includes its
  /// endpoints, while for `<` and `>` it excludes them. A root where _P(x)_
  /// touches zero without changing sign is returned as the degenerate interval
  /// `[root, root]`. The list is empty when no real number satisfies the
  /// inequality.
  ///
  /// Throws an [AlgebraicException] if [polynomial] has complex coefficients
  /// or [precision] is not positive.
  List<AlgebraicInequalitySolution> solve() {
    if (precision <= 0) {
      throw const AlgebraicException(
        'The precision must be a positive number.',
      );
    }

    if (!polynomial.isRealEquation) {
      throw const AlgebraicException(
        'Inequalities are not well-defined in the complex plane.',
      );
    }

    final coefficients = polynomial.coefficients
        .map((c) => c.real)
        .toList(growable: false);
    final roundingTolerance = 4 * (coefficients.length - 1) * _machineEpsilon;
    final rootTolerance = precision > roundingTolerance
        ? precision
        : roundingTolerance;

    // Step 1: the sorted boundaries, without exact duplicates.
    final candidates =
        polynomial
            .solutions()
            .map((root) => root.real)
            .where((x) => x.isFinite)
            .toList()
          ..sort();
    final boundaries = candidates.indexed
        .where((e) => e.$1 == 0 || e.$2 != candidates[e.$1 - 1])
        .map((e) => e.$2)
        .toList(growable: false);

    // Step 2: the sign of P(x) on each boundary, where 0 means it's a root.
    final boundarySigns = boundaries
        .map((x) => _sign(coefficients, x, rootTolerance))
        .toList(growable: false);

    // Step 3: the sign of P(x) inside each region. There is one region more
    // than the number of boundaries.
    final regionSigns = _testPoints(boundaries)
        .map((x) => _sign(coefficients, x, roundingTolerance))
        .toList(growable: false);
    final mergedBoundaries = <double>[];
    final mergedBoundarySigns = <int>[];
    final mergedRegionSigns = <int>[regionSigns.first];

    var i = 0;
    while (i < boundaries.length) {
      var j = i;
      while (j + 1 < boundaries.length &&
          boundarySigns[j] == 0 &&
          boundarySigns[j + 1] == 0 &&
          regionSigns[j + 1] == 0) {
        ++j;
      }

      final cluster = boundaries.sublist(i, j + 1);
      mergedBoundaries.add(cluster.reduce((a, b) => a + b) / cluster.length);
      mergedBoundarySigns.add(boundarySigns[i]);
      mergedRegionSigns.add(regionSigns[j + 1]);
      i = j + 1;
    }

    // Step 4: the real line as a sequence of 'region, boundary, region, ...,
    // boundary, region' elements, where the even indices are regions and the
    // odd indices are boundaries.
    final holds = Iterable<bool>.generate(
      2 * mergedBoundaries.length + 1,
      (e) => _holds(
        e.isEven ? mergedRegionSigns[e ~/ 2] : mergedBoundarySigns[e ~/ 2],
      ),
    ).toList(growable: false);

    return _joinRuns(holds, mergedBoundaries);
  }

  /// One point inside each region delimited by [boundaries].
  static Iterable<double> _testPoints(List<double> boundaries) {
    if (boundaries.isEmpty) {
      return const [0];
    }

    return [
      boundaries.first - 1,
      ...Iterable<double>.generate(
        boundaries.length - 1,
        (i) => (boundaries[i] + boundaries[i + 1]) / 2,
      ),
      boundaries.last + 1,
    ];
  }

  /// The sign of P(x) (-1, 0 or 1), where P(x) is zero when
  /// `|P(x)| <= tolerance * S(x)`.
  static int _sign(List<double> coefficients, double x, double tolerance) {
    var value = 0.0;
    var size = 0.0;
    final absX = x.abs();

    for (final c in coefficients) {
      value = value * x + c;
      size = size * absX + c.abs();
    }

    if (value.abs() <= tolerance * size) {
      return 0;
    }

    return value > 0 ? 1 : -1;
  }

  /// Whether a value of P(x) with the given [sign] satisfies the inequality.
  bool _holds(int sign) => switch (inequalityType) {
    AlgebraicInequalityType.lessThan => sign < 0,
    AlgebraicInequalityType.lessThanOrEqualTo => sign <= 0,
    AlgebraicInequalityType.greaterThan => sign > 0,
    AlgebraicInequalityType.greaterThanOrEqualTo => sign >= 0,
  };

  /// Converts every maximal run of consecutive elements where the inequality
  /// [holds] into a solution.
  List<AlgebraicInequalitySolution> _joinRuns(
    List<bool> holds,
    List<double> boundaries,
  ) {
    final isInclusive =
        inequalityType == AlgebraicInequalityType.lessThanOrEqualTo ||
        inequalityType == AlgebraicInequalityType.greaterThanOrEqualTo;
    final last = holds.length - 1;
    final solutions = <AlgebraicInequalitySolution>[];

    var start = 0;
    while (start <= last) {
      if (!holds[start]) {
        ++start;
        continue;
      }

      var end = start;
      while (end < last && holds[end + 1]) {
        ++end;
      }

      final from = start == 0 ? null : boundaries[(start - 1) ~/ 2];
      final to = end == last ? null : boundaries[end ~/ 2];

      solutions.add(switch ((from, to)) {
        (null, null) => const AlgebraicInequalityAllRealNumbers(),
        (null, final double to) => AlgebraicInequalitySmallerThan(
          value: to,
          isInclusive: isInclusive,
        ),
        (final double from, null) => AlgebraicInequalityGreaterThan(
          value: from,
          isInclusive: isInclusive,
        ),
        (final double from, final double to) => AlgebraicInequalityInterval(
          start: from,
          end: to,
          isInclusive: isInclusive,
        ),
      });

      start = end + 1;
    }

    return solutions;
  }

  @override
  String toString() {
    return 'AlgebraicInequalitySolver(polynomial: $polynomial, '
        'inequalityType: $inequalityType, precision: $precision)';
  }
}
