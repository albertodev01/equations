import 'dart:io';
import 'dart:math';

import 'package:equation_solver_cli/src/output_writers/output.dart';
import 'package:equations/equations.dart';

/// Solves a polynomial equation whose degree and coefficients are randomly
/// generated each time.
class PolynomialOutput implements Output {
  /// Creates an [PolynomialOutput] object.
  const PolynomialOutput();

  @override
  void processOutput() {
    final random = Random();

    // Random degree
    final degree = random.nextInt(4) + 2;

    // Random coefficients
    final coefficients = <double>[];

    for (var i = 0; i < degree; ++i) {
      final sign = random.nextInt(1).isEven ? -1.0 : 1.0;

      // The first coefficient cannot be zero
      if (i == 0) {
        coefficients.add(random.nextInt(5) + 1);
      } else {
        coefficients.add(random.nextInt(10) * sign);
      }
    }

    // Printing the results
    final polynomial = Algebraic.fromReal(coefficients);
    final output = StringBuffer()
      ..write(' > Equation: ')
      ..writeln(polynomial)
      ..write(' > Degree: ')
      ..writeln(polynomial.degree)
      ..write(' > Derivative: ')
      ..writeln(polynomial.derivative())
      ..write(' > Discriminant: ')
      ..writeln(polynomial.discriminant())
      ..write(' > Roots: ')
      ..writeln(polynomial.solutions());

    stdout
      ..writeln('===== POLYNOMIAL EQUATIONS =====\n')
      ..writeln(output.toString());
  }
}
