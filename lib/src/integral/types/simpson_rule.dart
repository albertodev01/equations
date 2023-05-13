import 'package:equations/equations.dart';
import 'package:equations/src/utils/exceptions/types/numerical_integration_exception.dart';

/// The "Simpson rule" is a technique for approximating the value of a
/// definite integral.
///
/// This algorithm requires the [intervals] parameter, which indicates how many
/// partitions have to be computed by the algorithm.
///
/// Note that [intervals] must be an even number. If [intervals] is not even, a
/// [NumericalIntegrationException] object is thrown.
base class SimpsonRule extends NumericalIntegration {
  /// Creates a [SimpsonRule] object.
  ///
  /// By default, [intervals] is set to `32`.
  const SimpsonRule({
    required super.function,
    required super.lowerBound,
    required super.upperBound,
    super.intervals = 32,
  });

  @override
  ({List<double> guesses, double result}) integrate() {
    // Make sure to throw an exception if 'intervals' is odd.
    if (intervals % 2 != 0) {
      throw const NumericalIntegrationException(
        'There must be an even number of partitions.',
      );
    }

    // The 'step' of the algorithm.
    final h = (upperBound - lowerBound) / intervals;

    // Keeping track separately of the sums of the even and odd series.
    var oddSum = 0.0;
    var evenSum = 0.0;

    // The list containing the various guesses of the algorithm.
    final guesses = List<double>.filled(intervals, 0);

    // The first iteration.
    for (var i = 1; i < intervals; i += 2) {
      oddSum += evaluateFunction(lowerBound + i * h);
      guesses[i] = oddSum;
    }

    // The second iteration.
    for (var i = 2; i < intervals - 1; i += 2) {
      evenSum += evaluateFunction(lowerBound + i * h);
      guesses[i] = evenSum;
    }

    // Returning the result.
    final bounds = evaluateFunction(lowerBound) + evaluateFunction(upperBound);

    return (
      guesses: guesses,
      result: (bounds + (evenSum * 2) + (oddSum * 4)) * h / 3,
    );
  }
}
