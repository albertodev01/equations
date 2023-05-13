import 'package:equations/equations.dart';

/// Implements the regula falsi method (also known as "_false position method_")
/// to find the roots of a given equation.
///
/// **Characteristics**:
///
///   - The method requires the root to be bracketed between two points `a` and
///   `b` otherwise it won't work.
///
///   - If you cannot assume that a function may be interpolated by a linear
///   function, then applying this method method could result in worse results
///   than the bisection method.
final class RegulaFalsi extends NonLinear {
  /// The starting point of the interval.
  final double a;

  /// The ending point of the interval.
  final double b;

  /// Creates a [RegulaFalsi] object to find the root of an equation by using
  /// the regula falsi method.
  ///
  ///   - [function]: the function f(x);
  ///   - [a]: the first interval in which evaluate `f(a)`;
  ///   - [b]: the second interval in which evaluate `f(b)`;
  ///   - [tolerance]: how accurate the algorithm has to be;
  ///   - [maxSteps]: how many iterations at most the algorithm has to do.
  const RegulaFalsi({
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

    if (other is RegulaFalsi) {
      return super == other && a == other.a && b == other.b;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(function, a, b, tolerance, maxSteps);

  @override
  ({List<double> guesses, double convergence, double efficiency}) solve() {
    // Exit immediately if the root is not bracketed
    if (evaluateOn(a) * evaluateOn(b) >= 0) {
      throw NonlinearException('The root is not bracketed in [$a, $b]');
    }

    final guesses = <double>[];
    var toleranceCheck = true;
    var n = 1;

    var tempA = a;
    var tempB = b;

    while (toleranceCheck && (n <= maxSteps)) {
      // Evaluating on A and B the function
      final fa = evaluateOn(tempA);
      final fb = evaluateOn(tempB);

      // Computing the guess
      final c = (fa * tempB - fb * tempA) / (fa - fb);
      final fc = evaluateOn(c);

      // Making sure the evaluation is not zero
      if (fc == 0) {
        break;
      }

      // Shrink the interval
      if (fa * fc < 0) {
        tempB = c;
      } else {
        tempA = c;
      }

      // Add the root to the list
      guesses.add(c);

      toleranceCheck = fc.abs() > tolerance;
      ++n;
    }

    return (
      guesses: guesses,
      convergence: convergence(guesses, maxSteps),
      efficiency: efficiency(guesses, maxSteps),
    );
  }
}
