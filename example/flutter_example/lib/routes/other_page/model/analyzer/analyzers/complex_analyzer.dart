import 'package:equations/equations.dart';
import 'package:equations_solver/routes/other_page/model/analyzer/analyzer.dart';
import 'package:equations_solver/routes/other_page/model/analyzer/wrappers/complex_result_wrapper.dart';

/// Analyzes a complex number and computes various values:
///
///  - the module
///  - the conjugate
///  - the phase
///  - the reciprocal
///  - the square root
///  - the polar coordinates conversion
final class ComplexNumberAnalyzer extends Analyzer<ComplexResultWrapper> {
  /// Real part of the complex number.
  final String realPart;

  /// Imaginary part of the complex number.
  final String imaginaryPart;

  /// Creates a [ComplexNumberAnalyzer] object.
  const ComplexNumberAnalyzer({
    required this.realPart,
    required this.imaginaryPart,
  });

  @override
  ComplexResultWrapper process() {
    final real = valueParser(realPart);
    final imaginary = valueParser(imaginaryPart);
    final complex = Complex(real, imaginary);

    return ComplexResultWrapper(
      abs: complex.abs(),
      conjugate: complex.conjugate(),
      phase: complex.phase(),
      reciprocal: complex.reciprocal(),
      sqrt: complex.sqrt(),
      polarComplex: complex.toPolarCoordinates(),
    );
  }
}
