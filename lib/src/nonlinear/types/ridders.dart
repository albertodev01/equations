import 'dart:math' as math;

import 'package:equations/equations.dart';
import 'package:equations/src/nonlinear/utils/nonlinear_utils.dart';

/// {@template ridders}
/// Implements Ridders' method to find the roots of a given equation.
///
/// It's a modification of the false position method that uses exponential
/// interpolation: on each step, the function is evaluated at the midpoint of
/// the interval and the three points are mapped onto a straight line with an
/// exponential factor. The root of that line is the new guess.
///
///   - The method requires the root to be bracketed between two points `a` and
///     `b`, so `f(a)` and `f(b)` must have opposite signs. If `f(a)` or `f(b)`
///     is zero, that endpoint is returned as the root.
///
///   - The convergence is guaranteed for continuous functions when the root is
///     properly bracketed, making it more reliable than methods like Newton's
///     method for ill-behaved functions. The new guess is always inside the
///     interval.
///
///   - The rate of convergence is quadratic. Each step evaluates the function
///     twice, so the efficiency index is `sqrt(2)`: faster than bisection but
///     slower than Newton's method.
///
///   - The algorithm stops when `|f(x)|` or the width of the interval that
///     contains the root is smaller than [tolerance].
/// {@endtemplate}
final class Ridders extends NonLinear {
  /// {@macro ridders}
  const new({
    required super.function,
    required this.a,
    required this.b,
    super.tolerance = 1.0e-10,
    super.maxSteps = 30,
  });

  /// The starting point of the interval.
  final double a;

  /// The ending point of the interval.
  final double b;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is Ridders) {
      return runtimeType == other.runtimeType &&
          function == other.function &&
          tolerance == other.tolerance &&
          maxSteps == other.maxSteps &&
          a == other.a &&
          b == other.b;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(function, a, b, tolerance, maxSteps);

  @override
  ({List<double> guesses, double convergence, double efficiency}) solve() {
    final evalA = evaluateOn(a);
    final evalB = evaluateOn(b);

    NonLinearUtils.checkBracket(a, evalA, b, evalB);

    // One of the endpoints is already a root
    if (evalA == 0) {
      return NonLinearUtils.resultOf(this, [a]);
    }
    if (evalB == 0) {
      return NonLinearUtils.resultOf(this, [b]);
    }

    final guesses = <double>[];
    var n = 1;

    // The root is always between 'x0' and 'x1', which can be in any order
    var x0 = a;
    var x1 = b;
    var y0 = evalA;
    var y1 = evalB;

    while (n <= maxSteps) {
      // Calculate the midpoint
      final x2 = (x0 + x1) / 2;
      final y2 = evaluateOn(x2);
      NonLinearUtils.checkFiniteValue(x2, y2);

      // Check if we've found the exact root at the midpoint
      if (y2 == 0) {
        guesses.add(x2);
        break;
      }

      final scale = math.max(y2.abs(), math.max(y0.abs(), y1.abs()));
      final root =
          scale *
          math.sqrt((y2 / scale) * (y2 / scale) - (y0 / scale) * (y1 / scale));

      // x = x2 + (x2 - x0) * sign(y0 - y1) * y2 / sqrt(y2^2 - y0 * y1)
      final x = x2 + (x2 - x0) * (y0 - y1).sign * y2 / root;
      final y = evaluateOn(x);
      NonLinearUtils.checkFiniteValue(x, y);

      guesses.add(x);

      // Check if we've found the exact root
      if (y == 0) {
        break;
      }

      // Update the interval so that the root is still between 'x0' and 'x1'
      if (y2.sign != y.sign) {
        // The root is between the midpoint and the new guess
        x0 = x2;
        y0 = y2;
        x1 = x;
        y1 = y;
      } else if (y0.sign != y.sign) {
        // The root is between 'x0' and the new guess
        x1 = x;
        y1 = y;
      } else {
        // The root is between the new guess and 'x1'
        x0 = x;
        y0 = y;
      }

      if (y.abs() < tolerance || (x1 - x0).abs() < tolerance) {
        break;
      }

      ++n;
    }

    return NonLinearUtils.resultOf(this, guesses);
  }
}
