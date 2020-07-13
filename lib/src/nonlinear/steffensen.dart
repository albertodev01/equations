import 'package:equations/src/common/results.dart';
import 'package:equations/src/nonlinear/newton.dart';
import 'package:equations/src/nonlinear/nonlinear.dart';

/// Implements the Steffensen method to find the roots of a given equation.
///
/// **Characteristics**:
///
///   - Similar to [Newton] as they use the same approach and both have a quadratic
///   convergence.
///
///   - This method does **not** use the derivative _f'(x)_ of the function
///
///   - If _x0_ is too far from the root, the method might fail so the convergence
///   is not guaranteed.
class Steffensen extends NonLinear {
  /// The initial guess x<sub>0</sub>
  final double x0;

  /// Instantiates a new object to find the root of an equation by using the
  /// Steffensen method.
  ///
  ///   - [function]: the function f(x)
  ///   - [x0]: the initial guess x<sub>0</sub>
  ///   - [tolerance]: how accurate the algorithm has to be
  ///   - [maxSteps]: how many iterations at most the algorithm has to do
  Steffensen(String function, this.x0,
      {double tolerance = 1.0e-10, int maxSteps = 15})
      : super(function, tolerance, maxSteps);

  @override
  Future<NonlinearResults> solve() async {
    var diff = tolerance + 1;
    var n = 1;
    var x = x0;
    final guesses = <double>[];

    while ((diff >= tolerance) && (n < maxSteps)) {
      var fx = evaluateOn(x);
      var gx = (evaluateOn(x + fx) / fx) - 1;

      x = x - fx / gx;
      guesses.add(x);

      diff = (-fx / gx).abs();
      ++n;
    }

    return NonlinearResults(
        guesses, convergence(guesses, maxSteps), efficiency(guesses, maxSteps));
  }
}
