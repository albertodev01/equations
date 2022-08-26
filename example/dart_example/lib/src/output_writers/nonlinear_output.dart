import 'dart:io';

import 'package:equation_solver_cli/src/output_writers/output.dart';
import 'package:equations/equations.dart';

/// Solves a nonlinear equation using various root-finding algorithms.
class NonlinearOutput extends Output {
  /// Creates an [NonlinearOutput] object.
  const NonlinearOutput();

  @override
  void processOutput() {
    const equation = 'x^3-cos(x)';

    // Root finding algorithms - single point
    final newton = const Newton(function: equation, x0: 1).solve();
    final steffensen = const Steffensen(function: equation, x0: 1).solve();

    // Root finding algorithms - bracketing
    final bisection = const Bisection(function: equation, a: 0.5, b: 1).solve();
    final brent = const Brent(function: equation, a: 0.5, b: 1).solve();
    final chords = const Chords(function: equation, a: 0.5, b: 1).solve();
    final riddler = const Riddler(function: equation, a: 0.5, b: 1).solve();
    final regulaFalsi =
        const RegulaFalsi(function: equation, a: 0.5, b: 1).solve();

    final output = StringBuffer()
      ..write(' > Equation: ')
      ..writeln(equation)
      ..writeln("\n  --- Newton's method --- ")
      ..write(' > Root: ')
      ..writeln(newton.guesses.last)
      ..write(' > Convergence: ')
      ..writeln(newton.convergence)
      ..write(' > Efficiency: ')
      ..writeln(newton.efficiency)
      ..writeln("\n  --- Steffensen's method --- ")
      ..write(' > Root: ')
      ..writeln(steffensen.guesses.last)
      ..write(' > Convergence: ')
      ..writeln(steffensen.convergence)
      ..write(' > Efficiency: ')
      ..writeln(steffensen.efficiency)
      ..writeln('\n  --- Bisection method --- ')
      ..write(' > Root: ')
      ..writeln(bisection.guesses.last)
      ..write(' > Convergence: ')
      ..writeln(bisection.convergence)
      ..write(' > Efficiency: ')
      ..writeln(bisection.efficiency)
      ..writeln("\n  --- Brent's method --- ")
      ..write(' > Root: ')
      ..writeln(brent.guesses.last)
      ..write(' > Convergence: ')
      ..writeln(brent.convergence)
      ..write(' > Efficiency: ')
      ..writeln(brent.efficiency)
      ..writeln("\n  --- Riddler's method --- ")
      ..write(' > Root: ')
      ..writeln(riddler.guesses.last)
      ..write(' > Convergence: ')
      ..writeln(riddler.convergence)
      ..write(' > Efficiency: ')
      ..writeln(riddler.efficiency)
      ..writeln('\n  --- Chord method --- ')
      ..write(' > Root: ')
      ..writeln(chords.guesses.last)
      ..write(' > Convergence: ')
      ..writeln(chords.convergence)
      ..write(' > Efficiency: ')
      ..writeln(chords.efficiency)
      ..writeln('\n  --- Regula falsi method --- ')
      ..write(' > Root: ')
      ..writeln(regulaFalsi.guesses.last)
      ..write(' > Convergence: ')
      ..writeln(regulaFalsi.convergence)
      ..write(' > Efficiency: ')
      ..writeln(regulaFalsi.efficiency);

    stdout
      ..writeln('===== NONLINEAR EQUATIONS =====\n')
      ..writeln(output.toString());
  }
}
