import 'package:equations/equations.dart';
import 'package:equations/src/nonlinear/utils/nonlinear_utils.dart';

/// {@template steffensen}
/// Implements Steffensen's method to find the roots of a given equation.
///
///   - The method has quadratic convergence rate when it converges to a simple
///   root, similar to [Newton]'s method, making it one of the fastest
///   root-finding algorithms.
///
///   - This method does **not** require the derivative _f'(x)_ of the function.
///   Instead, it approximates the derivative using the formula:
///   _g(x) = `f(x + f(x))/f(x) - 1_
///
///   - The method is extremely powerful but it's not guaranteed to converge to
///   a root of `f(x)`. Convergence depends on the choice of the initial guess
///   and the behavior of the function. The method may fail if:
///     - The initial guess `x0` is too far from the solution
///     - The function value `f(x)` is very small, causing numerical instability
///     - The approximated derivative `g(x)` becomes zero, infinite, or NaN
///     - The function has multiple roots or oscillates
///
///   - Steffensen's method uses the iterative formula:
///     `x_{n+1} = x_n - f(x_n) / g(x_n)`
///     where `g(x_n) = f(x_n + f(x_n))/f(x_n) - 1` approximates the derivative.
///
///   - The algorithm stops when the size of the last step `|x_{n+1} - x_n|` is
///   smaller than [tolerance] or when `f(x_n)` is exactly zero.
/// {@endtemplate}
final class Steffensen extends NonLinear {
  /// {@macro steffensen}
  const new({
    required super.function,
    required this.x0,
    super.tolerance = 1.0e-10,
    super.maxSteps = 30,
  });

  /// The initial guess x<sub>0</sub>.
  final double x0;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is Steffensen) {
      return runtimeType == other.runtimeType &&
          function == other.function &&
          tolerance == other.tolerance &&
          maxSteps == other.maxSteps &&
          x0 == other.x0;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(function, x0, tolerance, maxSteps);

  @override
  ({List<double> guesses, double convergence, double efficiency}) solve() {
    var diff = tolerance + 1;
    var n = 1;
    var x = x0;
    final guesses = <double>[];

    while ((diff >= tolerance) && (n <= maxSteps)) {
      final fx = evaluateOn(x);
      NonLinearUtils.checkFiniteValue(x, fx);

      // The exact root has been found. It is already the last guess, unless
      // it's the initial guess.
      if (fx == 0) {
        if (guesses.isEmpty) {
          guesses.add(x);
        }
        break;
      }

      final gx = (evaluateOn(x + fx) / fx) - 1;

      // Check for division by zero or invalid values when using gx
      if ((gx == 0) || !gx.isFinite) {
        throw NonlinearException(
          "Couldn't compute the next iteration at x = $x. "
          'The value g(x) is not well defined',
        );
      }

      final delta = fx / gx;
      x -= delta;
      guesses.add(x);

      diff = delta.abs();
      ++n;
    }

    return NonLinearUtils.resultOf(this, guesses);
  }
}
