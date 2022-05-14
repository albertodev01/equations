import 'package:equations/equations.dart';

/// When it comes to analysis, the term **numerical integration** indicates a
/// group of algorithms for calculating the numerical value of a definite
/// integral on an interval.
///
/// Numerical integration algorithms compute an approximate solution to a
/// definite integral with a certain degree of accuracy. This package contains
/// the following algorithms:
///
///  - [MidpointRule]
///  - [SimpsonRule]
///  - [TrapezoidalRule]
///
/// The function must be continuous in the [`lowerBound`, `upperBound`] interval.
abstract class NumericalIntegration {
  /// Internal functions evaluator.
  static const _evaluator = ExpressionParser();

  /// The function to be integrated on the given interval.
  final String function;

  /// The lower bound of the integral.
  final double lowerBound;

  /// The upper bound of the integral.
  final double upperBound;

  /// The number of parts in which the interval [lowerBound, upperBound] has to
  /// be split by the algorithm.
  final int intervals;

  /// Expects the [lowerBound] and [upperBound] of the integral.
  const NumericalIntegration({
    required this.function,
    required this.lowerBound,
    required this.upperBound,
    required this.intervals,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is NumericalIntegration) {
      return runtimeType == other.runtimeType &&
          function == other.function &&
          intervals == other.intervals &&
          lowerBound == other.lowerBound &&
          upperBound == other.upperBound;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = 17;

    result = result * 37 + function.hashCode;
    result = result * 37 + intervals.hashCode;
    result = result * 37 + lowerBound.hashCode;
    result = result * 37 + upperBound.hashCode;

    return result;
  }

  @override
  String toString() {
    final lower = lowerBound.toStringAsFixed(2);
    final upper = upperBound.toStringAsFixed(2);

    return '$function on [$lower, $upper]\nUsing $intervals intervals';
  }

  /// Evaluates the given [function] on the [x] point.
  double evaluateFunction(double x) => _evaluator.evaluateOn(function, x);

  /// Calculates the numerical value of the [function] **definite** integral
  /// between [lowerBound] and [upperBound].
  IntegralResults integrate();
}
