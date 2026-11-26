import 'package:equations/equations.dart';

/// {@template midpoint_rule}
/// The midpoint rule is a numerical integration technique for approximating
/// definite integrals using Riemann sums. Given the integral of f(x) from a to
/// b, the midpoint rule approximates it as:
///
///   h * [f(x_0) + f(x_1) + ... + f(x_(n-1))]
///
/// where:
/// - h = (b - a) / n is the step size
/// - x_i = a + h/2 + i*h is the midpoint of the i-th subinterval
/// - n is the number of intervals
///
/// Like the trapezoidal rule, the midpoint rule has an error of O(h^2) and is
/// exact for linear functions. However, for smooth functions, its error is
/// about half as large as the error of the trapezoidal rule. The error
/// decreases as the number of intervals increases.
///
/// This algorithm requires the [intervals] parameter, which indicates how many
/// partitions must be computed by the algorithm. It must be positive.
/// {@endtemplate}
base class MidpointRule extends IntervalsIntegration {
  /// {@macro midpoint_rule}
  ///
  /// By default, [intervals] is set to `30`.
  const new({
    required super.function,
    required super.lowerBound,
    required super.upperBound,
    super.intervals = 30,
  });

  /// {@macro numerical_integration.integrate}
  ///
  /// The `guesses` list contains the values of [function] at the midpoint of
  /// each subinterval, so it has [intervals] elements.
  ///
  /// Also throws a [NumericalIntegrationException] if [intervals] is not
  /// positive.
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

    var integralResult = 0.0;
    final h = (upperBound - lowerBound) / intervals;
    final guesses = List<double>.generate(
      intervals,
      (index) {
        final midpoint = lowerBound + h / 2 + index * h;
        final guess = evaluateFunction(midpoint);
        integralResult += guess;

        return guess;
      },
      growable: false,
    );

    return (
      guesses: guesses,
      result: integralResult * h,
    );
  }
}
