import 'package:equations/equations.dart';

/// The "trapezoidal rule" is a technique for approximating the value of a
/// definite integral.
///
/// This algorithm requires the [intervals] parameter, which indicates how many
/// partitions have to be computed by the algorithm.
///
/// The bigger the value of [intervals], the better the result approximation.
base class TrapezoidalRule extends NumericalIntegration {
  /// Creates a [TrapezoidalRule] object.
  ///
  /// By default, [intervals] is set to `20`.
  const TrapezoidalRule({
    required super.function,
    required super.lowerBound,
    required super.upperBound,
    super.intervals = 20,
  });

  @override
  ({List<double> guesses, double result}) integrate() {
    // The 'step' of the algorithm.
    final h = (upperBound - lowerBound) / intervals;

    // The initial approximation of the result.
    var integralResult =
        evaluateFunction(lowerBound) + evaluateFunction(upperBound);

    // The list containing the various guesses of the algorithm.
    final guesses = List<double>.filled(intervals, 0);

    // The actual algorithm.
    for (var i = 0; i < intervals; ++i) {
      final x = lowerBound + i * h;

      integralResult += 2 * evaluateFunction(x);
      guesses[i] = integralResult;
    }

    return (
      guesses: guesses,
      result: integralResult * h / 2,
    );
  }
}
