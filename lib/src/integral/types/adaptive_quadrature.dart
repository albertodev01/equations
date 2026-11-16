import 'package:equations/equations.dart';

/// {@template adaptive_quadrature}
/// Adaptive quadrature is a technique for approximating the value of a
/// definite integral that automatically adjusts the step size based on the
/// local behavior of the function being integrated. This class implements the
/// adaptive Simpson's method.
///
/// ## Details
///
/// Unlike fixed-step methods such as [SimpsonRule] or [TrapezoidalRule],
/// adaptive quadrature:
///
/// - uses smaller step sizes in regions where the function varies rapidly;
/// - uses larger step sizes in regions where the function is smooth;
/// - automatically determines how to subdivide the integration interval;
/// - usually reaches a given accuracy with fewer function evaluations.
///
/// The algorithm first splits `[lowerBound, upperBound]` into a few
/// subintervals of different widths, so that the function isn't only sampled
/// at evenly spaced points (which could all be zeros of a periodic function,
/// for example). Then, on each subinterval, it:
///
/// 1. computes two Simpson's rule approximations, one with a single step and
///    one with two steps;
/// 2. compares their difference to a tolerance;
/// 3. if the difference is small enough, accepts the two-step approximation,
///    improved with Richardson extrapolation;
/// 4. if not, splits the subinterval in half and applies the method to both
///    halves, each with half of the tolerance.
///
/// The tolerance is relative to the size of the integral: the algorithm aims
/// for an error of at most about `10^-12` times an estimate of the integral of
/// `|f(x)|` on `[lowerBound, upperBound]`.
///
/// This approach makes adaptive quadrature particularly effective for functions
/// with varying smoothness or regions of high curvature.
///
/// Both [lowerBound] and [upperBound] must be finite. Each initial subinterval
/// is split at most [maxDepth] times. If the approximations don't converge by
/// then (for example, near a singularity such as `1/x` around `0`), or if the
/// function isn't finite somewhere in the interval, [integrate] throws a
/// [NumericalIntegrationException].
/// {@endtemplate}
final class AdaptiveQuadrature extends NumericalIntegration {
  /// {@macro adaptive_quadrature}
  const new({
    required super.function,
    required super.lowerBound,
    required super.upperBound,
  });

  /// The maximum number of times each initial subinterval can be split in
  /// half. After 50 splits, a subinterval is less than `10^-15` times as wide
  /// as the whole interval, which is close to the precision of a [double].
  static const maxDepth = 50;

  /// The relative tolerance of the algorithm, which is multiplied by an
  /// estimate of the integral of `|f(x)|` to get the absolute tolerance.
  static const _relativeTolerance = 1.0e-12;

  /// The smallest relative tolerance of a subinterval. Halving the tolerance
  /// at every split stops here, at a few times the precision of a [double].
  static const _minimumRelativeTolerance = 1.0e-15;

  /// The points that split `[0, 1]` into the initial subintervals, which have
  /// different widths. They are the fractional parts of `k * phi`, for
  /// `k = 1, ..., 5`, where `phi` is the golden ratio, in increasing order.
  static const _initialPartition = [
    0.090169943749475,
    0.23606797749979,
    0.47213595499958,
    0.618033988749895,
    0.854101966249685,
  ];

  /// Uses the "adaptive quadrature" algorithm to evaluate the integral between
  /// [a] and [b], where [fa], [fb] and [fc] are the values of the function at
  /// [a], [b] and at the midpoint of `[a, b]`.
  double _adaptive({
    required double a,
    required double b,
    required double fa,
    required double fb,
    required double fc,
    required double tolerance,
    required double minimumTolerance,
    required int depth,
    required List<double> guesses,
  }) {
    final h = b - a;
    final c = (a + b) / 2.0;
    final fd = evaluateFunction((a + c) / 2.0);
    final fe = evaluateFunction((b + c) / 2.0);

    final q1 = h / 6 * (fa + 4 * fc + fb);
    final q2 = h / 12 * (fa + 4 * fd + 2 * fc + 4 * fe + fb);

    if (!q1.isFinite || !q2.isFinite) {
      throw NumericalIntegrationException(
        'The function is not finite on the interval [$a, $b].',
      );
    }

    final difference = q2 - q1;

    if (difference.abs() <= 15 * tolerance) {
      final result = q2 + difference / 15;

      guesses.add(result);
      return result;
    }

    if (depth >= maxDepth) {
      throw NumericalIntegrationException(
        'The algorithm did not converge on the interval [$a, $b] after '
        '$maxDepth subdivisions.',
      );
    }

    final halfTolerance = tolerance / 2 > minimumTolerance
        ? tolerance / 2
        : minimumTolerance;

    final first = _adaptive(
      a: a,
      b: c,
      fa: fa,
      fb: fc,
      fc: fd,
      tolerance: halfTolerance,
      minimumTolerance: minimumTolerance,
      depth: depth + 1,
      guesses: guesses,
    );
    final second = _adaptive(
      a: c,
      b: b,
      fa: fc,
      fb: fb,
      fc: fe,
      tolerance: halfTolerance,
      minimumTolerance: minimumTolerance,
      depth: depth + 1,
      guesses: guesses,
    );

    return first + second;
  }

  /// {@macro numerical_integration.integrate}
  ///
  /// The `guesses` list contains the integral of each subinterval accepted by
  /// the algorithm, in order from [lowerBound] to [upperBound]. Its elements
  /// add up to `result` (up to rounding errors). If [lowerBound] is equal to
  /// [upperBound], the list is empty and `result` is `0`.
  ///
  /// Also throws a [NumericalIntegrationException] if the algorithm doesn't
  /// converge within [maxDepth] subdivisions, or if the function isn't finite
  /// somewhere in the interval.
  @override
  ({List<double> guesses, double result}) integrate() {
    if (!lowerBound.isFinite || !upperBound.isFinite) {
      throw const NumericalIntegrationException(
        'The integration bounds must be finite.',
      );
    }

    final width = upperBound - lowerBound;

    if (width == 0) {
      return (guesses: <double>[], result: 0.0);
    }

    final points = [
      lowerBound,
      ..._initialPartition.map((t) => lowerBound + t * width),
      upperBound,
    ];
    final values = points.map(evaluateFunction).toList(growable: false);

    // A rough estimate of the integral of |f(x)|, using the trapezoidal rule on
    // the initial subintervals. The tolerance is relative to this value.
    var scale = 0.0;
    for (var i = 0; i < points.length - 1; ++i) {
      final step = (points[i + 1] - points[i]).abs();
      scale += step * (values[i].abs() + values[i + 1].abs()) / 2;
    }

    if (!scale.isFinite) {
      throw NumericalIntegrationException(
        'The function is not finite on the interval [$lowerBound, '
        '$upperBound].',
      );
    }

    final reference = scale > 0 ? scale : 1;
    final tolerance = _relativeTolerance * reference;
    final minimumTolerance = _minimumRelativeTolerance * reference;

    final guesses = <double>[];
    var result = 0.0;

    for (var i = 0; i < points.length - 1; ++i) {
      final a = points[i];
      final b = points[i + 1];

      result += _adaptive(
        a: a,
        b: b,
        fa: values[i],
        fb: values[i + 1],
        fc: evaluateFunction((a + b) / 2.0),
        tolerance: tolerance * ((b - a) / width).abs(),
        minimumTolerance: minimumTolerance,
        depth: 0,
        guesses: guesses,
      );
    }

    return (
      guesses: guesses,
      result: result,
    );
  }
}
