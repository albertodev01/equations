import 'package:equations/equations.dart';

/// {@template trapezoidal_rule}
/// The trapezoidal rule is a numerical integration technique for approximating
/// definite integrals using linear interpolation. Given the integral of f(x)
/// from a to b, the trapezoidal rule approximates it as:
///
///   (h/2) * [f(x_0) + 2f(x_1) + 2f(x_2) + ... + 2f(x_(n-1)) + f(x_n)]
///
/// where:
/// - h = (b - a) / n is the step size
/// - x_i = a + i*h for i = 0, 1, 2, ..., n
/// - n is the number of intervals
///
/// The trapezoidal rule has an error of O(h^2), meaning the error
/// decreases quadratically as the number of intervals increases. The method is
/// exact for linear functions and provides good accuracy for smooth functions.
///
/// This algorithm requires the [intervals] parameter, which indicates how many
/// partitions must be computed by the algorithm. The larger the number of
/// intervals, the better the approximation (but at increased computational
/// cost).
/// {@endtemplate}
base class TrapezoidalRule extends IntervalsIntegration {
  /// {@macro trapezoidal_rule}
  ///
  /// By default, [intervals] is set to `20`. For most applications, this
  /// provides a good balance between accuracy and computational cost.
  const new({
    required super.function,
    required super.lowerBound,
    required super.upperBound,
    super.intervals = 20,
  });

  /// {@macro numerical_integration.integrate}
  ///
  /// The `guesses` list contains the values of [function] at the points
  /// `x_i = lowerBound + i * h`, for `i = 0, 1, ..., intervals`, so it has
  /// `intervals + 1` elements.
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

    final h = (upperBound - lowerBound) / intervals;
    final guesses = List<double>.filled(intervals + 1, 0);
    final fLower = evaluateFunction(lowerBound);
    final fUpper = evaluateFunction(upperBound);

    guesses[0] = fLower;
    guesses[intervals] = fUpper;

    var interiorSum = 0.0;
    for (var i = 1; i < intervals; ++i) {
      final x = lowerBound + i * h;
      final fx = evaluateFunction(x);
      interiorSum += fx;
      guesses[i] = fx;
    }

    return (
      guesses: guesses,
      result: (fLower + 2 * interiorSum + fUpper) * h / 2,
    );
  }
}
