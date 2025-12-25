import 'package:equations/equations.dart';

/// {@template adaptive_quadrature}
/// The "Adaptive quadrature" is a technique for approximating the value of a
/// definite integral that automatically adjusts the step size based on the
/// local behavior of the function being integrated.
///
/// ## Details
///
/// Unlike fixed-step methods like Simpson's rule or the trapezoidal method,
/// adaptive quadrature:
///
/// - Uses smaller step sizes in regions where the function varies rapidly
/// - Uses larger step sizes in regions where the function is smooth
/// - Automatically determines the best subdivision of the integration interval
/// - Provides better accuracy with fewer function evaluations
///
/// The algorithm works by:
///
/// 1. Computing two different approximations of the same subinterval
/// 2. Comparing their difference to a tolerance value
/// 3. If the difference is small enough, accepting the more accurate result
/// 4. If not, subdividing the interval and recursively applying the method
///
/// This approach makes adaptive quadrature particularly effective for functions
/// with varying smoothness or regions of high curvature.
///
/// This algorithm requires two initial points ([lowerBound] and [upperBound])
/// that indicate the lower and upper integration bounds.
/// {@endtemplate}
final class AdaptiveQuadrature extends NumericalIntegration {
  /// {@macro adaptive_quadrature}
  const AdaptiveQuadrature({
    required super.function,
    required super.lowerBound,
    required super.upperBound,
  });

  /// Uses the "adaptive quadrature" algorithm to evaluate the integral between
  /// [a] and [b].
  double _adaptive(double a, double b, List<double> guesses) {
    const tolerance = 1.0e-10;

    final h = b - a;
    final c = (a + b) / 2.0;
    final d = (a + c) / 2.0;
    final e = (b + c) / 2.0;

    final fa = evaluateFunction(a);
    final fb = evaluateFunction(b);

    final q1 = h / 6 * (fa + 4 * evaluateFunction(c) + fb);
    final q2 =
        h /
        12 *
        (fa +
            4 * evaluateFunction(d) +
            2 * evaluateFunction(c) +
            4 * evaluateFunction(e) +
            fb);

    if ((q2 - q1).abs() <= tolerance) {
      final result = q2 + (q2 - q1) / 15;

      guesses.add(result);
      return result;
    } else {
      return _adaptive(a, c, guesses) + _adaptive(c, b, guesses);
    }
  }

  @override
  ({List<double> guesses, double result}) integrate() {
    final guesses = <double>[];
    final result = _adaptive(lowerBound, upperBound, guesses);

    return (
      guesses: guesses,
      result: result,
    );
  }
}
