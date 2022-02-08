import 'dart:io';

import 'package:equation_solver_cli/src/output_writers/output.dart';
import 'package:equations/equations.dart';

/// Evaluates an integral using various algorithms.
class IntegralOutput implements Output {
  /// Creates an [IntegralOutput] object.
  const IntegralOutput();

  @override
  void processOutput() {
    const equation = 'x^5-tan(1-x)';

    // Integral evaluation algorithms
    final simpson = SimpsonRule(
      function: equation,
      lowerBound: 0.5,
      upperBound: 2,
    ).integrate();
    final midpoint = MidpointRule(
      function: equation,
      lowerBound: 0.5,
      upperBound: 2,
    ).integrate();
    final trapezoidal = TrapezoidalRule(
      function: equation,
      lowerBound: 0.5,
      upperBound: 2,
    ).integrate();

    final output = StringBuffer()
      ..write(' > Equation: ')
      ..writeln(equation)
      ..writeln("\n  --- Simpson's method --- ")
      ..write(' > Evaluation: ')
      ..writeln(simpson.result)
      ..write(' > Steps: ')
      ..writeln(simpson.guesses.length)
      ..writeln('\n  --- Midpoint rule --- ')
      ..write(' > Evaluation: ')
      ..writeln(midpoint.result)
      ..write(' > Steps: ')
      ..writeln(midpoint.guesses.length)
      ..writeln('\n  --- Trapezoidal rule --- ')
      ..write(' > Evaluation: ')
      ..writeln(trapezoidal.result)
      ..write(' > Steps: ')
      ..writeln(trapezoidal.guesses.length);

    stdout
      ..writeln('===== INTEGRALS EVALUATION =====\n')
      ..writeln(output.toString());
  }
}
