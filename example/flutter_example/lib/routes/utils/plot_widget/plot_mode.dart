import 'package:equations/equations.dart';

/// This class provides the ability to evaluate a function on a given point. The
/// [equation] dependency defines the behavior of [evaluateOn].
abstract class PlotMode<T> {
  /// The equation object that defines the [evaluateOn] method.
  final T equation;

  /// Creates an instance of [PlotMode].
  const PlotMode(this.equation);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is PlotMode<T>) {
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
class PolynomialPlot extends PlotMode<Algebraic> {
  /// Creates an instance of [PolynomialPlot].
  const PolynomialPlot({
    required Algebraic algebraic,
  }) : super(algebraic);

  @override
  double evaluateOn(double x) => equation.realEvaluateOn(x).real;
}

/// Nonlinear functions evaluator.
class NonlinearPlot extends PlotMode<NonLinear> {
  /// Creates an instance of [NonlinearPlot].
  const NonlinearPlot({
    required NonLinear nonLinear,
  }) : super(nonLinear);

  @override
  double evaluateOn(double x) => equation.evaluateOn(x) as double;
}

/// Integral functions evaluator.
class IntegralPlot extends PlotMode<NumericalIntegration> {
  /// Creates an instance of [IntegralPlot].
  const IntegralPlot({
    required NumericalIntegration function,
  }) : super(function);

  @override
  double evaluateOn(double x) => equation.evaluateFunction(x);
}
