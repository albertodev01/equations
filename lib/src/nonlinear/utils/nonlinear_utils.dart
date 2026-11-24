import 'package:equations/equations.dart';

/// Utility methods shared by the [NonLinear] root-finding algorithms.
// ignore: avoid_classes_with_only_static_members
abstract final class NonLinearUtils {
  /// Builds the record returned by [NonLinear.solve] of the given [method] from
  /// the [guesses] it generated. The convergence and the efficiency are
  /// computed using the number of guesses as number of steps.
  static ({
    List<double> guesses,
    double convergence,
    double efficiency,
  })
  resultOf(NonLinear method, List<double> guesses) {
    return (
      guesses: guesses,
      convergence: method.convergence(guesses, guesses.length),
      efficiency: method.efficiency(guesses, guesses.length),
    );
  }

  /// Throws a [NonlinearException] when [fx], the value of the function at
  /// [x], is NaN or infinite.
  static void checkFiniteValue(double x, double fx) {
    if (!fx.isFinite) {
      throw NonlinearException(
        "Couldn't evaluate f($x). "
        'The function value is ${fx.isNaN ? "NaN" : "infinite"}.',
      );
    }
  }

  /// Throws a [NonlinearException] when [fa] and [fb], the values of the
  /// function at [a] and [b], are not finite or when they have the same sign.
  /// Either value can be zero, which means that the root is one of the
  /// endpoints.
  ///
  /// The signs are compared instead of checking `fa * fb < 0` because the
  /// product can underflow to zero (or overflow) when the values are very small
  /// (or very large).
  static void checkBracket(double a, double fa, double b, double fb) {
    checkFiniteValue(a, fa);
    checkFiniteValue(b, fb);

    if (fa != 0 && fb != 0 && fa.sign == fb.sign) {
      throw NonlinearException(
        'The root is not bracketed in [$a, $b]. '
        'f(a) and f(b) must have opposite signs.',
      );
    }
  }
}
