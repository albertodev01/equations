import 'package:equations/equations.dart';

/// {@template numerical_integration}
/// In numerical analysis, the term **numerical integration** refers to a group
/// of algorithms that calculate the numerical value of a definite integral on
/// an interval.
///
/// Numerical integration algorithms compute an approximate value of a definite
/// integral with a certain degree of accuracy. `NumericalIntegration` is the
/// direct supertype of:
///
///  1. [IntervalsIntegration], the base class of the algorithms that split the
///    integration interval into subintervals.
///
///  2. [AdaptiveQuadrature], which uses the "adaptive quadrature" algorithm to
///    evaluate the integral.
///
/// Both bounds must be finite, and the function should be continuous on the
/// interval `[lowerBound, upperBound]`.
/// {@endtemplate}
abstract base class NumericalIntegration {
  /// {@macro numerical_integration}
  const new({
    required this.function,
    required this.lowerBound,
    required this.upperBound,
  });

  /// Internal function evaluator.
  static const _evaluator = ExpressionParser();

  /// The function to integrate, written as an expression in the `x` variable
  /// (for example, `'sin(x)*e^x'`). It is evaluated by [ExpressionParser].
  final String function;

  /// The lower bound of the integral.
  final double lowerBound;

  /// The upper bound of the integral.
  final double upperBound;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is NumericalIntegration) {
      return runtimeType == other.runtimeType &&
          function == other.function &&
          lowerBound == other.lowerBound &&
          upperBound == other.upperBound;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(
    function,
    lowerBound,
    upperBound,
  );

  @override
  String toString() {
    final lower = lowerBound.toStringAsFixed(2);
    final upper = upperBound.toStringAsFixed(2);

    return '$function on [$lower, $upper]';
  }

  /// Evaluates [function] at [x].
  ///
  /// Throws an [ExpressionParserException] if [function] cannot be parsed.
  double evaluateFunction(double x) => _evaluator.evaluateOn(function, x);

  /// {@template numerical_integration.integrate}
  /// Calculates the numerical value of the definite integral of [function]
  /// between [lowerBound] and [upperBound]. Returns a record whose fields are:
  ///
  ///  - `guesses`, the values computed by the algorithm to get the result.
  ///    Their meaning depends on the algorithm: interval-based methods store
  ///    the values of [function] at the points they sample, while
  ///    [AdaptiveQuadrature] stores the integral of each subinterval it
  ///    accepts;
  ///
  ///  - `result`, the approximate value of the integral on the interval
  ///    `[lowerBound, upperBound]`.
  ///
  /// If [lowerBound] is greater than [upperBound], the sign of the result is
  /// reversed, as in the standard convention for definite integrals.
  ///
  /// Throws a [NumericalIntegrationException] if [lowerBound] or [upperBound]
  /// is not finite.
  /// {@endtemplate}
  ({List<double> guesses, double result}) integrate();
}
