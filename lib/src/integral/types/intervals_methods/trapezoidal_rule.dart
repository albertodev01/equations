import 'package:equations/equations.dart';
import 'package:equations/src/utils/exceptions/types/numerical_integration_exception.dart';

/// {@template trapezoidal_rule}
/// The trapezoidal rule is a numerical integration technique for approximating
/// definite integrals using linear interpolation. Given a definite integral in
/// the form ∫[a,b] f(x) dx, the trapezoidal rule approximates it as:
///
/// ∫[a,b] f(x) dx ≈ (h/2) * [f(x₀) + 2f(x₁) + 2f(x₂) + ... + 2f(xₙ₋₁) + f(xₙ)]
///
/// where:
/// - h = (b - a) / n is the step size
/// - xᵢ = a + ih for i = 0, 1, 2, ..., n
/// - n is the number of intervals
///
/// The trapezoidal rule has an error bound of O(h²), meaning the error
/// decreases quadratically as the number of intervals increases. The method is
/// exact for linear functions and provides good accuracy for smooth functions.
///
/// This algorithm requires the [intervals] parameter, which indicates how many
/// partitions must be computed by the algorithm. The larger the number of
/// intervals, the better the approximation (but at increased computational
/// cost).
/// {@endtemplate}
base class TrapezoidalRule extends IntervalsIntegration {
  /// {@macro trapezoidal_rule}
  ///
  /// By default, [intervals] is set to `20`. For most applications, this
  /// provides a good balance between accuracy and computational cost.
  const TrapezoidalRule({
    required super.function,
    required super.lowerBound,
    required super.upperBound,
    super.intervals = 20,
  });

  @override
  ({List<double> guesses, double result}) integrate() {
    // Validate that intervals is positive
    if (intervals <= 0) {
      throw const NumericalIntegrationException(
        'The number of intervals must be positive.',
      );
    }

    // Calculate the step size
    final h = (upperBound - lowerBound) / intervals;

    // Evaluate function at the endpoints (these get multiplied by 1/2)
    final fLower = evaluateFunction(lowerBound);
    final fUpper = evaluateFunction(upperBound);

    // Initialize the sum for interior points (these get multiplied by 1)
    var interiorSum = 0.0;

    // Pre-allocate the guesses list for better performance
    final guesses = List<double>.filled(intervals, 0);

    // Evaluate function at interior points (x₁, x₂, ..., xₙ₋₁)
    // These get multiplied by 1 in the final formula
    for (var i = 1; i < intervals; ++i) {
      final x = lowerBound + i * h;
      final fx = evaluateFunction(x);
      interiorSum += fx;
      guesses[i] = fx;
    }

    // Store endpoint values in guesses
    guesses[0] = fLower;

    // Apply trapezoidal rule formula:
    // ∫[a,b] f(x) dx ≈ (h/2) * [f(x₀) + 2 * sum_interior + f(xₙ)]
    final result = (fLower + 2 * interiorSum + fUpper) * h / 2;

    return (
      guesses: guesses,
      result: result,
    );
  }
}
