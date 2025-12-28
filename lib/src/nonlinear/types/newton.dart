import 'package:equations/equations.dart';

/// {@template newton}
/// Implements Newton's method (also known as the Newton-Raphson method) to find
/// the roots of a given equation.
///
///   - The method has quadratic convergence rate when it converges, making it
///   one of the fastest root-finding algorithms.
///
///   - The method is extremely powerful but it's not guaranteed to converge to
///   a root of `f(x)`. Convergence depends on the choice of the initial guess
///   and the behavior of the function and its derivative.
///
///   - The algorithm requires the derivative `f'(x)` to be computable and
///   non-zero near the root. The method may fail if:
///     - The derivative evaluated at a certain value is 0 or NaN
///     - The initial guess is too far from the solution
///     - The function has multiple roots or oscillates
///
///   - Newton's method uses the iterative formula:
///     `x_{n+1} = x_n - f(x_n) / f'(x_n)`
/// {@endtemplate}
final class Newton extends NonLinear {
  /// The initial guess x<sub>0</sub>.
  final double x0;

  /// {@macro newton}
  const Newton({
    required super.function,
    required this.x0,
    super.tolerance = 1.0e-10,
    super.maxSteps = 10,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is Newton) {
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
    var n = 0;
    var currx0 = x0;
    final guesses = <double>[];

    while ((diff >= tolerance) && (n < maxSteps)) {
      final der = evaluateDerivativeOn(currx0);

      if ((der == 0) || (der.isNaN)) {
        throw NonlinearException(
          "Couldn't evaluate f'($currx0). "
          'The derivative is ${der.isNaN ? "NaN" : "zero"}',
        );
      }

      diff = -evaluateOn(currx0) / der;
      currx0 += diff;
      guesses.add(currx0);

      diff = diff.abs();
      ++n;
    }

    return (
      guesses: guesses,
      convergence: convergence(guesses, maxSteps),
      efficiency: efficiency(guesses, maxSteps),
    );
  }
}
