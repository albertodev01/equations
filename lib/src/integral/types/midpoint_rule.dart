import 'package:equations/equations.dart';

/// The "midpoint rule" is a technique for approximating the value of a
/// definite integral.
///
/// This algorithm requires the [intervals] parameter, which indicates how many
/// partitions have to be computed by the algorithm.
///
/// The midpoint rule estimates a definite integral using a Riemann sum with
/// sub-intervals of equal width.
base class MidpointRule extends NumericalIntegration {
  /// Creates a [MidpointRule] object.
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
    // The 'step' of the algorithm.
    final h = (upperBound - lowerBound) / intervals;

    // This variable will keep track of the actual result.
    var integralResult = 0.0;

    // The list containing the various guesses of the algorithm.
    final guesses = List<double>.generate(
      intervals,
      (index) {
        final midpoint = lowerBound + h / 2;
        final guess = evaluateFunction(midpoint + index * h);
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
