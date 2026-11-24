import 'package:equations/equations.dart';
import 'package:equations/src/nonlinear/utils/nonlinear_utils.dart';

/// {@template regula_falsi}
/// Implements the regula falsi method (also known as the "_false position
/// method_") to find the roots of a given equation.
///
///   - The method is guaranteed to converge to a root of `f(x)` if `f(x)` is a
///     continuous function on the interval `[a, b]`.
///
///   - The values of `f(a)` and `f(b)` must have opposite signs, which ensures
///     that at least one root exists in the interval by the Intermediate Value
///     Theorem. If `f(a)` or `f(b)` is zero, that endpoint is returned as the
///     root.
///
///   - The algorithm uses the formula:
///     `c = (f(a) * b - f(b) * a) / (f(a) - f(b))`
///     which finds the intersection of the line through `(a, f(a))` and
///     `(b, f(b))` with the x-axis.
///
///   - The interval is repeatedly narrowed by replacing one endpoint with the
///     computed intersection point, maintaining the bracketing condition.
///
///   - The plain regula falsi method converges slowly when one endpoint stays
///     the same for many steps (for example, with convex functions such as
///     `x^10 - 1`). For this reason, this class implements the _Illinois_
///     variant: when the same endpoint is kept for two steps in a row, its
///     function value is halved in the formula. This moves the next point
///     towards the root and makes the convergence superlinear (about 1.44).
///
///   - The algorithm stops when `|f(c)|` is smaller than or equal to
///     [tolerance].
/// {@endtemplate}
final class RegulaFalsi extends NonLinear {
  /// {@macro regula_falsi}
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
    var intervalA = a;
    var intervalB = b;
    var fa = evalA;
    var fb = evalB;
    var lastReplaced = 0;

    while (n <= maxSteps) {
      // Compute the intersection point using the regula falsi formula:
      // c = (f(a) * b - f(b) * a) / (f(a) - f(b))
      final c = (fa * intervalB - fb * intervalA) / (fa - fb);
      final fc = evaluateOn(c);
      NonLinearUtils.checkFiniteValue(c, fc);

      guesses.add(c);

      // Check if we've found the root or reached the desired tolerance
      if (fc == 0 || fc.abs() <= tolerance) {
        break;
      }

      if (fa.sign != fc.sign) {
        // Root is in [intervalA, c]
        intervalB = c;
        fb = fc;
        if (lastReplaced == 1) {
          fa /= 2;
        }
        lastReplaced = 1;
      } else {
        // Root is in [c, intervalB]
        intervalA = c;
        fa = fc;
        if (lastReplaced == -1) {
          fb /= 2;
        }
        lastReplaced = -1;
      }

      ++n;
    }

    return NonLinearUtils.resultOf(this, guesses);
  }
}
