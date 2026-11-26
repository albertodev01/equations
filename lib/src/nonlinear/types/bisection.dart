import 'package:equations/equations.dart';
import 'package:equations/src/nonlinear/utils/nonlinear_utils.dart';

/// {@template bisection}
/// Implements the bisection method to find a root of a given equation.
///
///   - The method is guaranteed to converge to a root of `f(x)` if `f(x)` is a
///   continuous function on the interval `[a, b]`.
///
///   - The values of `f(a)` and `f(b)` must have opposite signs, which ensures
///   that at least one root exists in the interval by the Intermediate Value
///   Theorem. If `f(a)` or `f(b)` is zero, that endpoint is returned as the
///   root.
///
///   - The method has linear convergence rate, making it slower than methods
///   like Newton's method, but it is very robust and always converges when the
///   conditions are met.
///
///   - The interval is repeatedly bisected, and the subinterval containing the
///   root is selected based on the sign of the function at the midpoint.
///
///   - The algorithm stops when the width of the interval is smaller than
///   [tolerance]. Each step halves the width, so it takes about
///   `log2(|b - a| / tolerance)` steps (for example, 34 steps for an interval
///   of width 1 and the default tolerance).
/// {@endtemplate}
final class Bisection extends NonLinear {
  /// {@macro bisection}
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
    var pA = a;
    var pB = b;
    var fa = evalA;

    while (n <= maxSteps) {
      // Check if we've reached the desired tolerance
      if ((pB - pA).abs() < tolerance) {
        break;
      }

      // Compute the midpoint
      final x0 = (pA + pB) / 2;
      final fx = evaluateOn(x0);
      NonLinearUtils.checkFiniteValue(x0, fx);

      guesses.add(x0);

      // If we've found the exact root, we're done
      if (fx == 0) {
        break;
      }

      // Update the interval based on the sign of the function
      if (fa.sign != fx.sign) {
        // Root is in [pA, x0]
        pB = x0;
      } else {
        // Root is in [x0, pB]
        pA = x0;
        fa = fx;
      }

      ++n;
    }

    return NonLinearUtils.resultOf(this, guesses);
  }
}
