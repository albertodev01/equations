import 'package:equations/equations.dart';

/// The "Adaptive quadrature" is a technique for approximating the value of a
/// definite integral.
///
/// This algorithm requires two initial points ([lowerBound] and [upperBound])
/// that indicate the lower and upper integration bounds.
final class AdaptiveQuadrature extends NumericalIntegration {
  /// Creates a [AdaptiveQuadrature] object.
  const AdaptiveQuadrature({
    required super.function,
    required super.lowerBound,
    required super.upperBound,
  });

  /// Uses the "adaptive quadrature" algorithm to evaluate the integral within
  /// [a] and [b].
  double _adaptive(double a, double b, List<double> guesses) {
    const tolerance = 1.0e-8;

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
