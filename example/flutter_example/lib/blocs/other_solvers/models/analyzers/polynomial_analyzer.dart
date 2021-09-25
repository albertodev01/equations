import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/other_solvers/models/analyzer.dart';
import 'package:equations_solver/blocs/other_solvers/other_solvers.dart';

/// Analyzes a polynomial and computes various results:
///
///  - the derivative
///  - the discriminant
///  - the roots (the solutions of the equation P(x) = 0)
class PolynomialDataAnalyzer extends Analyzer<AnalyzedPolynomial> {
  /// The polynomial to be analyzed.
  final List<String> polynomial;

  /// Creates a [PolynomialDataAnalyzer] object.
  const PolynomialDataAnalyzer({
    required this.polynomial,
  });

  @override
  AnalyzedPolynomial process() {
    // Building the matrix
    final data = valuesParser(polynomial);
    final algebraic = Algebraic.fromReal(data);

    return AnalyzedPolynomial(
      derivative: algebraic.derivative(),
      discriminant: algebraic.discriminant(),
      roots: algebraic.solutions(),
    );
  }
}
