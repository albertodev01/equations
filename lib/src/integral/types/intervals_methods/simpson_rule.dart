import 'package:equations/equations.dart';
import 'package:equations/src/utils/exceptions/types/numerical_integration_exception.dart';

/// {@template simpson_rule}
/// Simpson's Rule is a numerical integration technique that approximates the
/// value of a definite integral using quadratic polynomials. Given a definite
/// integral in the form ∫`[a,b]` f(x) dx, Simpson's rule approximates it as:
///
/// ∫`[a,b]` f(x) dx ≈ (h/3) * `[f(x₀) + 4f(x₁) + 2f(x₂) + ... + 4f(xₙ₋₁) + f(xₙ)]`
///
/// where:
/// - h = (b - a) / n is the step size
/// - n is the number of intervals (must be even)
/// - xᵢ = a + ih for i = 0, 1, 2, ..., n
///
/// Simpson's Rule has an error bound of O(h^4), making it more accurate than
/// the Trapezoidal Rule (O(h^4)) for smooth functions. The method is exact for
/// polynomials of degree 3 or less. Here are the requirements for this method:
///
/// - [intervals] must be an even number (required for quadratic approximation);
/// - the function should be continuous on `[lowerBound, upperBound]`;
/// - for best accuracy, the function should be smooth (few discontinuities).
/// {@endtemplate}
base class SimpsonRule extends IntervalsIntegration {
  /// {@macro simpson_rule}
  ///
  /// By default, [intervals] is set to `32`. For most applications, this
  /// provides a good balance between accuracy and computational cost.
  const SimpsonRule({
    required super.function,
    required super.lowerBound,
    required super.upperBound,
    super.intervals = 32,
  });

  @override
  ({List<double> guesses, double result}) integrate() {
    // Validate that intervals is even (required for Simpson's Rule)
    if (intervals % 2 != 0) {
      throw const NumericalIntegrationException(
        'There must be an even number of partitions.',
      );
    }

    // Validate that intervals is positive
    if (intervals <= 0) {
      throw const NumericalIntegrationException(
        'The number of intervals must be positive. ',
      );
    }

    // Calculate the step size
    final h = (upperBound - lowerBound) / intervals;

    // Initialize sums for the Simpson's Rule formula
    // oddSum: sum of f(x) at odd-indexed points (multiplied by 4)
    // evenSum: sum of f(x) at even-indexed points (multiplied by 2)
    var oddSum = 0.0;
    var evenSum = 0.0;

    // Pre-allocate the guesses list for better performance
    final guesses = List<double>.filled(intervals, 0);

    // Evaluate function at odd-indexed points (x₁, x₃, x₅, ..., xₙ₋₁)
    // These get multiplied by 4 in the final formula
    for (var i = 1; i < intervals; i += 2) {
      final x = lowerBound + i * h;
      final fx = evaluateFunction(x);
      oddSum += fx;
      guesses[i] = fx;
    }

    // Evaluate function at even-indexed points (x₂, x₄, x₆, ..., xₙ₋₂)
    // These get multiplied by 2 in the final formula
    for (var i = 2; i < intervals - 1; i += 2) {
      final x = lowerBound + i * h;
      final fx = evaluateFunction(x);
      evenSum += fx;
      guesses[i] = fx;
    }

    // Evaluate function at the endpoints (x₀ and xₙ)
    final fLower = evaluateFunction(lowerBound);
    final fUpper = evaluateFunction(upperBound);
    guesses[0] = fLower;
    guesses[intervals - 1] = fUpper;

    // Apply Simpson's Rule formula:
    // ∫[a,b] f(x) dx ≈ (h/3) * [f(x₀) + 4*sum_odd + 2*sum_even + f(xₙ)]
    final result = (fLower + 4 * oddSum + 2 * evenSum + fUpper) * h / 3;

    return (
      guesses: guesses,
      result: result,
    );
  }
}
