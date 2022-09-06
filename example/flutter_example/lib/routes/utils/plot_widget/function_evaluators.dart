import 'package:equations/equations.dart';

/// This class provides the ability to evaluate a function on a given point. The
/// [equation] dependency defines the behavior of [evaluateOn].
abstract class FunctionEvaluator<T> {
  /// The equation object that defines the [evaluateOn] method.
  final T equation;

  /// Creates an instance of [FunctionEvaluator].
  const FunctionEvaluator(this.equation);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is FunctionEvaluator<T>) {
      return runtimeType == other.runtimeType && equation == other.equation;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => equation.hashCode;

  /// Evaluates the [equation] on the specified real number [x].
  double evaluateOn(double x);
}

/// Polynomial functions evaluator.
class PolynomialEvaluator extends FunctionEvaluator<Algebraic> {
  /// Creates an instance of [PolynomialEvaluator].
  const PolynomialEvaluator({
    required Algebraic algebraic,
  }) : super(algebraic);

  @override
  double evaluateOn(double x) => equation.realEvaluateOn(x).real;
}

/// Nonlinear functions evaluator.
class NonlinearEvaluator extends FunctionEvaluator<NonLinear> {
  /// Creates an instance of [NonlinearEvaluator].
  const NonlinearEvaluator({
    required NonLinear nonLinear,
  }) : super(nonLinear);

  @override
  double evaluateOn(double x) => equation.evaluateOn(x) as double;
}

/// Integral functions evaluator.
class IntegralEvaluator extends FunctionEvaluator<NumericalIntegration> {
  /// Creates an instance of [IntegralEvaluator].
  const IntegralEvaluator({
    required NumericalIntegration function,
  }) : super(function);

  @override
  double evaluateOn(double x) => equation.evaluateFunction(x);
}
