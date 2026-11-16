import 'package:equations/equations.dart';

/// {@template boole_rule}
/// Boole's rule is a numerical integration technique that approximates the
/// value of a definite integral using polynomials of degree 4, each of which
/// spans four subintervals. Here are the requirements for this method:
///
/// - [intervals] must be a positive multiple of 4, because each polynomial
///   spans four subintervals;
/// - the function should be continuous on `[lowerBound, upperBound]`;
/// - for the O(h^6) error, the function should also be smooth (its first six
///   derivatives should be continuous).
/// {@endtemplate}
base class BooleRule extends IntervalsIntegration {
  /// {@macro boole_rule}
  ///
  /// By default, [intervals] is set to `32`.
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
  /// Also throws a [NumericalIntegrationException] if [intervals] is not a
  /// positive multiple of 4.
  @override
  ({List<double> guesses, double result}) integrate() {
    // Validate that the bounds are finite
    if (!lowerBound.isFinite || !upperBound.isFinite) {
      throw const NumericalIntegrationException(
        'The integration bounds must be finite.',
      );
    }

    // Validate that intervals is positive
    if (intervals <= 0) {
      throw const NumericalIntegrationException(
        'The number of intervals must be positive.',
      );
    }

    // Validate that intervals is a multiple of 4 (required for Boole's rule)
    if (intervals % 4 != 0) {
      throw const NumericalIntegrationException(
        'The number of intervals must be a multiple of 4.',
      );
    }

    // Calculate the step size
    final h = (upperBound - lowerBound) / intervals;

    // The guesses list stores f(x_0), f(x_1), ..., f(x_n)
    final guesses = List<double>.generate(
      intervals + 1,
      (i) => evaluateFunction(i == intervals ? upperBound : lowerBound + i * h),
      growable: false,
    );

    // The endpoints get multiplied by 7
    var sum = 7 * (guesses.first + guesses.last);

    // Interior points get multiplied by 32 (odd indices), 12 (indices of the
    // form 4k + 2) or 14 (indices of the form 4k, where two polynomials meet)
    for (var i = 1; i < intervals; ++i) {
      final weight = i.isOdd ? 32 : (i % 4 == 2 ? 12 : 14);
      sum += weight * guesses[i];
    }

    // Apply Boole's rule formula: (2h/45) * sum
    return (
      guesses: guesses,
      result: sum * 2 * h / 45,
    );
  }
}
