import 'package:equations/equations.dart';
import 'package:equations/src/nonlinear/nonlinear.dart';

/// Implements the 'bisection' method to find the roots of a given equation.
///
/// **Characteristics**:
///
///   - The method is guaranteed to converge to a root of `f(x)` if `f(x)` is a
///   continuous function on the interval [a, b].
///
///   - The values of `f(a)` and `f(b)` must have opposite signs.
class Bisection extends NonLinear {
  /// The starting point of the interval.
  final double a;

  /// The ending point of the interval.
  final double b;

  /// Instantiates a new object to find the root of an equation by using the
  /// Bisection method.
  ///
  ///   - [function]: the function f(x)
  ///   - [a]: the first interval in which evaluate `f(a)`
  ///   - [b]: the second interval in which evaluate `f(b)`
  ///   - [tolerance]: how accurate the algorithm has to be
  ///   - [maxSteps]: how many iterations at most the algorithm has to do
  const Bisection({
    required String function,
    required this.a,
    required this.b,
    double tolerance = 1.0e-10,
    int maxSteps = 15,
  }) : super(
          function: function,
          tolerance: tolerance,
          maxSteps: maxSteps,
        );

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
  int get hashCode {
    var result = super.hashCode;

    result = result * 37 + a.hashCode;
    result = result * 37 + b.hashCode;

    return result;
  }

  @override
  NonlinearResults solve() {
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

    return NonlinearResults(
      guesses: guesses,
      convergence: convergence(guesses, maxSteps),
      efficiency: efficiency(guesses, maxSteps),
    );
  }
}
