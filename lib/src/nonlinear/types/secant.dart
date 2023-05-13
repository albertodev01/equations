import 'package:equations/equations.dart';

/// Implements the secant method to find the roots of a given equation.
///
/// **Characteristics**:
///
///   - The method is not guaranteed to converge to a root of _f(x)_.
///
///   - The secant method does not require the root to remain bracketed, like
///   the bisection method does for example, so it doesn't always converge.
final class Secant extends NonLinear {
  /// The first guess.
  final double a;

  /// The second guess.
  final double b;

  /// Creates a [Secant] object to find the root of an equation by using the
  /// secant method. Ideally, the two guesses should be close to the root.
  ///
  ///   - [function]: the function f(x);
  ///   - [a]: the first interval in which evaluate _f(a)_;
  ///   - [b]: the second interval in which evaluate _f(b)_;
  ///   - [tolerance]: how accurate the algorithm has to be;
  ///   - [maxSteps]: how many iterations at most the algorithm has to do.
  const Secant({
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

    if (other is Secant) {
      return super == other && a == other.a && b == other.b;
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

    var xold = a;
    var x0 = b;

    var fold = evaluateOn(xold);
    var fnew = evaluateOn(x0);
    var diff = tolerance + 1;

    while ((diff >= tolerance) && (n <= maxSteps)) {
      final den = fnew - fold;

      if ((den == 0) || (den.isNaN)) {
        throw NonlinearException(
          'Invalid denominator encountered. '
          'The invalid value for the denominator was $den',
        );
      }

      diff = -(fnew * (x0 - xold)) / den;
      xold = x0;
      fold = fnew;
      x0 += diff;

      diff = diff.abs();
      ++n;

      guesses.add(x0);
      fnew = evaluateOn(x0);
    }

    return (
      guesses: guesses,
      convergence: convergence(guesses, maxSteps),
      efficiency: efficiency(guesses, maxSteps),
    );
  }
}
