import 'package:equations/equations.dart';

/// Implements the 'bisection' method to find the roots of a given equation.
///
/// **Characteristics**:
///
///   - The method is guaranteed to converge to a root of `f(x)` if `f(x)` is a
///   continuous function on the interval `[a, b]`.
///
///   - The values of `f(a)` and `f(b)` must have opposite signs.
final class Bisection extends NonLinear {
  /// The starting point of the interval.
  final double a;

  /// The ending point of the interval.
  final double b;

  /// Creates a [Bisection] object to find the root of an equation by using the
  /// bisection method.
  ///
  ///   - [function]: the function f(x);
  ///   - [a]: the first interval in which evaluate `f(a)`;
  ///   - [b]: the second interval in which evaluate `f(b)`;
  ///   - [tolerance]: how accurate the algorithm has to be;
  ///   - [maxSteps]: how many iterations at most the algorithm has to do.
  const Bisection({
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

    if (other is Bisection) {
      return super == other && a == other.a && b == other.b;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(function, a, b, tolerance, maxSteps);

  @override
  ({List<double> guesses, double convergence, double efficiency}) solve() {
    var amp = tolerance + 1;
    var n = 1;
    final guesses = <double>[];
    var pA = a;
    var pB = b;
    var fa = evaluateOn(pA);

    while ((amp >= tolerance) && (n <= maxSteps)) {
      ++n;
      amp = (pB - pA).abs();
      final x0 = pA + amp * 0.5;

      guesses.add(x0);
      final fx = evaluateOn(x0);

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

    return (
      guesses: guesses,
      convergence: convergence(guesses, maxSteps),
      efficiency: efficiency(guesses, maxSteps),
    );
  }
}
