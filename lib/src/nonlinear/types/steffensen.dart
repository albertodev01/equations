import 'package:equations/equations.dart';
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
  const Steffensen(
      {required String function,
      required this.x0,
      double tolerance = 1.0e-10,
      int maxSteps = 15})
      : super(function: function, tolerance: tolerance, maxSteps: maxSteps);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is Steffensen) {
      return super == other && x0 == other.x0;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = super.hashCode;

    result = 37 * result + x0.hashCode;

    return result;
  }

  @override
  NonlinearResults solve() {
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
        guesses: guesses,
        convergence: convergence(guesses, maxSteps),
        efficiency: efficiency(guesses, maxSteps));
  }
}
