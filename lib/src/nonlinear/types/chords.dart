import 'package:equations/equations.dart';
import 'package:equations/src/nonlinear/utils/nonlinear_utils.dart';

/// {@template chords}
/// Implements the 'chords' method to find the roots of a given equation.
///
///   - The method is guaranteed to converge to a root of `f(x)` if `f(x)` is a
///   continuous function on the interval `[a, b]`.
///
///   - The values of `f(a)` and `f(b)` must have opposite signs, which ensures
///   that at least one root exists in the interval by the Intermediate Value
///   Theorem. If `f(a)` or `f(b)` is zero, that endpoint is returned as the
///   root.
///
///   - The first guess is the point where the chord through `(a, f(a))` and
///   `(b, f(b))` crosses the x-axis. Every next guess is the point where the
///   chord through the current guess `(x, f(x))` and one of the two original
///   endpoints crosses the x-axis. The endpoint is chosen so that the root is
///   between it and `x`. Unlike [RegulaFalsi], the endpoints `a` and `b` never
///   change.
///
///   - The method has linear convergence rate and stops when
///   `|f(x)| < [tolerance]`.
/// {@endtemplate}
final class Chords extends NonLinear {
  /// {@macro chords}
  const new({
    required super.function,
    required this.a,
    required this.b,
    super.tolerance = 1.0e-10,
    super.maxSteps = 30,
  });

  /// The starting point of the interval.
  final double a;

  /// The ending point of the interval.
  final double b;

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
    final fa = evaluateOn(a);
    final fb = evaluateOn(b);
    NonLinearUtils.checkBracket(a, fa, b, fb);

    // One of the endpoints is already a root
    if (fa == 0) {
      return NonLinearUtils.resultOf(this, [a]);
    }
    if (fb == 0) {
      return NonLinearUtils.resultOf(this, [b]);
    }

    // The first guess is where the chord through (a, f(a)) and (b, f(b))
    // crosses the x-axis
    var x = (a * fb - b * fa) / (fb - fa);
    var fx = evaluateOn(x);
    NonLinearUtils.checkFiniteValue(x, fx);

    final guesses = [x];

    while (fx != 0 && fx.abs() >= tolerance && guesses.length < maxSteps) {
      // The chord goes through the endpoint whose function value has the
      // opposite sign of f(x), so that the root is between it and x
      x = fa.sign != fx.sign
          ? (x * fa - a * fx) / (fa - fx)
          : (x * fb - b * fx) / (fb - fx);
      fx = evaluateOn(x);
      NonLinearUtils.checkFiniteValue(x, fx);

      guesses.add(x);
    }

    return NonLinearUtils.resultOf(this, guesses);
  }
}
