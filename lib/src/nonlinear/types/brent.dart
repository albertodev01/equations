import 'package:equations/equations.dart';

/// {@template brent}
/// Implements Brent's method to find the roots of a given equation.
///
/// Brent's method is a root-finding algorithm that combines the bisection
/// method, the secant method, and inverse quadratic interpolation. It has the
/// reliability of bisection but can be as fast as some of the less-reliable
/// methods.
///
///   - The method is guaranteed to converge to a root of `f(x)` if `f(x)` is a
///   continuous function on the interval `[a, b]`.
///
///   - The root must be inside the `[a, b]` interval. For this reason, the
///   method will fail if `f(a) * f(b) >= 0`.
///
///   - The algorithm uses inverse quadratic interpolation when possible, falls
///   back to the secant method, and uses bisection when necessary to ensure
///   convergence.
///
///   - Typically has superlinear convergence rate, making it faster than pure
///   bisection while maintaining guaranteed convergence.
/// {@endtemplate}
final class Brent extends NonLinear {
  /// The starting point of the interval.
  final double a;

  /// The ending point of the interval.
  final double b;

  /// {@macro brent}
  const Brent({
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

    if (other is Brent) {
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

  /// Checks if the interpolated point `s` is outside the acceptable range
  /// for inverse quadratic interpolation or secant method.
  ///
  /// Returns `true` if `s` is not in the interval `[(3a+b)/4, b]`, indicating
  /// that bisection should be used instead.
  bool _condition1(double s, double a, double b) {
    final lower = (a * 3 + b) / 4;

    return !((s >= lower) && (s <= b));
  }

  /// Checks if the step size is too large when using inverse quadratic
  /// interpolation (flag is true).
  ///
  /// Returns `true` if the step from `b` to `s` is at least half the distance
  /// from `b` to `c`, indicating that bisection should be used instead.
  bool _condition2(double s, bool flag, double b, double c) =>
      flag && ((s - b).abs() >= ((b - c).abs() / 2));

  /// Checks if the step size is too large when using secant method (flag is
  /// false).
  ///
  /// Returns `true` if the step from `b` to `s` is at least half the distance
  /// from `c` to `d`, indicating that bisection should be used instead.
  bool _condition3(double s, bool flag, double b, double c, double d) =>
      !flag && ((s - b).abs() >= ((c - d).abs() / 2));

  /// Checks if the convergence is too slow when using inverse quadratic
  /// interpolation (flag is true).
  ///
  /// Returns `true` if `b` and `c` are very close, indicating that bisection
  /// should be used instead.
  bool _condition4(bool flag, double b, double c) =>
      flag && ((b - c).abs() <= tolerance.abs());

  /// Checks if the convergence is too slow when using secant method.
  ///
  /// Returns `true` if `c` and `d` are very close, indicating that bisection
  /// should be used instead.
  bool _condition5(bool flag, double c, double d) =>
      !flag && ((c - d).abs() <= tolerance.abs());

  @override
  ({List<double> guesses, double convergence, double efficiency}) solve() {
    final guesses = <double>[];
    var n = 1;

    final evalA = evaluateOn(a);
    final evalB = evaluateOn(b);

    // Making sure that the root is in the given interval
    if (evalA * evalB >= 0) {
      throw NonlinearException(
        'The root is not bracketed in [$a, $b]. '
        'f(a) and f(b) must have opposite signs.',
      );
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
      final fs = evaluateOn(s).toDouble();
      valueD = valueC;
      valueC = valueB;

      // Update the bracket containing the root
      double newFa;
      double newFb;

      if (fa * fs < 0) {
        valueB = s;
        newFa = fa.toDouble(); // valueA unchanged, so fa is still valid
        newFb = fs; // valueB is now s, so fs is the new fb
      } else {
        valueA = s;
        newFa = fs; // valueA is now s, so fs is the new fa
        newFb = fb.toDouble(); // valueB unchanged, so fb is still valid
      }

      // Ensure valueA always has the larger function value in absolute terms
      // This helps maintain numerical stability
      if (newFa.abs() < newFb.abs()) {
        final temp = valueA;
        valueA = valueB;
        valueB = temp;
      }

      // Updating the exit conditions
      ++n;
      diff = (valueB - valueA).abs();
    }

    return (
      guesses: guesses,
      convergence: convergence(guesses, maxSteps),
      efficiency: efficiency(guesses, maxSteps),
    );
  }
}
