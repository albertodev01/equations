import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/eigenvalue_decomposition/eigen_complex_decomposition.dart';
import 'package:equations/src/system/utils/matrix/decompositions/eigenvalue_decomposition/eigen_real_decomposition.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  group('EigenDecomposition class', () {
    test('Equality tests', () {
      final real = EigendecompositionReal(
        matrix: RealMatrix.fromData(
          rows: 1,
          columns: 1,
          data: [
            [1]
          ],
        ),
      );

      final complex = EigendecompositionComplex(
        matrix: ComplexMatrix.fromData(
          rows: 1,
          columns: 1,
          data: const [
            [Complex.i()]
          ],
        ),
      );

      expect(
        EigendecompositionReal(
          matrix: RealMatrix.fromData(
            rows: 1,
            columns: 1,
            data: [
              [1]
            ],
          ),
        ),
        equals(real),
      );

      expect(
        EigendecompositionReal(
          matrix: RealMatrix.fromData(
            rows: 1,
            columns: 1,
            data: [
              [1]
            ],
          ),
        ).hashCode,
        equals(real.hashCode),
      );

      expect(
        EigendecompositionComplex(
          matrix: ComplexMatrix.fromData(
            rows: 1,
            columns: 1,
            data: const [
              [Complex.i()]
            ],
          ),
        ),
        equals(complex),
      );

      expect(
        EigendecompositionComplex(
          matrix: ComplexMatrix.fromData(
            rows: 1,
            columns: 1,
            data: const [
              [Complex.i()]
            ],
          ),
        ).hashCode,
        equals(complex.hashCode),
      );
    });

    group('Real values', () {
      test('Making sure that EigendecompositionReal works properly', () {
        final sourceMatrix = RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: [
            [1, 0],
            [1, 3],
          ],
        );

        final realEigen = EigendecompositionReal(
          matrix: sourceMatrix,
        );

        final results = realEigen.decompose();
        final matrixV = results[0];
        final matrixD = results[1];
        final matrixVinverse = results[2];

        // Matrices must be square
        expect(matrixV.isSquareMatrix, isTrue);
        expect(matrixD.isSquareMatrix, isTrue);
        expect(matrixVinverse.isSquareMatrix, isTrue);

        // Testing V
        expect(
          matrixV(0, 0),
          const MoreOrLessEquals(-0.8944, precision: 1.0e-4),
        );
        expect(
          matrixV(0, 1),
          const MoreOrLessEquals(0, precision: 1.0e-4),
        );
        expect(
          matrixV(1, 0),
          const MoreOrLessEquals(0.4472, precision: 1.0e-4),
        );
        expect(
          matrixV(1, 1),
          const MoreOrLessEquals(-1.1180, precision: 1.0e-4),
        );

        // Testing D
        expect(
          matrixD(0, 0),
          const MoreOrLessEquals(1, precision: 1.0e-4),
        );
        expect(
          matrixD(0, 1),
          const MoreOrLessEquals(0, precision: 1.0e-4),
        );
        expect(
          matrixD(1, 0),
          const MoreOrLessEquals(0, precision: 1.0e-4),
        );
        expect(
          matrixD(1, 1),
          const MoreOrLessEquals(3, precision: 1.0e-4),
        );

        // Testing V'
        expect(
          matrixVinverse(0, 0),
          const MoreOrLessEquals(-1.1180, precision: 1.0e-4),
        );
        expect(
          matrixVinverse(0, 1),
          const MoreOrLessEquals(0, precision: 1.0e-4),
        );
        expect(
          matrixVinverse(1, 0),
          const MoreOrLessEquals(-0.4472, precision: 1.0e-4),
        );
        expect(
          matrixVinverse(1, 1),
          const MoreOrLessEquals(-0.8944, precision: 1.0e-4),
        );

        // Making sure that V x D x V' = A
        final matrixA = matrixV * matrixD * matrixVinverse;
        expect(matrixA(0, 0), const MoreOrLessEquals(1, precision: 1.0e-1));
        expect(matrixA(0, 1), const MoreOrLessEquals(0, precision: 1.0e-1));
        expect(matrixA(1, 0), const MoreOrLessEquals(1, precision: 1.0e-1));
        expect(matrixA(1, 1), const MoreOrLessEquals(3, precision: 1.0e-1));

        // Smoke on the RealMatrix method
        expect(sourceMatrix.eigenDecomposition(), orderedEquals(results));
        expect(sourceMatrix.toString(), equals(realEigen.toString()));
      });
    });

    group('Complex values', () {
      test('Making sure that EigendecompositionComplex works properly', () {
        final sourceMatrix = ComplexMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [Complex.i(), Complex(5, 1), Complex.fromReal(4)],
            [
              Complex.fromImaginary(-1),
              Complex.fromReal(3),
              Complex.fromReal(1)
            ],
            [Complex(4, 6), Complex.fromReal(2), Complex.zero()],
          ],
        );

        final realEigen = EigendecompositionComplex(
          matrix: sourceMatrix,
        );

        final results = realEigen.decompose();
        final matrixV = results[0];
        final matrixD = results[1];
        final matrixVinverse = results[2];

        // Matrices must be square
        expect(matrixV.isSquareMatrix, isTrue);
        expect(matrixD.isSquareMatrix, isTrue);
        expect(matrixVinverse.isSquareMatrix, isTrue);

        // Testing V
        expect(
          matrixV(0, 0).real,
          const MoreOrLessEquals(0.4887, precision: 1.0e-4),
        );
        expect(
          matrixV(0, 0).imaginary,
          const MoreOrLessEquals(-0.2566, precision: 1.0e-4),
        );
        expect(
          matrixV(0, 1).real,
          const MoreOrLessEquals(-0.6217, precision: 1.0e-4),
        );
        expect(
          matrixV(0, 1).imaginary,
          const MoreOrLessEquals(0.0618, precision: 1.0e-4),
        );
        expect(
          matrixV(0, 2).real,
          const MoreOrLessEquals(0.6812, precision: 1.0e-4),
        );
        expect(
          matrixV(0, 2).imaginary,
          const MoreOrLessEquals(-0.3559, precision: 1.0e-4),
        );
        expect(
          matrixV(1, 0).real,
          const MoreOrLessEquals(0.1659, precision: 1.0e-4),
        );
        expect(
          matrixV(1, 0).imaginary,
          const MoreOrLessEquals(0.0479, precision: 1.0e-4),
        );
        expect(
          matrixV(1, 1).real,
          const MoreOrLessEquals(-0.0873, precision: 1.0e-4),
        );
        expect(
          matrixV(1, 1).imaginary,
          const MoreOrLessEquals(0.2067, precision: 1.0e-4),
        );
        expect(
          matrixV(1, 2).real,
          const MoreOrLessEquals(-1.0084, precision: 1.0e-4),
        );
        expect(
          matrixV(1, 2).imaginary,
          const MoreOrLessEquals(-0.4072, precision: 1.0e-4),
        );
        expect(
          matrixV(2, 0).real,
          const MoreOrLessEquals(-0.9048, precision: 1.0e-4),
        );
        expect(
          matrixV(2, 0).imaginary,
          const MoreOrLessEquals(-0.1298, precision: 1.0e-4),
        );
        expect(
          matrixV(2, 1).real,
          const MoreOrLessEquals(-0.6862, precision: 1.0e-4),
        );
        expect(
          matrixV(2, 1).imaginary,
          const MoreOrLessEquals(-0.3137, precision: 1.0e-4),
        );
        expect(
          matrixV(2, 2).real,
          const MoreOrLessEquals(1.4771, precision: 1.0e-4),
        );
        expect(
          matrixV(2, 2).imaginary,
          const MoreOrLessEquals(0.4958, precision: 1.0e-4),
        );

        // Testing D
        expect(
          matrixD(0, 0).real,
          const MoreOrLessEquals(-4.4551, precision: 1.0e-4),
        );
        expect(
          matrixD(0, 0).imaginary,
          const MoreOrLessEquals(-1.5725, precision: 1.0e-4),
        );
        expect(
          matrixD(0, 1),
          equals(const Complex.zero()),
        );
        expect(
          matrixD(0, 2),
          equals(const Complex.zero()),
        );
        expect(
          matrixD(1, 0),
          equals(const Complex.zero()),
        );
        expect(
          matrixD(1, 1).real,
          const MoreOrLessEquals(5.3472, precision: 1.0e-4),
        );
        expect(
          matrixD(1, 1).imaginary,
          const MoreOrLessEquals(2.0285, precision: 1.0e-4),
        );
        expect(
          matrixD(1, 2),
          equals(const Complex.zero()),
        );
        expect(
          matrixD(2, 0),
          equals(const Complex.zero()),
        );
        expect(
          matrixD(2, 1),
          equals(const Complex.zero()),
        );
        expect(
          matrixD(2, 2).real,
          const MoreOrLessEquals(2.1079, precision: 1.0e-4),
        );
        expect(
          matrixD(2, 2).imaginary,
          const MoreOrLessEquals(0.5440, precision: 1.0e-4),
        );

        // Testing V'
        expect(
          matrixVinverse(0, 0).real,
          const MoreOrLessEquals(0.7957, precision: 1.0e-4),
        );
        expect(
          matrixVinverse(0, 0).imaginary,
          const MoreOrLessEquals(0.3337, precision: 1.0e-4),
        );
        expect(
          matrixVinverse(0, 1).real,
          const MoreOrLessEquals(-0.3699, precision: 1.0e-4),
        );
        expect(
          matrixVinverse(0, 1).imaginary,
          const MoreOrLessEquals(-0.2475, precision: 1.0e-4),
        );
        expect(
          matrixVinverse(0, 2).real,
          const MoreOrLessEquals(-0.6381, precision: 1.0e-4),
        );
        expect(
          matrixVinverse(0, 2).imaginary,
          const MoreOrLessEquals(-0.0188, precision: 1.0e-4),
        );
        expect(
          matrixVinverse(1, 0).real,
          const MoreOrLessEquals(-0.6382, precision: 1.0e-4),
        );
        expect(
          matrixVinverse(1, 0).imaginary,
          const MoreOrLessEquals(-0.3462, precision: 1.0e-4),
        );
        expect(
          matrixVinverse(1, 1).real,
          const MoreOrLessEquals(-1.5117, precision: 1.0e-4),
        );
        expect(
          matrixVinverse(1, 1).imaginary,
          const MoreOrLessEquals(0.3704, precision: 1.0e-4),
        );
        expect(
          matrixVinverse(1, 2).real,
          const MoreOrLessEquals(-0.7274, precision: 1.0e-4),
        );
        expect(
          matrixVinverse(1, 2).imaginary,
          const MoreOrLessEquals(0.0862, precision: 1.0e-4),
        );
        expect(
          matrixVinverse(2, 0).real,
          const MoreOrLessEquals(0.2046, precision: 1.0e-4),
        );
        expect(
          matrixVinverse(2, 0).imaginary,
          const MoreOrLessEquals(-0.0907, precision: 1.0e-4),
        );
        expect(
          matrixVinverse(2, 1).real,
          const MoreOrLessEquals(-0.9865, precision: 1.0e-4),
        );
        expect(
          matrixVinverse(2, 1).imaginary,
          const MoreOrLessEquals(-0.0019, precision: 1.0e-4),
        );
        expect(
          matrixVinverse(2, 2).real,
          const MoreOrLessEquals(-0.1165, precision: 1.0e-4),
        );
        expect(
          matrixVinverse(2, 2).imaginary,
          const MoreOrLessEquals(-0.1430, precision: 1.0e-4),
        );

        // Making sure that V x D x V' = A
        final matrixA = matrixV * matrixD * matrixVinverse;
        expect(
          matrixA(0, 0).real,
          const MoreOrLessEquals(0, precision: 1.0e-1),
        );
        expect(
          matrixA(0, 0).imaginary,
          const MoreOrLessEquals(1, precision: 1.0e-1),
        );
        expect(
          matrixA(0, 1).real,
          const MoreOrLessEquals(5, precision: 1.0e-1),
        );
        expect(
          matrixA(0, 1).imaginary,
          const MoreOrLessEquals(1, precision: 1.0e-1),
        );
        expect(
          matrixA(0, 2).real,
          const MoreOrLessEquals(4, precision: 1.0e-1),
        );
        expect(
          matrixA(0, 2).imaginary,
          const MoreOrLessEquals(0, precision: 1.0e-1),
        );
        expect(
          matrixA(1, 0).real,
          const MoreOrLessEquals(0, precision: 1.0e-1),
        );
        expect(
          matrixA(1, 0).imaginary,
          const MoreOrLessEquals(-1, precision: 1.0e-1),
        );
        expect(
          matrixA(1, 1).real,
          const MoreOrLessEquals(3, precision: 1.0e-1),
        );
        expect(
          matrixA(1, 1).imaginary,
          const MoreOrLessEquals(0, precision: 1.0e-1),
        );
        expect(
          matrixA(1, 2).real,
          const MoreOrLessEquals(1, precision: 1.0e-1),
        );
        expect(
          matrixA(1, 2).imaginary,
          const MoreOrLessEquals(0, precision: 1.0e-1),
        );
        expect(
          matrixA(2, 0).real,
          const MoreOrLessEquals(4, precision: 1.0e-1),
        );
        expect(
          matrixA(2, 0).imaginary,
          const MoreOrLessEquals(6, precision: 1.0e-1),
        );
        expect(
          matrixA(2, 1).real,
          const MoreOrLessEquals(2, precision: 1.0e-1),
        );
        expect(
          matrixA(2, 1).imaginary,
          const MoreOrLessEquals(0, precision: 1.0e-1),
        );
        expect(
          matrixA(2, 2).real,
          const MoreOrLessEquals(0, precision: 1.0e-1),
        );
        expect(
          matrixA(2, 2).imaginary,
          const MoreOrLessEquals(0, precision: 1.0e-1),
        );

        // Smoke on the RealMatrix method
        expect(sourceMatrix.eigenDecomposition(), orderedEquals(results));
        expect(sourceMatrix.toString(), equals(realEigen.toString()));
      });
    });
  });
}
