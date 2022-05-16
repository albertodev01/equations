import 'package:equations_solver/blocs/other_solvers/other_solvers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing events for the 'OtherBloc' bloc", () {
    test('Making sure that a comparison logic is implemented', () {
      const matrixAnalyze = MatrixAnalyze(
        size: 2,
        matrix: ['1', '2', '3', '4'],
      );

      const complexAnalyze = ComplexNumberAnalyze(
        realPart: '2',
        imaginaryPart: '4',
      );

      expect(
        matrixAnalyze,
        equals(
          const MatrixAnalyze(
            size: 2,
            matrix: ['1', '2', '3', '4'],
          ),
        ),
      );

      expect(
        matrixAnalyze,
        isNot(
          const MatrixAnalyze(
            size: 2,
            matrix: ['1', '2', '3', '4.'],
          ),
        ),
      );

      expect(
        complexAnalyze,
        equals(
          const ComplexNumberAnalyze(
            realPart: '2',
            imaginaryPart: '4',
          ),
        ),
      );

      expect(
        complexAnalyze,
        isNot(
          const ComplexNumberAnalyze(
            realPart: '2',
            imaginaryPart: '4,',
          ),
        ),
      );

      expect(
        const OtherClean(),
        equals(const OtherClean()),
      );

      expect(const OtherClean().props.length, isZero);
    });
  });
}
