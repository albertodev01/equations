import 'package:equations/src/common/results.dart';
import 'package:equations/src/nonlinear/nonlinear.dart';

/// Implements the Bisection method to find the roots of a given equation.
///
/// **Characteristics**:
///
///   - The method is guaranteed to converge to a root of _f(x)_ if _f(x)_ is a
///   continuous function on the interval [a, b].
///
///   - The values of _f(a)_ and _f(b)_ must have opposite signs.
class Bisection extends NonLinear {

  /// The starting point of the interval
  final double a;

  /// The ending point of the interval
  final double b;

  /// Instantiates a new object to find the root of an equation by using the
  /// Bisection method.
  ///
  ///   - [function]: the function f(x)
  ///   - [a]: the first interval in which evaluate _f(a)_
  ///   - [b]: the second interval in which evaluate _f(b)_
  ///   - [tolerance]: how accurate the algorithm has to be
  ///   - [maxSteps]: how many iterations at most the algorithm has to do
  Bisection(String function, this.a, this.b, {
    double tolerance = 1.0e-10,
    int maxSteps = 15
  }) : super(function, tolerance, maxSteps);

  @override
  Future<NonlinearResults> solve() async {
    var amp = tolerance + 1;
    var n = -1;
    var guesses = <double>[];
    var pA = a;
    var pB = b;
    var fa = evaluateOn(pA);

    while ((amp >= tolerance) & (n < maxSteps)) {
      ++n;
      amp = (pB - pA).abs();
      var x0 = pA + amp * 0.5;

      guesses.add(x0);
      var fx = evaluateOn(x0);

      if (fa * fx < 0) {
        pB = x0;
      } else {
        if (fa * fx > 0) {
          pA = x0;
          fa = fx;
        } else {
          amp = 0;
        }
      }
    }

    return NonlinearResults(
        guesses,
        convergence(guesses, maxSteps),
        efficiency(guesses, maxSteps)
    );
  }

}