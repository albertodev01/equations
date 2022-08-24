import 'package:equations/equations.dart';

/// The "midpoint rule" is a technique for approximating the value of a
/// definite integral.
///
/// This algorithm requires a parameter `m` which indicates how many partitions
/// have to be computed by the algorithm. The midpoint rule estimates a definite
/// integral using a Riemann sum with sub-intervals of equal width.
class MidpointRule extends NumericalIntegration {
  /// Expects the [function] to be integrated ad the integration bounds
  /// ([lowerBound] and [upperBound]).
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
    // The 'step' of the algorithm
    final h = (upperBound - lowerBound) / intervals;

    // This variable will keep track of the actual result
    var integralResult = 0.0;

    // The list containing the various guesses of the algorithm
    final guesses = List<double>.filled(intervals, 0);

    // The actual algorithm
    for (var i = 0; i < intervals; ++i) {
      final midpoint = lowerBound + h / 2;
      final guess = evaluateFunction(midpoint + i * h);

      integralResult += guess;
      guesses[i] = guess;
    }

    return IntegralResults(
      guesses: guesses,
      result: integralResult * h,
    );
  }
}
