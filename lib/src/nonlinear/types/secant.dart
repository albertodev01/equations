import 'package:equations/equations.dart';
import 'package:equations/src/nonlinear/nonlinear.dart';

/// Implements the Secant method to find the roots of a given equation.
///
/// **Characteristics**:
///
///   - The method is not guaranteed to converge to a root of _f(x)_.
///
///   - The secant method does not require the root to remain bracketed, like
///   the bisection method does for example, so it doesn't always converge.
class Secant extends NonLinear {
  /// The first guess
  final double firstGuess;

  /// The second guess
  final double secondGuess;

  /// Instantiates a new object to find the root of an equation by using the
  /// Secant method. Ideally, the two guesses should be close to the root.
  ///
  ///   - [function]: the function f(x)
  ///   - [firstGuess]: the first interval in which evaluate _f(a)_
  ///   - [secondGuess]: the second interval in which evaluate _f(b)_
  ///   - [tolerance]: how accurate the algorithm has to be
  ///   - [maxSteps]: how many iterations at most the algorithm has to do
  const Secant(
      {required String function,
      required this.firstGuess,
      required this.secondGuess,
      double tolerance = 1.0e-10,
      int maxSteps = 15})
      : super(function: function, tolerance: tolerance, maxSteps: maxSteps);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is Secant) {
      return runtimeType == other.runtimeType &&
          function == other.function &&
          tolerance == other.tolerance &&
          maxSteps == other.maxSteps &&
          firstGuess == other.firstGuess &&
          secondGuess == other.secondGuess;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = super.hashCode;

    result = 37 * result + firstGuess.hashCode;
    result = 37 * result + secondGuess.hashCode;

    return result;
  }

  @override
  NonlinearResults solve() {
    var guesses = <double>[];
    var n = 1;

    var xold = firstGuess;
    var x0 = secondGuess;

    var fold = evaluateOn(xold);
    var fnew = evaluateOn(x0);
    var diff = tolerance + 1;

    while ((diff >= tolerance) && (n <= maxSteps)) {
      final den = fnew - fold;

      if ((den == 0) || (den.isNaN)) {
        throw NonlinearException("Invalid denominator encountered. "
            "The invalid value for the denominator was $den");
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

    return NonlinearResults(
        guesses: guesses,
        convergence: convergence(guesses, maxSteps),
        efficiency: efficiency(guesses, maxSteps));
  }
}
