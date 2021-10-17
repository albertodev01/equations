import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/other_solvers/other_solvers.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the 'MatrixDataAnalyzer' class", () {
    test('Making sure that object comparison works properly', () {
      const analyzer = MatrixDataAnalyzer(
        size: 2,
        flatMatrix: ['1', '2', '3', '4'],
      );

      expect(
        analyzer,
        equals(
          const MatrixDataAnalyzer(
            size: 2,
            flatMatrix: ['1', '2', '3', '4'],
          ),
        ),
      );
      expect(
        analyzer,
        isNot(
          const MatrixDataAnalyzer(
            size: 2,
            flatMatrix: ['2', '3', '4'],
          ),
        ),
      );
      expect(
        analyzer,
        isNot(
          const MatrixDataAnalyzer(
            size: 2,
            flatMatrix: ['1', '2', '3', '4.1'],
          ),
        ),
      );

      expect(analyzer.props.length, equals(2));
    });

    test(
      'Making sure that ax exception is thrown in case of malformed input',
      () {
        expect(
          () => const MatrixDataAnalyzer(
            size: 2,
            flatMatrix: ['1', '2', '3', ''],
          ).process(),
          throwsA(isA<Exception>()),
        );

        expect(
          () => const MatrixDataAnalyzer(
            size: 1,
            flatMatrix: ['1', '2'],
          ).process(),
          throwsA(isA<Exception>()),
        );
      },
    );

    test('Making sure that a matrix correctly analyzed', () {
      final result = const MatrixDataAnalyzer(
        size: 2,
        flatMatrix: ['1', '2', '3', '4'],
      ).process();

      final actualValue = RealMatrix.fromFlattenedData(
        rows: 2,
        columns: 2,
        data: [1, 2, 3, 4],
      );

      expect(result.transpose, equals(actualValue.transpose()));
      expect(result.inverse, equals(actualValue.inverse()));
      expect(result.eigenvalues, equals(actualValue.eigenvalues()));
      expect(
        result.characteristicPolynomial,
        equals(actualValue.characteristicPolynomial()),
      );
      expect(result.determinant, equals(actualValue.determinant()));
      expect(result.rank, equals(actualValue.rank()));
      expect(result.trace, equals(actualValue.trace()));
      expect(result.cofactorMatrix, equals(actualValue.cofactorMatrix()));
    });
  });
}
