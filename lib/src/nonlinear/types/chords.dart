import 'package:equations/equations.dart';
import 'package:equations/src/nonlinear/nonlinear.dart';

/// Implements the 'chords' method to find the roots of a given equation.
///
/// **Characteristics**:
///
///   - The method is guaranteed to converge to a root of `f(x)` if `f(x)` is a
///   continuous function on the interval [a, b].
///
///   - The values of `f(a)` and `f(b)` must have opposite signs AND there must
///   be at least one root in [a, b]. These are 2 required conditions.
class Chords extends NonLinear {
  /// The initial guess x<sub>0</sub>
  final double a;

  /// The function f(x) for which a root has to be find
  final double b;

  /// Instantiates a new object to find the root of an equation by using the
  /// Chords method.
  ///
  ///   - [function]: the function f(x)
  ///   - [a]: the first interval in which evaluate `f(a)`
  ///   - [b]: the second interval in which evaluate `f(b)`
  ///   - [tolerance]: how accurate the algorithm has to be
  ///   - [maxSteps]: how many iterations at most the algorithm has to do
  const Chords(
      {required String function,
      required this.a,
      required this.b,
      double tolerance = 1.0e-10,
      int maxSteps = 15})
      : super(function: function, tolerance: tolerance, maxSteps: maxSteps);

  @override
  Future<NonlinearResults> solve() async {
    var guesses = <double>[];
    var n = 1;

    var x0 = (a * evaluateOn(b) - b * evaluateOn(a)) /
        (evaluateOn(b) - evaluateOn(a));
    var diff = evaluateOn(x0).abs();

    while ((diff >= tolerance) && (n < maxSteps)) {
      var fa = evaluateOn(a);
      var fx = evaluateOn(x0);

      if (fa * fx < 0) {
        x0 = (x0 * fa - a * fx) / (fa - fx);
      } else {
        var fb = evaluateOn(b);
        x0 = (x0 * fb - b * fx) / (fb - fx);
      }

      guesses.add(x0);
      diff = fx.abs();
      ++n;
    }

    return NonlinearResults(
        guessedValues: guesses,
        convergence: convergence(guesses, maxSteps),
        efficiency: efficiency(guesses, maxSteps));
  }
}
