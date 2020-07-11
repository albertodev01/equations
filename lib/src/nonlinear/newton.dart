import 'package:equations/src/common/exceptions.dart';
import 'package:equations/src/common/results.dart';
import 'package:equations/src/nonlinear/nonlinear.dart';

/// Implements the Newton method to find the roots of a given equation.
///
///
/// **Characteristics**:
///
///   - The method is extremely powerful but it's not guaranteed to converge to a
/// root of _f(x)_.
///
///   - It may fail for example due to a division by zero, if the
///   derivative evaluated at a certain value is 0 or because the initial guess
///   _x0_ is too far from the solution.
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
  Newton(String function, this.x0, {
    double tolerance = 1.0e-10,
    int maxSteps = 15
  }) : super(function, tolerance, maxSteps);

  @override
  Future<NonlinearResults> solve() async {
    var diff = tolerance + 1;
    var n = 0;
    var currx0 = x0;
    final guesses = <double>[];

    while ((diff >= tolerance) && (n < maxSteps)) {
      final der = evaluateDerivativeOn(currx0);
      if (der == 0)
        throw NonlinearException("Found a f'(x) = 0");

      diff = -evaluateOn(currx0) / der;
      currx0 += diff;
      guesses.add(currx0);

      diff = diff.abs();
      ++n;
    }

    return NonlinearResults(
      guesses,
      convergence(guesses, maxSteps),
      efficiency(guesses, maxSteps)
    );
  }

}