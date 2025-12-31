import 'package:equations/equations.dart';

/// {@template regula_falsi}
/// Implements the regula falsi method (also known as the "_false position
/// method_") to find the roots of a given equation.
///
///   - The method is guaranteed to converge to a root of `f(x)` if `f(x)` is a
///     continuous function on the interval `[a, b]`.
///
///   - The values of `f(a)` and `f(b)` must have opposite signs (i.e.,
///     `f(a) * f(b) < 0`), which ensures that at least one root exists in the
///     interval by the Intermediate Value Theorem.
///
///   - The method has linear convergence rate, similar to bisection, but
///     typically converges faster when the function is well-approximated by a
///     linear function near the root.
///
///   - If the function cannot be well-approximated by a linear function, the
///     method may converge slower than bisection, especially when one endpoint
///     of the interval remains fixed for many iterations.
///
///   - The algorithm uses the formula:
///     `c = (f(a) * b - f(b) * a) / (f(a) - f(b))`
///     which finds the intersection of the line through `(a, f(a))` and
///     `(b, f(b))` with the x-axis.
///
///   - The interval is repeatedly narrowed by replacing one endpoint with the
///     computed intersection point, maintaining the bracketing condition.
/// {@endtemplate}
final class RegulaFalsi extends NonLinear {
  /// The starting point of the interval.
  final double a;

  /// The ending point of the interval.
  final double b;

  /// {@macro regula_falsi}
  const RegulaFalsi({
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

    if (other is RegulaFalsi) {
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

    if (evalA * evalB > 0) {
      throw NonlinearException(
        'The root is not bracketed in [$a, $b]. '
        'f(a) and f(b) must have opposite signs.',
      );
    }

    // Check if we've already found the root at one of the initial points
    if (evalA == 0) {
      return (
        guesses: [a],
        convergence: convergence([a], maxSteps),
        efficiency: efficiency([a], maxSteps),
      );
    }
    if (evalB == 0) {
      return (
        guesses: [b],
        convergence: convergence([b], maxSteps),
        efficiency: efficiency([b], maxSteps),
      );
    }

    final guesses = <double>[];
    var n = 1;
    var intervalA = a;
    var intervalB = b;
    var fa = evalA;

    while (n <= maxSteps) {
      // Evaluate function at the current interval endpoints
      final fb = evaluateOn(intervalB);

      // Compute the intersection point using the regula falsi formula:
      // c = (f(a) * b - f(b) * a) / (f(a) - f(b))
      final c = (fa * intervalB - fb * intervalA) / (fa - fb);
      final fc = evaluateOn(c);

      // Check for invalid function values
      if (fc.isNaN || fc.isInfinite) {
        throw NonlinearException(
          'Function evaluation resulted in invalid value at iteration $n. '
          'f($c) = $fc. The function may not be well-defined at this point.',
        );
      }

      // Add the guess to the list
      guesses.add(c);

      // Check if we've found the exact root
      if (fc == 0) {
        break;
      }

      // Check if we've reached the desired tolerance
      if (fc.abs() <= tolerance) {
        break;
      }

      // Shrink the interval while maintaining the bracketing condition
      if (fa * fc < 0) {
        // Root is in [intervalA, c]
        intervalB = c;
      } else {
        // Root is in [c, intervalB]
        intervalA = c;
        fa = fc;
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
