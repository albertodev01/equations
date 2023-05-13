import 'package:equations/equations.dart';

/// Implements the 'chords' method to find the roots of a given equation.
///
/// **Characteristics**:
///
///   - The method is guaranteed to converge to a root of `f(x)` if `f(x)` is a
///   continuous function on the interval `[a, b]`.
///
///   - The values of `f(a)` and `f(b)` must have opposite signs AND there must
///   be at least one root in `[a, b]`. These are 2 required conditions.
final class Chords extends NonLinear {
  /// The starting point of the interval.
  final double a;

  /// The ending point of the interval.
  final double b;

  /// Creates a [Chords] object to find the root of an equation by using the
  /// chords method.
  ///
  ///   - [function]: the function f(x);
  ///   - [a]: the first interval in which evaluate `f(a)`;
  ///   - [b]: the second interval in which evaluate `f(b)`;
  ///   - [tolerance]: how accurate the algorithm has to be;
  ///   - [maxSteps]: how many iterations at most the algorithm has to do.
  const Chords({
    required super.function,
    required this.a,
    required this.b,
    super.tolerance = 1.0e-10,
    super.maxSteps = 15,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is Chords) {
      return runtimeType == other.runtimeType &&
          function == other.function &&
          tolerance == other.tolerance &&
          maxSteps == other.maxSteps &&
          a == other.a &&
          b == other.b;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(function, a, b, tolerance, maxSteps);

  @override
  ({List<double> guesses, double convergence, double efficiency}) solve() {
    final guesses = <double>[];
    var n = 1;

    var x0 = (a * evaluateOn(b) - b * evaluateOn(a)) /
        (evaluateOn(b) - evaluateOn(a));
    var diff = evaluateOn(x0).abs();

    while ((diff >= tolerance) && (n <= maxSteps)) {
      final fa = evaluateOn(a);
      final fx = evaluateOn(x0);

      if (fa * fx < 0) {
        x0 = (x0 * fa - a * fx) / (fa - fx);
      } else {
        final fb = evaluateOn(b);
        x0 = (x0 * fb - b * fx) / (fb - fx);
      }

      guesses.add(x0);
      diff = fx.abs();
      ++n;
    }

    return (
      guesses: guesses,
      convergence: convergence(guesses, maxSteps),
      efficiency: efficiency(guesses, maxSteps),
    );
  }
}
