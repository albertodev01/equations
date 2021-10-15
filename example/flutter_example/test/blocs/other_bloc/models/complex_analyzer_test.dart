import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/other_solvers/other_solvers.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the 'ComplexNumberAnalyzer' class", () {
    test('Making sure that object comparison works properly', () {
      const analyzer = ComplexNumberAnalyzer(
        realPart: '3',
        imaginaryPart: '2',
      );

      expect(
        analyzer,
        equals(
          const ComplexNumberAnalyzer(
            realPart: '3',
            imaginaryPart: '2',
          ),
        ),
      );
      expect(
        analyzer,
        isNot(
          const ComplexNumberAnalyzer(
            realPart: '',
            imaginaryPart: '2',
          ),
        ),
      );
      expect(
        analyzer,
        isNot(
          const ComplexNumberAnalyzer(
            realPart: '3',
            imaginaryPart: '',
          ),
        ),
      );

      expect(analyzer.props.length, equals(2));
    });

    test('Making sure that ax exception is thrown in case of malformed input',
        () {
      const analyzer = ComplexNumberAnalyzer(
        realPart: '',
        imaginaryPart: '2',
      );

      expect(
        () => analyzer.process(),
        throwsA(isA<Exception>()),
      );
    });

    test('Making sure that a Complex number is correctly analyzed', () {
      final result = const ComplexNumberAnalyzer(
        realPart: '3',
        imaginaryPart: '2',
      ).process();

      const actualValue = Complex(3, 2);

      expect(result.reciprocal, equals(actualValue.reciprocal()));
      expect(result.conjugate, equals(actualValue.conjugate()));
      expect(result.sqrt, equals(actualValue.sqrt()));
      expect(result.phase, equals(actualValue.phase()));
      expect(result.abs, equals(actualValue.abs()));
      expect(result.polarComplex, equals(actualValue.toPolarCoordinates()));
    });
  });
}
