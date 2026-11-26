import 'package:equations/equations.dart';
import 'package:equations/src/nonlinear/utils/nonlinear_utils.dart';

/// {@template secant}
/// Implements the secant method to find the roots of a given equation. It is
/// similar to [Newton]'s method but does not require the computation of
/// derivatives.
///
///   - The method has superlinear convergence rate (approximately 1.618, the
///   golden ratio) when it converges, making it faster than linear methods like
///   bisection but slower than quadratic methods like Newton's method.
///
///   - Unlike [Newton]'s method, the secant method does **not** require the
///   derivative `f'(x)` of the function, making it useful when derivatives are
///   difficult or expensive to compute.
///
///   - The method is not guaranteed to converge to a root of `f(x)`. The secant
///   method does not require the root to remain bracketed (unlike bisection or
///   regula falsi), so convergence depends on the choice of initial guesses and
///   the behavior of the function. The method may fail if:
///     - The two initial guesses `a` and `b` are too far from the solution
///     - The function has multiple roots or oscillates
///     - The denominator `f(b) - f(a)` becomes zero, causing division by zero
///     - The function values become infinite or NaN
///
///   - The secant method uses the iterative formula:
///     `x_{n+1} = x_n - f(x_n) * (x_n - x_{n-1}) / (f(x_n) - f(x_{n-1}))`
///     which approximates Newton's method by replacing the derivative with a
///     finite difference quotient.
///
///   - The algorithm stops when the size of the last step `|x_{n+1} - x_n|` is
///     smaller than [tolerance] or when `f(x_n)` is exactly zero.
/// {@endtemplate}
final class Secant extends NonLinear {
  /// {@macro secant}
  const new({
    required super.function,
    required this.a,
    required this.b,
    super.tolerance = 1.0e-10,
    super.maxSteps = 30,
  });

  /// The first initial guess x<sub>0</sub>.
  final double a;

  /// The second initial guess x<sub>1</sub>.
  final double b;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is Secant) {
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
    // Check if initial guesses are identical
    if (a == b) {
      throw NonlinearException(
        'The two initial guesses must be different. '
        'Both a and b are equal to $a.',
      );
    }

    // Initialize with the two initial guesses
    var xPrev = a;
    var xCurr = b;

    var fPrev = evaluateOn(xPrev);
    var fCurr = evaluateOn(xCurr);
    NonLinearUtils.checkFiniteValue(xPrev, fPrev);
    NonLinearUtils.checkFiniteValue(xCurr, fCurr);

    // Check if we've already found the root at one of the initial guesses
    if (fPrev == 0) {
      return NonLinearUtils.resultOf(this, [xPrev]);
    }
    if (fCurr == 0) {
      return NonLinearUtils.resultOf(this, [xCurr]);
    }

    final guesses = <double>[];
    var n = 1;
    var diff = tolerance + 1;

    while ((diff >= tolerance) && (n <= maxSteps)) {
      // Compute the denominator: f(x_curr) - f(x_prev)
      final denominator = fCurr - fPrev;

      // Check for invalid denominator values
      if (denominator == 0 || !denominator.isFinite) {
        throw NonlinearException(
          'Invalid denominator encountered at iteration $n. '
          'The denominator f($xCurr) - f($xPrev) = $denominator.',
        );
      }

      // x_{n+1} = x_n - f(x_n) * (x_n - x_{n-1}) / (f(x_n) - f(x_{n-1}))
      diff = -(fCurr * (xCurr - xPrev)) / denominator;

      // Update for next iteration
      xPrev = xCurr;
      fPrev = fCurr;
      xCurr += diff;

      diff = diff.abs();
      ++n;

      guesses.add(xCurr);
      fCurr = evaluateOn(xCurr);
      NonLinearUtils.checkFiniteValue(xCurr, fCurr);

      // Early exit if we've found the exact root
      if (fCurr == 0) {
        break;
      }
    }

    return NonLinearUtils.resultOf(this, guesses);
  }
}
