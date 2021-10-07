import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/other_solvers/models/analyzer.dart';
import 'package:equations_solver/blocs/other_solvers/other_solvers.dart';

/// Analyzes a complex number and computes various results:
///
///  - the module
///  - the conjugate
///  - the phase
///  - the reciprocal
///  - the square root
///  - the polar coordinates conversion
class ComplexNumberAnalyzer extends Analyzer<AnalyzedComplexNumber> {
  /// The real part of the complex number be analyzed.
  final String realPart;

  /// The imaginary part of the complex number be analyzed.
  final String imaginaryPart;

  /// Creates a [ComplexNumberAnalyzer] object.
  const ComplexNumberAnalyzer({
    required this.realPart,
    required this.imaginaryPart,
  });

  @override
  AnalyzedComplexNumber process() {
    // Building the matrix
    final real = valueParser(realPart);
    final imag = valueParser(imaginaryPart);

    final complex = Complex(real, imag);

    return AnalyzedComplexNumber(
      abs: complex.abs(),
      conjugate: complex.conjugate(),
      phase: complex.phase(),
      reciprocal: complex.reciprocal(),
      sqrt: complex.sqrt(),
      polarComplex: complex.toPolarCoordinates(),
    );
  }
}
