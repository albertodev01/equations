import 'package:equations/equations.dart';

/// {@template steffensen}
/// Implements Steffensen's method to find the roots of a given equation.
///
///   - The method has quadratic convergence rate when it converges, similar to
///   [Newton]'s method, making it one of the fastest root-finding algorithms.
///
///   - This method does **not** require the derivative _f'(x)_ of the function.
///   Instead, it approximates the derivative using the formula:
///   _g(x) = [f(x + f(x)) - f(x)] / f(x) = f(x + f(x))/f(x) - 1_
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
/// {@endtemplate}
final class Steffensen extends NonLinear {
  /// The initial guess x<sub>0</sub>.
  final double x0;

  /// {@macro steffensen}
  const Steffensen({
    required super.function,
    required this.x0,
    super.tolerance = 1.0e-10,
    super.maxSteps = 30,
  });

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

      // If we've found the exact root, we're done
      if (fx == 0) {
        guesses.add(x);
        break;
      }

      // Check for division by zero when computing gx
      if (fx.isNaN || fx.isInfinite) {
        throw NonlinearException(
          "Couldn't evaluate f($x). "
          'The function value is ${fx.isNaN ? "NaN" : "infinite"}.',
        );
      }

      final gx = (evaluateOn(x + fx) / fx) - 1;

      // Check for division by zero or invalid values when using gx
      if ((gx == 0) || (gx.isNaN) || (gx.isInfinite)) {
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

    return (
      guesses: guesses,
      convergence: convergence(guesses, maxSteps),
      efficiency: efficiency(guesses, maxSteps),
    );
  }
}
