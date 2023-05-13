import 'package:equations/equations.dart';

/// Implements Seffensen's method to find the roots of a given equation.
///
/// **Characteristics**:
///
///   - Similar to [Newton] as they use the same approach and both have a
///   quadratic convergence.
///
///   - This method does **not** use the derivative _f'(x)_ of the function.
///
///   - If _x0_ is too far from the root, the method might fail so the
///   convergence is not guaranteed.
final class Steffensen extends NonLinear {
  /// The initial guess x<sub>0</sub>.
  final double x0;

  /// Creates a [Steffensen] object to find the root of an equation by using
  /// Steffensen's method.
  ///
  ///   - [function]: the function f(x);
  ///   - [x0]: the initial guess x<sub>0</sub>;
  ///   - [tolerance]: how accurate the algorithm has to be;
  ///   - [maxSteps]: how many iterations at most the algorithm has to do.
  const Steffensen({
    required super.function,
    required this.x0,
    super.tolerance = 1.0e-10,
    super.maxSteps = 15,
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

    while ((diff >= tolerance) && (n < maxSteps)) {
      final fx = evaluateOn(x);
      final gx = (evaluateOn(x + fx) / fx) - 1;

      x = x - fx / gx;
      guesses.add(x);

      diff = (-fx / gx).abs();
      ++n;
    }

    return (
      guesses: guesses,
      convergence: convergence(guesses, maxSteps),
      efficiency: efficiency(guesses, maxSteps),
    );
  }
}
