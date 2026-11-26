import 'package:equations/equations.dart';
import 'package:equations/src/nonlinear/utils/nonlinear_utils.dart';

/// {@template newton}
/// Implements Newton's method (also known as the Newton-Raphson method) to find
/// the roots of a given equation.
///
///   - The method has quadratic convergence rate when it converges to a simple
///   root, making it one of the fastest root-finding algorithms. With a root
///   of multiplicity greater than 1 (for example, `x = 1` in `(x - 1)^2`), the
///   convergence rate is only linear.
///
///   - The method is extremely powerful but it's not guaranteed to converge to
///   a root of `f(x)`. Convergence depends on the choice of the initial guess
///   and the behavior of the function and its derivative.
///
///   - The derivative `f'(x)` doesn't have to be given: it's approximated
///   numerically with [evaluateDerivativeOn]. The method fails if:
///     - The derivative evaluated at a certain value is 0, infinite or NaN
///     - The function evaluated at a certain value is infinite or NaN
///
///   - The method may also not converge if the initial guess is too far from
///   the solution or if the function oscillates.
///
///   - Newton's method uses the iterative formula:
///     `x_{n+1} = x_n - f(x_n) / f'(x_n)`
///
///   - The algorithm stops when the size of the last step `|x_{n+1} - x_n|` is
///   smaller than [tolerance] or when `f(x_n)` is exactly zero.
/// {@endtemplate}
final class Newton extends NonLinear {
  /// {@macro newton}
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
      final fx = evaluateOn(currx0);
      NonLinearUtils.checkFiniteValue(currx0, fx);

      if (fx == 0) {
        if (guesses.isEmpty) {
          guesses.add(currx0);
        }
        break;
      }

      final der = evaluateDerivativeOn(currx0);

      if (der == 0 || !der.isFinite) {
        final value = switch (der) {
          0 => 'zero',
          _ when der.isNaN => 'NaN',
          _ => 'infinite',
        };

        throw NonlinearException(
          "Couldn't evaluate f'($currx0). The derivative is $value",
        );
      }

      diff = -fx / der;
      currx0 += diff;
      guesses.add(currx0);

      diff = diff.abs();
      ++n;
    }

    return NonLinearUtils.resultOf(this, guesses);
  }
}
