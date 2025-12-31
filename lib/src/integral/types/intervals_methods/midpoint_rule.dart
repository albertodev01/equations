import 'package:equations/equations.dart';

/// {@template midpoint_rule}
/// The midpoint rule is a numerical integration technique for approximating
/// definite integrals using Riemann sums. Given a definite integral in the
/// form ∫`[a,b]` f(x) dx, the midpoint rule approximates it as:
///
///   ∫`[a,b]` f(x) dx ≈ h * Σ`[i=0 to n-1]` f(xᵢ)
///
/// where:
/// - h = (b - a) / n is the step size
/// - xᵢ = a + h/2 + i*h is the midpoint of the i-th subinterval
/// - n is the number of intervals
///
/// The midpoint rule has an error bound of O(h^2), making it more accurate than
/// the trapezoidal rule for many functions. The error decreases as the number
/// of intervals increases.
///
/// This algorithm requires the [intervals] parameter, which indicates how many
/// partitions must be computed by the algorithm.
/// {@endtemplate}
base class MidpointRule extends IntervalsIntegration {
  /// {@macro midpoint_rule}
  ///
  /// By default, [intervals] is set to `30`.
  const MidpointRule({
    required super.function,
    required super.lowerBound,
    required super.upperBound,
    super.intervals = 30,
  });

  @override
  ({List<double> guesses, double result}) integrate() {
    // The step size of the algorithm.
    final h = (upperBound - lowerBound) / intervals;

    // This variable will keep track of the actual result.
    var integralResult = 0.0;

    // The list containing the various guesses of the algorithm.
    final guesses = List<double>.generate(
      intervals,
      (index) {
        // Calculate the midpoint of the i-th subinterval
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
