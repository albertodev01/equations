import 'package:equations/equations.dart';

/// {@template chords}
/// Implements the 'chords' method to find the roots of a given equation.
///
///   - The method is guaranteed to converge to a root of `f(x)` if `f(x)` is a
///   continuous function on the interval `[a, b]`.
///
///   - The values of `f(a)` and `f(b)` must have opposite signs AND there must
///   be at least one root in `[a, b]`. These are 2 required conditions.
/// {@endtemplate}
final class Chords extends NonLinear {
  /// The starting point of the interval.
  final double a;

  /// The ending point of the interval.
  final double b;

  /// {@macro chords}
  const Chords({
    required super.function,
    required this.a,
    required this.b,
    super.tolerance = 1.0e-10,
    super.maxSteps = 30,
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

    final evalA = evaluateOn(a);
    final evalB = evaluateOn(b);

    if (evalA * evalB >= 0) {
      throw NonlinearException(
        'The root is not bracketed in [$a, $b]. '
        'f(a) and f(b) must have opposite signs.',
      );
    }

    var x0 = (a * evalB - b * evalA) / (evalB - evalA);
    var diff = evaluateOn(x0).abs();

    // If the initial guess already satisfies the tolerance, add it and return
    if (diff < tolerance) {
      guesses.add(x0);
      return (
        guesses: guesses,
        convergence: convergence(guesses, maxSteps),
        efficiency: efficiency(guesses, maxSteps),
      );
    }

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
      diff = evaluateOn(x0).abs();
      ++n;
    }

    return (
      guesses: guesses,
      convergence: convergence(guesses, maxSteps),
      efficiency: efficiency(guesses, maxSteps),
    );
  }
}
