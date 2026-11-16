import 'package:equations/equations.dart';

/// {@template gauss_legendre_rule}
/// The Gauss-Legendre rule is a numerical integration technique that splits
/// the integration interval into subintervals and, on each of them, evaluates
/// the function at the roots of a Legendre polynomial (the Gauss points),
/// multiplied by specific weights.
///
/// The Gauss points are strictly inside each subinterval, so the function is
/// never evaluated at [lowerBound] or [upperBound]. For this reason, this
/// method also works when the function isn't finite at the bounds (such as
/// `1/sqrt(x)` on `[0, 1]`), although it converges slowly in that case.
///
/// This algorithm requires the [intervals] parameter, which must be positive,
/// and the [points] parameter, which must be between 1 and 5.
/// {@endtemplate}
base class GaussLegendreRule extends IntervalsIntegration {
  /// {@macro gauss_legendre_rule}
  ///
  /// By default, [intervals] is set to `10` and [points] is set to `3`, so the
  /// function is evaluated 30 times.
  const new({
    required super.function,
    required super.lowerBound,
    required super.upperBound,
    super.intervals = 10,
    this.points = 3,
  });

  /// The number of Gauss points in each subinterval, between 1 and 5.
  final int points;

  /// The points and the weights of the Gauss-Legendre rules on `[-1, 1]`, in
  /// increasing order of the points. The element at index `k - 1` is the rule
  /// with `k` points.
  static const _rules = <List<(double, double)>>[
    [(0.0, 2.0)],
    [
      (-0.5773502691896258, 1.0),
      (0.5773502691896258, 1.0),
    ],
    [
      (-0.7745966692414834, 0.5555555555555556),
      (0.0, 0.8888888888888888),
      (0.7745966692414834, 0.5555555555555556),
    ],
    [
      (-0.8611363115940526, 0.34785484513745385),
      (-0.3399810435848563, 0.6521451548625462),
      (0.3399810435848563, 0.6521451548625462),
      (0.8611363115940526, 0.34785484513745385),
    ],
    [
      (-0.906179845938664, 0.23692688505618908),
      (-0.5384693101056831, 0.47862867049936647),
      (0.0, 0.5688888888888889),
      (0.5384693101056831, 0.47862867049936647),
      (0.906179845938664, 0.23692688505618908),
    ],
  ];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is GaussLegendreRule) {
      return super == other && points == other.points;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(super.hashCode, points);

  @override
  String toString() => '${super.toString()} with $points points each';

  /// {@macro numerical_integration.integrate}
  ///
  /// The `guesses` list contains the values of [function] at the Gauss points
  /// of each subinterval, in order from [lowerBound] to [upperBound], so it
  /// has `intervals * points` elements.
  ///
  /// Also throws a [NumericalIntegrationException] if [intervals] is not
  /// positive, or if [points] is not between 1 and 5.
  @override
  ({List<double> guesses, double result}) integrate() {
    if (!lowerBound.isFinite || !upperBound.isFinite) {
      throw const NumericalIntegrationException(
        'The integration bounds must be finite.',
      );
    }
    if (intervals <= 0) {
      throw const NumericalIntegrationException(
        'The number of intervals must be positive.',
      );
    }
    if (points < 1 || points > _rules.length) {
      throw NumericalIntegrationException(
        'The number of points must be between 1 and ${_rules.length}.',
      );
    }

    final h = (upperBound - lowerBound) / intervals;
    final rule = _rules[points - 1];
    final guesses = List<double>.filled(intervals * points, 0);
    var sum = 0.0;

    for (var i = 0; i < intervals; ++i) {
      final midpoint = lowerBound + (i + 0.5) * h;
      for (var j = 0; j < points; ++j) {
        final (point, weight) = rule[j];
        final fx = evaluateFunction(midpoint + point * h / 2);
        sum += weight * fx;
        guesses[i * points + j] = fx;
      }
    }

    return (
      guesses: guesses,
      result: sum * h / 2,
    );
  }
}
