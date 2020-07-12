import 'dart:math' as math;

import 'package:equations/src/common/results.dart';
import 'package:math_expressions/math_expressions.dart';

/// Abstract class that represents a _nonlinear_ equation which can be solved
/// with a particular root-finding algorithm. No complex numbers are allowed.
///
/// The so called "_root-finding algorithms_" are iterative methods that start
/// from an initial value (or a couple of values) and try to build a scalar
/// succession that converges as much as possible to the root.
///
/// Each subclass of [NonLinear.solve] has to define the method s which builds
/// the scalar succession.
abstract class NonLinear {
  /// The equation to be solved
  final String _function;

  /// The accuracy of the algorithm
  final double _tolerance;

  /// The maximum steps to be made by the algorithm
  final int _maxSteps;

  /// The expression parser for the function
  final Expression _expression;

  /// The expression parser for the derivative of the function
  final Expression _expressionDerivative;

  /// The 'x' variable
  static final _x = Variable('x');

  /// Creates a new instance of a nonlinear equation solver which asks for:
  ///
  ///  - the expression [expression] to be solved
  ///  - the accuracy [tolerance] of the root-finding algorithm
  ///  - the maximum iterations [maxSteps] the algorithm has to do
  NonLinear(this._function, this._tolerance, this._maxSteps)
      : _expression = Parser().parse(_function.trim()),
        _expressionDerivative = Parser().parse(_function.trim()).derive('x');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NonLinear &&
          runtimeType == other.runtimeType &&
          _function == other._function &&
          _tolerance == other._tolerance &&
          _maxSteps == other._maxSteps;

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + _function.hashCode;
    result = 37 * result + _tolerance.hashCode;
    result = 37 * result + _maxSteps.hashCode;
    return result;
  }

  @override
  String toString() {
    final sb = StringBuffer()
      ..write("Expression: ")
      ..writeln(_function)
      ..write("Tolerance: ")
      ..writeln(_tolerance)
      ..write("Maximum steps: ")
      ..write(_maxSteps);

    return sb.toString();
  }

  /// In order to get a meaningful result, it makes sense to compute the rate of
  /// convergence only if the algorithm made _at least_ 3 iterations.
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
  ///  - _efficiency = convergenceRate <sup>1 / max_steps</sup>_
  double efficiency(List<double> guesses, int steps) {
    final c = convergence(guesses, steps);
    return math.pow(c, 1.0 / steps) as double;
  }

  /// Evaluates the function on the given _x_ value
  double evaluateOn(double x) {
    final cm = ContextModel()..bindVariable(_x, Number(x));

    return _expression.evaluate(EvaluationType.REAL, cm) as double;
  }

  /// Evaluates the derivative of the function on the given _x_ value
  double evaluateDerivativeOn(double x) {
    final cm = ContextModel()..bindVariable(_x, Number(x));

    return _expressionDerivative.evaluate(EvaluationType.REAL, cm) as double;
  }

  /// The function f(x) for which the algorithm has to find a solution
  String get function => _function;

  /// The accuracy of the algorithm
  double get tolerance => _tolerance;

  /// The maximum steps to be made by the algorithm
  int get maxSteps => _maxSteps;

  /// Returns a [NonlinearResults] object which contains the data calculated by
  /// the root-finding algorithm.
  Future<NonlinearResults> solve();
}
