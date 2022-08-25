import 'package:equations/equations.dart';

/// The "midpoint rule" is a technique for approximating the value of a
/// definite integral.
///
/// This algorithm requires the `m` parameter which indicates how many
/// partitions have to be computed by the algorithm.
///
/// The midpoint rule estimates a definite integral using a Riemann sum with
/// sub-intervals of equal width.
class MidpointRule extends NumericalIntegration {
  /// Expects the [function] to be integrated and the integration bounds
  /// ([lowerBound], [upperBound]).
  ///
  /// The [intervals] variable represents the number of parts in which the
  /// `[lowerBound, upperBound]` interval has to be split by the algorithm.
  const MidpointRule({
    required super.function,
    required super.lowerBound,
    required super.upperBound,
    super.intervals = 30,
  });

  @override
  IntegralResults integrate() {
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

    return IntegralResults(
      guesses: guesses,
      result: integralResult * h,
    );
  }
}
