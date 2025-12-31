import 'package:equations/equations.dart';

/// {@template bisection}
/// Implements the bisection method to find a root of a given equation.
///
///   - The method is guaranteed to converge to a root of `f(x)` if `f(x)` is a
///   continuous function on the interval `[a, b]`.
///
///   - The values of `f(a)` and `f(b)` must have opposite signs (i.e.,
///   `f(a) * f(b) < 0`), which ensures that at least one root exists in the
///   interval by the Intermediate Value Theorem.
///
///   - The method has linear convergence rate, making it slower than methods
///   like Newton's method, but it is very robust and always converges when the
///   conditions are met.
///
///   - The interval is repeatedly bisected, and the subinterval containing the
///   root is selected based on the sign of the function at the midpoint.
/// {@endtemplate}
final class Bisection extends NonLinear {
  /// The starting point of the interval.
  final double a;

  /// The ending point of the interval.
  final double b;

  /// {@macro bisection}
  const Bisection({
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

    if (other is Bisection) {
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
    var pA = a;
    var pB = b;
    var fa = evalA;

    while (n <= maxSteps) {
      // Calculate the interval width
      final amp = (pB - pA).abs();

      // Check if we've reached the desired tolerance
      if (amp < tolerance) {
        break;
      }

      // Compute the midpoint
      final x0 = (pA + pB) / 2;
      final fx = evaluateOn(x0);

      // Add the guess to the list
      guesses.add(x0);

      // If we've found the exact root, we're done
      if (fx == 0) {
        break;
      }

      // Update the interval based on the sign of the function
      if (fa * fx < 0) {
        // Root is in [pA, x0]
        pB = x0;
      } else {
        // Root is in [x0, pB]
        pA = x0;
        fa = fx;
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
