import 'package:equations/equations.dart';

/// {@template simpson_rule}
/// Simpson's Rule is a numerical integration technique that approximates the
/// value of a definite integral using quadratic polynomials. Given the integral
/// of f(x) from a to b, Simpson's rule approximates it as:
///
///   (h/3) * [f(x_0) + 4f(x_1) + 2f(x_2) + ... + 4f(x_(n-1)) + f(x_n)]
///
/// where:
/// - h = (b - a) / n is the step size
/// - n is the number of intervals (must be even)
/// - x_i = a + i*h for i = 0, 1, 2, ..., n
///
/// Simpson's Rule has an error of O(h^4), making it more accurate than the
/// Trapezoidal Rule (O(h^2)) for smooth functions. The method is exact for
/// polynomials of degree 3 or less. Here are the requirements for this method:
///
/// - [intervals] must be a positive even number, because each quadratic
///   polynomial spans two subintervals;
/// - the function should be continuous on `[lowerBound, upperBound]`;
/// {@endtemplate}
base class SimpsonRule extends IntervalsIntegration {
  /// {@macro simpson_rule}
  ///
  /// By default, [intervals] is set to `32`. For most applications, this
  /// provides a good balance between accuracy and computational cost.
  const new({
    required super.function,
    required super.lowerBound,
    required super.upperBound,
    super.intervals = 32,
  });

  /// {@macro numerical_integration.integrate}
  ///
  /// The `guesses` list contains the values of [function] at the points
  /// `x_i = lowerBound + i * h`, for `i = 0, 1, ..., intervals`, so it has
  /// `intervals + 1` elements.
  ///
  /// Also throws a [NumericalIntegrationException] if [intervals] is not
  /// positive or odd.
  @override
  ({List<double> guesses, double result}) integrate() {
    if (!lowerBound.isFinite || !upperBound.isFinite) {
      throw const NumericalIntegrationException(
        'The integration bounds must be finite.',
      );
    }
    if (intervals <= 0) {
      throw const NumericalIntegrationException(
        'The number of intervals must be positive.',
      );
    }
    if (intervals % 2 != 0) {
      throw const NumericalIntegrationException(
        'The number of intervals must be even.',
      );
    }

    final h = (upperBound - lowerBound) / intervals;

    // Initialize sums for the Simpson's Rule formula
    // oddSum: sum of f(x) at odd-indexed points (multiplied by 4)
    // evenSum: sum of f(x) at even-indexed points (multiplied by 2)
    var oddSum = 0.0;
    var evenSum = 0.0;
    final guesses = List<double>.filled(intervals + 1, 0);

    for (var i = 1; i < intervals; i += 2) {
      final x = lowerBound + i * h;
      final fx = evaluateFunction(x);
      oddSum += fx;
      guesses[i] = fx;
    }

    for (var i = 2; i < intervals - 1; i += 2) {
      final x = lowerBound + i * h;
      final fx = evaluateFunction(x);
      evenSum += fx;
      guesses[i] = fx;
    }

    final fLower = evaluateFunction(lowerBound);
    final fUpper = evaluateFunction(upperBound);
    guesses[0] = fLower;
    guesses[intervals] = fUpper;

    return (
      guesses: guesses,
      result: (fLower + 4 * oddSum + 2 * evenSum + fUpper) * h / 3,
    );
  }
}
