import 'package:equations/equations.dart';
import 'package:equations/src/nonlinear/nonlinear.dart';

/// Implements Brent's method to find the roots of a given equation.
///
/// **Characteristics**:
///
///   - The method is guaranteed to converge to a root of `f(x)` if `f(x)` is a
///   continuous function on the interval [a, b].
///
///   - The root must be inside the [a, b] interval. For this reason, the method
///   will fail if `f(a) * f(b) >= 0`.
class Brent extends NonLinear {
  /// The starting point of the interval.
  final double a;

  /// The ending point of the interval.
  final double b;

  /// Instantiates a new object to find the root of an equation by using the
  /// Chords method.
  ///
  ///   - [function]: the function f(x)
  ///   - [a]: the first interval in which evaluate `f(a)`
  ///   - [b]: the second interval in which evaluate `f(b)`
  ///   - [tolerance]: how accurate the algorithm has to be
  ///   - [maxSteps]: how many iterations at most the algorithm has to do
  const Brent({
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

    if (other is Brent) {
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

  bool _condition1(double s, double a, double b) {
    final lower = (a * 3 + b) / 4;

    return !((s >= lower) && (s <= b));
  }

  bool _condition2(double s, bool flag, double b, double c) {
    return flag && ((s - b).abs() >= ((b - c).abs() / 2));
  }

  bool _condition3(double s, bool flag, double b, double c, double d) {
    return !flag && ((s - b).abs() >= ((c - d).abs() / 2));
  }

  bool _condition4(bool flag, double b, double c) {
    return flag && ((b - c).abs() <= tolerance.abs());
  }

  bool _condition5(bool flag, double c, double d) {
    return !flag && ((c - d).abs() <= tolerance.abs());
  }

  @override
  NonlinearResults solve() {
    final guesses = <double>[];
    var n = 1;

    final evalA = evaluateOn(a);
    final evalB = evaluateOn(b);

    // Making sure that the root is in the given interval
    if (evalA * evalB >= 0) {
      throw const NonlinearException('The root is not bracketed.');
    }

    // Variables setup
    var valueA = a;
    var valueB = b;
    var valueC = a;
    var valueD = 0.0;
    var diff = (valueB - valueA).abs();
    var s = 0.0;
    var flag = true;

    if (evalA.abs() < evalB.abs()) {
      final temp = valueA;
      valueA = valueB;
      valueB = temp;
    }

    while ((diff >= tolerance) && (n <= maxSteps)) {
      final fa = evaluateOn(valueA);
      final fb = evaluateOn(valueB);
      final fc = evaluateOn(valueC);

      if ((fa != fc) && (fb != fc)) {
        // Inverse quadratic interpolation method
        final term1 = valueA * fb * fc / ((fa - fb) * (fa - fc));
        final term2 = valueB * fa * fc / ((fb - fa) * (fb - fc));
        final term3 = valueC * fa * fb / ((fc - fa) * (fc - fb));

        s = term1 + term2 + term3;
      } else {
        // Secant method
        s = valueB - (fb * ((valueB - valueA) / (fb - fa)));
      }

      if (_condition1(s, valueA, valueB) ||
          _condition2(s, flag, valueB, valueC) ||
          _condition3(s, flag, valueB, valueC, valueD) ||
          _condition4(flag, valueB, valueC) ||
          _condition5(flag, valueC, valueD)) {
        // Bisection method
        s = (valueA + valueB) / 2;
      } else {
        flag = false;
      }

      // 's' is the value of the root to be discovered
      guesses.add(s);

      // Generating new brackets for the next iteration
      final fs = evaluateOn(s);
      valueD = valueC;
      valueC = valueB;

      if (fa * fs < 0) {
        valueB = s;
      } else {
        valueA = s;
      }

      if (fa.abs() < fb.abs()) {
        final temp = valueA;
        valueA = valueB;
        valueB = temp;
      }

      // Updating the exit conditions
      ++n;
      diff = (valueB - valueA).abs();
    }

    return NonlinearResults(
      guesses: guesses,
      convergence: convergence(guesses, maxSteps),
      efficiency: efficiency(guesses, maxSteps),
    );
  }
}
