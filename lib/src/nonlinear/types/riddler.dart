import 'dart:math';

import 'package:equations/equations.dart';

/// Implements the Riddler's method to find the roots of a given equation.
///
/// **Characteristics**:
///
///   - The method requires the root to be bracketed between two points `a` and
///   `b` otherwise it won't work.
///
///   - The rate of convergence is `sqrt(2)` and the convergence is guaranteed
///   for not we--behaved functions.
class Riddler extends NonLinear {
  /// The starting point of the interval.
  final double a;

  /// The ending point of the interval.
  final double b;

  /// Instantiates a new object to find the root of an equation using Riddler's
  /// method.
  ///
  ///   - [function]: the function f(x)
  ///   - [a]: the first interval in which evaluate `f(a)`
  ///   - [b]: the second interval in which evaluate `f(b)`
  ///   - [tolerance]: how accurate the algorithm has to be
  ///   - [maxSteps]: how many iterations at most the algorithm has to do
  const Riddler({
    required super.function,
    required this.a,
    required this.b,
    super.tolerance = 1.0e-10,
    super.maxSteps = 15,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is Riddler) {
      return super == other && a == other.a && b == other.b;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = super.hashCode;

    result = result * 37 + a.hashCode;
    result = result * 37 + b.hashCode;

    return result;
  }

  @override
  NonlinearResults solve() {
    // Exit immediately if the root is not bracketed
    if (evaluateOn(a) * evaluateOn(b) >= 0) {
      throw NonlinearException('The root is not bracketed in [$a, $b]');
    }

    final guesses = <double>[];
    var n = 1;

    var x0 = a;
    var x1 = b;
    var y0 = evaluateOn(x0);
    var y1 = evaluateOn(x1);

    while (n <= maxSteps) {
      final x2 = (x0 + x1) / 2;
      final y2 = evaluateOn(x2);

      // The guess on the n-th iteration
      final x = x2 + (x2 - x0) * (y0 - y1).sign * y2 / sqrt(y2 * y2 - y0 * y1);

      // Add the root to the list
      guesses.add(x);

      // Tolerance
      if (min<double>((x - x0).abs(), (x - x1).abs()) < tolerance) {
        break;
      }

      final y = evaluateOn(x);

      // Fixing signs
      if (y2.sign != y.sign) {
        x0 = x2;
        y0 = y2;
        x1 = x;
        y1 = y;
      } else {
        if (y1.sign != y.sign) {
          x0 = x;
          y0 = y;
        } else {
          x1 = x;
          y1 = y;
        }
      }

      ++n;
    }

    return NonlinearResults(
      guesses: guesses,
      convergence: convergence(guesses, maxSteps),
      efficiency: efficiency(guesses, maxSteps),
    );
  }
}
