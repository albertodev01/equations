import 'package:equations/equations.dart';
import 'package:equations/src/nonlinear/nonlinear.dart';

/// Implements the Newton method to find the roots of a given equation.
///
/// **Characteristics**:
///
///   - The method is extremely powerful but it's not guaranteed to converge to a
/// root of `f(x)`.
///
///   - It may fail for example due to a division by zero, if the derivative
///   evaluated at a certain value is 0, or because the initial guess is too far
///   from the solution.
class Newton extends NonLinear {
  /// The initial guess x<sub>0</sub>
  final double x0;

  /// Instantiates a new object to find the root of an equation by using the
  /// Newton method.
  ///
  ///   - [function]: the function f(x)
  ///   - [x0]: the initial guess x<sub>0</sub>
  ///   - [tolerance]: how accurate the algorithm has to be
  ///   - [maxSteps]: how many iterations at most the algorithm has to do
  const Newton({
    required String function,
    required this.x0,
    double tolerance = 1.0e-10,
    int maxSteps = 10,
  }) : super(
          function: function,
          tolerance: tolerance,
          maxSteps: maxSteps,
        );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is Newton) {
      return super == other && x0 == other.x0;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => 37 * super.hashCode + x0.hashCode;

  @override
  NonlinearResults solve() {
    var diff = tolerance + 1;
    var n = 0;
    var currx0 = x0;
    final guesses = <double>[];

    while ((diff >= tolerance) && (n < maxSteps)) {
      final der = evaluateDerivativeOn(currx0);

      if ((der == 0) || (der.isNaN)) {
        throw NonlinearException("Couldn't evaluate f'($currx0)");
      }

      diff = -evaluateOn(currx0) / der;
      currx0 += diff;
      guesses.add(currx0);

      diff = diff.abs();
      ++n;
    }

    return NonlinearResults(
      guesses: guesses,
      convergence: convergence(guesses, maxSteps),
      efficiency: efficiency(guesses, maxSteps),
    );
  }
}
