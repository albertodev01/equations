/// When it comes to analysis, the term **numerical integration** indicates a
/// group of algorithms for calculating the numerical value of a definite
/// integral on an interval.
///
/// Subtypes of [NumericalIntegration] are expected to mostly implement the so
/// called "the Newton–Cotes formulas".
abstract class NumericalIntegration {
  /// The lower bound of the integral
  final double lowerBound;

  /// The upper bound of the integral
  final double upperBound;

  /// The function to be integrated between [lowerBound] and [upperBound]
  final String function;

  /// Expects the [function] to be integrated between [lowerBound] and
  /// [upperBound].
  const NumericalIntegration({
    required this.lowerBound,
    required this.upperBound,
    required this.function,
  });

  /// Calculates the numerical value of the [function] **definite** integral
  /// between [lowerBound] and [upperBound].
  List<double> integrate();
}