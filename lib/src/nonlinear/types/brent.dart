import 'package:equations/equations.dart';
import 'package:equations/src/nonlinear/utils/nonlinear_utils.dart';

/// {@template brent}
/// Implements Brent's method to find the roots of a given equation.
///
/// Brent's method is a root-finding algorithm that combines the bisection
/// method, the secant method, and inverse quadratic interpolation. It has the
/// reliability of bisection but can be as fast as some of the less-reliable
/// methods.
///
///   - The method is guaranteed to converge to a root of `f(x)` if `f(x)` is a
///   continuous function on the interval `[a, b]`.
///
///   - The root must be inside the `[a, b]` interval, so `f(a)` and `f(b)` must
///   have opposite signs. If `f(a)` or `f(b)` is zero, that endpoint is
///   returned as the root.
///
///   - The algorithm uses inverse quadratic interpolation when possible, falls
///   back to the secant method, and uses bisection when the interpolated point
///   is not acceptable, to ensure convergence. This is the original version of
///   the algorithm (also known as `zeroin`), which never moves by less than
///   [tolerance] / 2 so that the interval shrinks quickly once the root is
///   close.
///
///   - Typically has superlinear convergence rate, making it faster than pure
///   bisection while maintaining guaranteed convergence.
///
///   - The algorithm stops when the width of the interval that contains the
///   root is smaller than about [tolerance] or when the function is exactly
///   zero at the new guess.
/// {@endtemplate}
final class Brent extends NonLinear {
  /// {@macro brent}
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

    if (other is Brent) {
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

  /// The machine epsilon (2^-52).
  static const _epsilon = 2.220446049250313e-16;

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

    // The root is always between 'valueB' and 'valueC', and 'valueB' is the
    // best estimate of the root. 'valueA' is the previous value of 'valueB'.
    var valueA = a;
    var valueB = b;
    var valueC = b;
    var fa = evalA;
    var fb = evalB;
    var fc = evalB;

    // The last step ('step') and the one before it ('previousStep')
    var step = valueB - valueA;
    var previousStep = step;
    final guesses = <double>[];

    for (var n = 1; n <= maxSteps; ++n) {
      // Making sure that the root is between 'valueB' and 'valueC'
      if (fb.sign == fc.sign) {
        valueC = valueA;
        fc = fa;
        step = valueB - valueA;
        previousStep = step;
      }

      // Making sure that 'valueB' is the best estimate of the root
      if (fc.abs() < fb.abs()) {
        valueA = valueB;
        valueB = valueC;
        valueC = valueA;
        fa = fb;
        fb = fc;
        fc = fa;
      }

      final tol = 2 * _epsilon * valueB.abs() + tolerance / 2;
      final half = (valueC - valueB) / 2;

      if (half.abs() <= tol) {
        break;
      }

      if (previousStep.abs() >= tol && fa.abs() > fb.abs()) {
        // Secant method (when there are only 2 distinct points) or inverse
        // quadratic interpolation, written as 'valueB + p / q'
        final s = fb / fa;
        double p;
        double q;

        if (valueA == valueC) {
          p = 2 * half * s;
          q = 1 - s;
        } else {
          final r1 = fa / fc;
          final r2 = fb / fc;
          p = s * (2 * half * r1 * (r1 - r2) - (valueB - valueA) * (r2 - 1));
          q = (r1 - 1) * (r2 - 1) * (s - 1);
        }

        if (p > 0) {
          q = -q;
        }
        p = p.abs();

        // Accepting the interpolation only if the new point is inside the
        // interval and the step is smaller than half the step before the
        // previous one. Otherwise, using bisection.
        final min1 = 3 * half * q - (tol * q).abs();
        final min2 = (previousStep * q).abs();

        if (2 * p < (min1 < min2 ? min1 : min2)) {
          previousStep = step;
          step = p / q;
        } else {
          step = half;
          previousStep = step;
        }
      } else {
        // Bisection
        step = half;
        previousStep = step;
      }

      valueA = valueB;
      fa = fb;

      // Never moving by less than 'tol', so that the interval keeps shrinking
      // when the guesses are already close to the root
      valueB += step.abs() > tol ? step : tol * half.sign;
      fb = evaluateOn(valueB);
      NonLinearUtils.checkFiniteValue(valueB, fb);

      guesses.add(valueB);

      // The exact root has been found
      if (fb == 0) {
        break;
      }
    }

    // The interval was already smaller than the tolerance
    if (guesses.isEmpty) {
      guesses.add(valueB);
    }

    return NonLinearUtils.resultOf(this, guesses);
  }
}
