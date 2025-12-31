import 'dart:math';

import 'package:equations/equations.dart';

/// {@template riddler}
/// Implements Riddler's method (also known as the Ridders' method) to find the
/// roots of a given equation.
///
/// Uses exponential interpolation to find the root. It's a modification of the
/// false position method that improves convergence.
///
///   - The method requires the root to be bracketed between two points `a` and
///     `b` (i.e., `f(a) * f(b) < 0`), otherwise it won't work.
///
///   - The rate of convergence is approximately `sqrt(2)` (superlinear), which
///     is faster than bisection but slower than Newton's method.
///
///   - The convergence is guaranteed for continuous functions when the root is
///     properly bracketed, making it more reliable than methods like Newton's
///     method for ill-behaved functions.
///
///   - The algorithm uses the formula:
///     `x = x2 + (x2 - x0) * sign(y0 - y1) * y2 / sqrt(y2^2 - y0 * y1)`
///     where `x2` is the midpoint and `y0`, `y1`, `y2` are function values.
///
///   - The method may fail if the expression under the square root becomes
///     negative or zero, in which case the algorithm falls back to bisection.
/// {@endtemplate}
final class Riddler extends NonLinear {
  /// The starting point of the interval.
  final double a;

  /// The ending point of the interval.
  final double b;

  /// {@macro riddler}
  const Riddler({
    required super.function,
    required this.a,
    required this.b,
    super.tolerance = 1.0e-10,
    super.maxSteps = 30,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is Riddler) {
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
    // Validate that the root is bracketed in the interval
    final evalA = evaluateOn(a);
    final evalB = evaluateOn(b);

    if (evalA * evalB >= 0) {
      throw NonlinearException(
        'The root is not bracketed in [$a, $b]. '
        'f(a) and f(b) must have opposite signs.',
      );
    }

    final guesses = <double>[];
    var n = 1;

    var x0 = a;
    var x1 = b;
    var y0 = evalA.toDouble();
    var y1 = evalB.toDouble();

    while (n <= maxSteps) {
      // Calculate the midpoint
      final x2 = (x0 + x1) / 2;
      final y2 = evaluateOn(x2).toDouble();

      // Check if we've found the exact root at the midpoint
      if (y2 == 0) {
        guesses.add(x2);
        break;
      }

      // Check for invalid function values
      if (y2.isNaN || y2.isInfinite) {
        throw NonlinearException(
          "Couldn't evaluate f($x2). "
          'The function value is ${y2.isNaN ? "NaN" : "infinite"}.',
        );
      }

      // Compute the expression under the square root: y2^2 - y0 * y1
      final discriminant = y2 * y2 - y0 * y1;

      // Use Riddler's formula if the discriminant is positive and non-zero
      // Otherwise, fall back to bisection for numerical stability
      double x;
      if (discriminant > 0) {
        final sqrtDiscriminant = sqrt(discriminant);
        if (sqrtDiscriminant == 0) {
          // Fall back to bisection
          x = x2;
        } else {
          // x = x2 + (x2 - x0) * sign(y0 - y1) * y2 / sqrt(y2^2 - y0 * y1)
          x = x2 + (x2 - x0) * (y0 - y1).sign * y2 / sqrtDiscriminant;
        }
      } else {
        // Discriminant is negative or zero, fall back to bisection
        x = x2;
      }

      // Ensure the new guess is within the current interval
      // If it's outside, clamp it to the interval bounds
      if (x < x0 || x > x1) {
        x = x2; // Use midpoint if the formula gives an invalid result
      }

      // Check convergence: either the interval is small enough or the function
      // value is close to zero
      final y = evaluateOn(x).toDouble();
      guesses.add(x);

      if (y.abs() < tolerance || (x1 - x0).abs() < tolerance) {
        break;
      }

      // Early exit if we've found the exact root
      if (y == 0) {
        break;
      }

      // Update the interval based on the sign of the function values
      // The root must be between points with opposite signs
      if (y2.sign != y.sign) {
        x0 = x2;
        y0 = y2;
        x1 = x;
        y1 = y;
      } else {
        x0 = x;
        y0 = y;
      }

      ++n;
    }

    return (
      guesses: guesses,
      convergence: convergence(guesses, maxSteps),
      efficiency: efficiency(guesses, maxSteps),
    );
  }
}
