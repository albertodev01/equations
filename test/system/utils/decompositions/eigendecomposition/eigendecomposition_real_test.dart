import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/eigenvalue_decomposition/eigendecomposition_real.dart';
import 'package:test/test.dart';

void main() {
  group('EigenDecomposition', () {
    test('Equality tests', () {
      final real = EigendecompositionReal(
        matrix: RealMatrix.fromData(
          rows: 1,
          columns: 1,
          data: [
            [1],
          ],
        ),
      );

      expect(
        EigendecompositionReal(
          matrix: RealMatrix.fromData(
            rows: 1,
            columns: 1,
            data: [
              [1],
            ],
          ),
        ),
        equals(real),
      );
      expect(
        real,
        equals(
          EigendecompositionReal(
            matrix: RealMatrix.fromData(
              rows: 1,
              columns: 1,
              data: [
                [1],
              ],
            ),
          ),
        ),
      );

      expect(
        EigendecompositionReal(
          matrix: RealMatrix.fromData(
            rows: 1,
            columns: 1,
            data: [
              [1],
            ],
          ),
        ).hashCode,
        equals(real.hashCode),
      );
    });

    test('decompose() with symmetric matrix', () {
      // Test case 1: Simple 2x2 symmetric matrix
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: [
          [4, 1],
          [1, 3],
        ],
      );

      final decomposition = EigendecompositionReal(matrix: matrix);
      final result = decomposition.decompose();

      // Verify result contains 3 matrices: V, D, V^-1
      expect(result.length, 3);
      expect(result[0].rowCount, 2);
      expect(result[0].columnCount, 2);
      expect(result[1].rowCount, 2);
      expect(result[1].columnCount, 2);
      expect(result[2].rowCount, 2);
      expect(result[2].columnCount, 2);

      // Verify A = VDV^-1
      final reconstructed = result[0] * result[1] * result[2];
      expect(reconstructed, equals(matrix));
    });

    test('decompose() with non-symmetric matrix', () {
      // Test case 2: 2x2 non-symmetric matrix
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: [
          [1, 2],
          [3, 4],
        ],
      );

      final decomposition = EigendecompositionReal(matrix: matrix);
      final result = decomposition.decompose();

      // Verify result contains 3 matrices: V, D, V^-1
      expect(result.length, 3);
      expect(result[0].rowCount, 2);
      expect(result[0].columnCount, 2);
      expect(result[1].rowCount, 2);
      expect(result[1].columnCount, 2);
      expect(result[2].rowCount, 2);
      expect(result[2].columnCount, 2);

      // Verify A = VDV^-1
      final reconstructed = result[0] * result[1] * result[2];
      final rounded = RealMatrix.fromFlattenedData(
        rows: 2,
        columns: 2,
        data: reconstructed.flattenData.map((e) => e.round() * 1.0).toList(),
      );
      expect(matrix, equals(rounded));
    });

    test('decompose() with 3x3 symmetric matrix', () {
      // Test case 3: 3x3 symmetric matrix
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: [
          [2, -1, 0],
          [-1, 2, -1],
          [0, -1, 2],
        ],
      );

      final decomposition = EigendecompositionReal(matrix: matrix);
      final result = decomposition.decompose();

      // Verify result contains 3 matrices: V, D, V^-1
      expect(result.length, 3);
      expect(result[0].rowCount, 3);
      expect(result[0].columnCount, 3);
      expect(result[1].rowCount, 3);
      expect(result[1].columnCount, 3);
      expect(result[2].rowCount, 3);
      expect(result[2].columnCount, 3);

      // Verify A = VDV^-1
      final reconstructed = result[0] * result[1] * result[2];
      final rounded = RealMatrix.fromFlattenedData(
        rows: 3,
        columns: 3,
        data: reconstructed.flattenData.map((e) => e.roundToDouble()).toList(),
      );
      expect(matrix, equals(rounded));
    });

    test('decompose() with 3x3 non-symmetric matrix', () {
      // Test case 4: 3x3 non-symmetric matrix
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9],
        ],
      );

      final decomposition = EigendecompositionReal(matrix: matrix);
      final result = decomposition.decompose();

      // Verify result contains 3 matrices: V, D, V^-1
      expect(result.length, 3);
      expect(result[0].rowCount, 3);
      expect(result[0].columnCount, 3);
      expect(result[1].rowCount, 3);
      expect(result[1].columnCount, 3);
      expect(result[2].rowCount, 3);
      expect(result[2].columnCount, 3);

      // Verify A = VDV^-1
      final reconstructed = result[0] * result[1] * result[2];
      final rounded = RealMatrix.fromFlattenedData(
        rows: 3,
        columns: 3,
        data: reconstructed.flattenData.map((e) => e.roundToDouble()).toList(),
      );
      expect(matrix, equals(rounded));
    });

    test('decompose() with matrix having complex eigenvalues', () {
      // Test case 5: Matrix with complex eigenvalues
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: [
          [0, -1],
          [1, 0],
        ],
      );

      final decomposition = EigendecompositionReal(matrix: matrix);
      final result = decomposition.decompose();

      // Verify result contains 3 matrices: V, D, V^-1
      expect(result.length, 3);
      expect(result[0].rowCount, 2);
      expect(result[0].columnCount, 2);
      expect(result[1].rowCount, 2);
      expect(result[1].columnCount, 2);
      expect(result[2].rowCount, 2);
      expect(result[2].columnCount, 2);

      // Verify A = VDV^-1
      final reconstructed = result[0] * result[1] * result[2];
      expect(reconstructed, equals(matrix));
    });

    test('decompose() with matrix having repeated eigenvalues', () {
      // Test case 6: Matrix with repeated eigenvalues
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: [
          [2, 0],
          [0, 2],
        ],
      );

      final decomposition = EigendecompositionReal(matrix: matrix);
      final result = decomposition.decompose();

      // Verify result contains 3 matrices: V, D, V^-1
      expect(result.length, 3);
      expect(result[0].rowCount, 2);
      expect(result[0].columnCount, 2);
      expect(result[1].rowCount, 2);
      expect(result[1].columnCount, 2);
      expect(result[2].rowCount, 2);
      expect(result[2].columnCount, 2);

      // Verify A = VDV^-1
      final reconstructed = result[0] * result[1] * result[2];
      expect(reconstructed, equals(matrix));
    });

    test('decompose() with matrix having zero eigenvalues', () {
      // Test case 7: Matrix with zero eigenvalues
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: [
          [0, 0],
          [0, 0],
        ],
      );

      final decomposition = EigendecompositionReal(matrix: matrix);
      final result = decomposition.decompose();

      // Verify result contains 3 matrices: V, D, V^-1
      expect(result.length, 3);
      expect(result[0].rowCount, 2);
      expect(result[0].columnCount, 2);
      expect(result[1].rowCount, 2);
      expect(result[1].columnCount, 2);
      expect(result[2].rowCount, 2);
      expect(result[2].columnCount, 2);

      // Verify A = VDV^-1
      final reconstructed = result[0] * result[1] * result[2];
      expect(reconstructed, equals(matrix));
    });

    test('decompose() with matrix having negative eigenvalues', () {
      // Test case 8: Matrix with negative eigenvalues
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: [
          [-1, 0],
          [0, -2],
        ],
      );

      final decomposition = EigendecompositionReal(matrix: matrix);
      final result = decomposition.decompose();

      // Verify result contains 3 matrices: V, D, V^-1
      expect(result.length, 3);
      expect(result[0].rowCount, 2);
      expect(result[0].columnCount, 2);
      expect(result[1].rowCount, 2);
      expect(result[1].columnCount, 2);
      expect(result[2].rowCount, 2);
      expect(result[2].columnCount, 2);

      // Verify A = VDV^-1
      final reconstructed = result[0] * result[1] * result[2];
      expect(reconstructed, equals(matrix));
    });

    test('decompose() with matrix having mixed eigenvalues', () {
      // Test case 9: Matrix with mixed eigenvalues (positive, negative, zero)
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: [
          [1, 0, 0],
          [0, -1, 0],
          [0, 0, 0],
        ],
      );

      final decomposition = EigendecompositionReal(matrix: matrix);
      final result = decomposition.decompose();

      // Verify result contains 3 matrices: V, D, V^-1
      expect(result.length, 3);
      expect(result[0].rowCount, 3);
      expect(result[0].columnCount, 3);
      expect(result[1].rowCount, 3);
      expect(result[1].columnCount, 3);
      expect(result[2].rowCount, 3);
      expect(result[2].columnCount, 3);

      // Verify A = VDV^-1
      final reconstructed = result[0] * result[1] * result[2];
      expect(reconstructed, equals(matrix));
    });

    test('decompose() with matrix having complex conjugate eigenvalues', () {
      // Test case 10: Matrix with complex conjugate eigenvalues
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: [
          [1, -2],
          [2, 1],
        ],
      );

      final decomposition = EigendecompositionReal(matrix: matrix);
      final result = decomposition.decompose();

      // Verify result contains 3 matrices: V, D, V^-1
      expect(result.length, 3);
      expect(result[0].rowCount, 2);
      expect(result[0].columnCount, 2);
      expect(result[1].rowCount, 2);
      expect(result[1].columnCount, 2);
      expect(result[2].rowCount, 2);
      expect(result[2].columnCount, 2);

      // Verify A = VDV^-1
      final reconstructed = result[0] * result[1] * result[2];
      expect(reconstructed, equals(matrix));
    });
  });
}
