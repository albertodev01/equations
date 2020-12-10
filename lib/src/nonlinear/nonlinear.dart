import 'dart:math' as math;

import 'package:equations/equations.dart';

/// Abstract class representing a **nonlinear** equation which can be solved
/// with a particular root-finding algorithm. No complex numbers are allowed.
///
/// The so called "**root-finding algorithms**" are iterative methods that start
/// from an initial value (or a couple of values) and try to build a scalar
/// succession that converges as much as possible to the root.
///
/// Each subclass of [NonLinear] has to define the [solve] method which is required
/// in order to build the scalar succession with a certain logic.
abstract class NonLinear {
  /// The function f(x) for which the algorithm has to find a solution
  final String function;

  /// The accuracy of the algorithm
  final double tolerance;

  /// The maximum steps to be made by the algorithm
  final int maxSteps;

  /// Creates a new instance of a nonlinear equation solver which asks for:
  ///
  ///  - the expression [function] to be solved
  ///  - the accuracy [tolerance] of the root-finding algorithm
  ///  - the maximum iterations [maxSteps] the algorithm has to do
  const NonLinear(
      {required this.function,
      required this.tolerance,
      required this.maxSteps});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is NonLinear) {
      return runtimeType == other.runtimeType &&
          function == other.function &&
          tolerance == other.tolerance &&
          maxSteps == other.maxSteps;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + function.hashCode;
    result = 37 * result + tolerance.hashCode;
    result = 37 * result + maxSteps.hashCode;
    return result;
  }

  @override
  String toString() => "f(x) = $function";

  /// In order to get a meaningful result, it makes sense to compute the rate of
  /// convergence only if the algorithm made **at least** 3 iterations.
  double convergence(List<double> guesses, int steps) {
    final size = guesses.length - 1;

    if (size >= 3) {
      final num = (guesses[size] - guesses[size - 1]).abs() /
          (guesses[size - 1] - guesses[size - 2]).abs();
      final den = (guesses[size - 1] - guesses[size - 2]).abs() /
          (guesses[size - 2] - guesses[size - 3]).abs();

      return math.log(num) / math.log(den);
    }

    return double.nan;
  }

  /// The efficiency is evaluated only if the convergence is not [double.nan].
  /// The formula is:
  ///
  ///  - efficiency = convergenceRate <sup>1 / max_steps</sup>
  double efficiency(List<double> guesses, int steps) {
    final c = convergence(guesses, steps);
    return math.pow(c, 1.0 / steps) as double;
  }

  /// Evaluates the function on the given [x] value
  num evaluateOn(double x) {
    const evaluator = ExpressionParser();
    return evaluator.evaluateOn(function, x);
  }

  /// Evaluates the derivative of the function on the given [x] value
  num evaluateDerivativeOn(double x) {
    final h = math.pow(1.0e-15, 1 / 3) * x;

    final upper = evaluateOn(x + h);
    final lower = evaluateOn(x - h);

    return (upper - lower) / (2 * h);
  }

  /// Returns a [NonlinearResults] object which contains the data calculated by
  /// the root-finding algorithm.
  Future<NonlinearResults> solve();
}
