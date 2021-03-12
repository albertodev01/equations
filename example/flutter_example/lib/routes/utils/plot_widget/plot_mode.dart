import 'package:equatable/equatable.dart';
import 'package:equations/equations.dart';

abstract class PlotMode<T> extends Equatable {
  final T equation;
  const PlotMode(this.equation);

  double evaluateOn(double x);

  @override
  List<Object?> get props => [
        equation,
      ];
}

class PolynomialPlot extends PlotMode<Algebraic> {
  const PolynomialPlot({required Algebraic algebraic}) : super(algebraic);

  @override
  double evaluateOn(double x) => equation.realEvaluateOn(x).real;
}

class NonlinearPlot extends PlotMode<NonLinear> {
  const NonlinearPlot({required NonLinear nonLinear}) : super(nonLinear);

  @override
  double evaluateOn(double x) => equation.evaluateOn(x) as double;
}
