import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  group("Testing the constructors of the 'RealMatrix' class", () {
    test('Making sure that a new matrix is initialized with 0s.', () {
      final matrix = RealMatrix(
        columns: 5,
        rows: 3,
      );

      // Checking the sizes
      expect(matrix.rowCount, equals(3));
      expect(matrix.columnCount, equals(5));
      expect(matrix.isSquareMatrix, isFalse);

      // Checking the content of the matrix
      for (var i = 0; i < matrix.rowCount; ++i) {
        for (var j = 0; j < matrix.columnCount; ++j) {
          expect(matrix(i, j), isZero);
          expect(matrix(i, j), equals(matrix.itemAt(i, j)));
        }
      }
    });

    test(
        'Making sure that an exception is thrown when the user tries to '
        'build a matrix whose row or column count is zero.', () {
      expect(
        () => RealMatrix(columns: 0, rows: 2),
        throwsA(isA<MatrixException>()),
      );
    });

    test(
        'Making sure that the identity matrix is filled with 0s except for '
        'its diagonal, which must contain all 1s.', () {
      final matrix = RealMatrix(columns: 3, rows: 3, identity: true);

      // Checking the sizes
      expect(matrix.rowCount, equals(3));
      expect(matrix.columnCount, equals(3));

      // Checking the content of the matrix
      for (var i = 0; i < matrix.rowCount; ++i) {
        for (var j = 0; j < matrix.columnCount; ++j) {
          if (i == j) {
            expect(matrix(i, j), equals(1));
          } else {
            expect(matrix(i, j), isZero);
          }
          expect(matrix(i, j), equals(matrix.itemAt(i, j)));
        }
      }
    });

    test(
        'Making sure that an exception is thrown when the user tries to '
        'build an identity matrix with a non-squared entry.', () {
      expect(
        () => RealMatrix(columns: 3, rows: 5, identity: true),
        throwsA(isA<MatrixException>()),
      );
    });

    test(
        "Making sure that the matrix can correctly be 'flattened' and converted"
        " into a list of 'double' values.", () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: [
          [1, 2],
          [3, 4]
        ],
      );

      // Checking the sizes
      final flattenedMatrix = matrix.toList();

      expect(flattenedMatrix.length, equals(4));
      expect(flattenedMatrix, orderedEquals(<double>[1, 2, 3, 4]));
    });

    test(
        "Making sure that the matrix can correctly be created from a 'flattened' "
        'list of values.', () {
      final matrix = RealMatrix.fromFlattenedData(
        rows: 2,
        columns: 2,
        data: [1, 2, 3, 4],
      );

      expect(matrix.rowCount * matrix.columnCount, equals(4));
      expect(
        matrix,
        equals(RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: [
            [1, 2],
            [3, 4],
          ],
        )),
      );
    });

    test(
        'Making sure that an exception is thrown when the matrix is being built '
        'from a list but the sizes are wrong', () {
      expect(
        () => RealMatrix.fromFlattenedData(
          rows: 6,
          columns: 2,
          data: [1, 2, 3, 4],
        ),
        throwsA(isA<Exception>()),
      );
    });

    test("Making sure that 'toString()' works as expected.", () {
      final matrix = RealMatrix.fromData(columns: 3, rows: 3, data: const [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
      ]);

      const expected = '[1.0, 2.0, 3.0]\n'
          '[4.0, 5.0, 6.0]\n'
          '[7.0, 8.0, 9.0]';
      expect(matrix.toString(), equals(expected));
    });

    test(
        'Making sure that a matrix is properly built from a list of lists '
        'entries.', () {
      final matrix = RealMatrix.fromData(columns: 3, rows: 3, data: const [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
      ]);

      // Checking the sizes
      expect(matrix.rowCount, equals(3));
      expect(matrix.columnCount, equals(3));

      // Checking the content of the matrix
      expect(matrix(0, 0), equals(1));
      expect(matrix(0, 1), equals(2));
      expect(matrix(0, 2), equals(3));
      expect(matrix(1, 0), equals(4));
      expect(matrix(1, 1), equals(5));
      expect(matrix(1, 2), equals(6));
      expect(matrix(2, 0), equals(7));
      expect(matrix(2, 1), equals(8));
      expect(matrix(2, 2), equals(9));
    });
  });

  group("Testing equality of 'RealMatrix' objects", () {
    test('Making sure that objects comparison works properly.', () {
      final matrix = RealMatrix(
        columns: 2,
        rows: 2,
      );

      // Equality tests
      expect(RealMatrix(columns: 2, rows: 2), equals(matrix));
      expect(RealMatrix(columns: 2, rows: 2) == matrix, isTrue);
      expect(RealMatrix(columns: 2, rows: 2).hashCode, equals(matrix.hashCode));

      // Inequality tests
      expect(
        RealMatrix(columns: 2, rows: 2, identity: true) == matrix,
        isFalse,
      );
      expect(
        RealMatrix(columns: 2, rows: 1).hashCode == matrix.hashCode,
        isFalse,
      );
    });
  });

  group("Testing operators on 'RealMatrix' (+, *, - and /)", () {
    /*
    * A = |  2  6  |
    *     | -5  0  |
    * */
    final matrixA = RealMatrix.fromData(columns: 2, rows: 2, data: const [
      [2, 6],
      [-5, 0],
    ]);

    /*
    * B = | -4  1  |
    *     |  7 -3  |
    * */
    final matrixB = RealMatrix.fromData(columns: 2, rows: 2, data: const [
      [-4, 1],
      [7, -3],
    ]);

    test('Making sure that operator+ works properly.', () {
      final matrixSum = RealMatrix.fromData(columns: 2, rows: 2, data: [
        [-2, 7],
        [2, -3],
      ]);
      expect(matrixA + matrixB, equals(matrixSum));
    });

    test('Making sure that operator- works properly.', () {
      final matrixSub = RealMatrix.fromData(columns: 2, rows: 2, data: [
        [6, 5],
        [-12, 3],
      ]);
      expect(matrixA - matrixB, equals(matrixSub));
    });

    test('Making sure that operator* works properly.', () {
      final matrixMul = RealMatrix.fromData(columns: 2, rows: 2, data: [
        [34, -16],
        [20, -5],
      ]);
      expect(matrixA * matrixB, equals(matrixMul));
    });

    test('Making sure that operator/ works properly.', () {
      final matrixDiv = RealMatrix.fromData(columns: 2, rows: 2, data: [
        [-1 / 2, 6],
        [-5 / 7, 0],
      ]);
      expect(matrixA / matrixB, equals(matrixDiv));
    });

    test('Making sure that operator* works on non-square matrices.', () {
      final matrixA = RealMatrix.fromData(
        columns: 2,
        rows: 2,
        data: [
          [2, 4],
          [1, -3],
        ],
      );

      final matrixB = RealMatrix.fromData(
        columns: 3,
        rows: 2,
        data: [
          [6, 0, 4],
          [-1, 0, 2],
        ],
      );

      final matrixMul = RealMatrix.fromData(
        columns: 3,
        rows: 2,
        data: [
          [8, 0, 16],
          [9, 0, -2],
        ],
      );

      expect(matrixA * matrixB, equals(matrixMul));
    });
  });

  group('Testing the computation of the determinant.', () {
    test('Making sure that the determinant of an 1*1 matrix is correct.', () {
      final matrix = RealMatrix.fromData(columns: 1, rows: 1, data: [
        [-5]
      ]);
      expect(matrix.determinant(), equals(-5));
    });

    test('Making sure that the determinant of a 2*2 matrix is correct.', () {
      final matrix = RealMatrix.fromData(columns: 2, rows: 2, data: [
        [6, 5],
        [-12, 3],
      ]);
      expect(matrix.determinant(), equals(78));
    });

    test('Making sure that the determinant of a 3*3 matrix is correct.', () {
      final matrix = RealMatrix.fromData(columns: 3, rows: 3, data: [
        [2, -1, 0],
        [11, 0, 7],
        [6, 1, 1],
      ]);
      expect(matrix.determinant(), equals(-45));
    });

    test('Making sure that the determinant of a 4*4 matrix is correct.', () {
      final matrix = RealMatrix.fromData(columns: 4, rows: 4, data: [
        [2, -1, 13, 4],
        [11, 0, 1, 7],
        [6, -4, 7, 2],
        [1, -1, 3, 0],
      ]);
      expect(matrix.determinant(), equals(271));
    });

    test(
        'Making sure that the determinant of a 5*5 (or greater) matrix is '
        'correct.', () {
      final matrix = RealMatrix.fromData(columns: 5, rows: 5, data: [
        [2, -1, 13, 4, 1],
        [11, 0, 5, 1, 7],
        [6, -4, 7, 2, -6],
        [1, 0, -3, -6, 9],
        [7, 0, 3, -4, 1],
      ]);
      expect(
          matrix.determinant(), const MoreOrLessEquals(-28398, precision: 0.1));
    });
  });

  group('Testing operations on matrices.', () {
    test(
        'Making sure that the LU decomposition properly works on a square '
        'matrix of a given dimension.', () {
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9],
        ],
      );

      // Decomposition
      final lu = matrix.luDecomposition();
      expect(lu.length, equals(2));

      // Checking L
      final L = lu[0];
      expect(L.rowCount, equals(matrix.rowCount));
      expect(L.columnCount, equals(matrix.columnCount));
      expect(L.isSquareMatrix, isTrue);
      expect(
        L.flattenData,
        orderedEquals(<double>[1, 0, 0, 4, 1, 0, 7, 2, 1]),
      );

      // Checking U
      final U = lu[1];
      expect(U.rowCount, equals(matrix.rowCount));
      expect(U.columnCount, equals(matrix.columnCount));
      expect(U.isSquareMatrix, isTrue);
      expect(
        U.flattenData,
        orderedEquals(<double>[1, 2, 3, 0, -3, -6, 0, 0, 0]),
      );
    });

    test(
        "Making sure that the LU decomposition properly doesn't work when "
        'the matrix is not square.', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 3,
        data: const [
          [1, 2, 3],
          [4, 5, 6],
        ],
      );

      // Decomposition
      expect(matrix.luDecomposition, throwsA(isA<MatrixException>()));
    });

    test(
        'Making sure that Cholesky decomposition properly works on a square '
        'matrix of a given dimension.', () {
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [25, 15, -5],
          [15, 18, 0],
          [-5, 0, 11],
        ],
      );

      // Decomposition
      final cholesky = matrix.choleskyDecomposition();
      expect(cholesky.length, equals(2));

      // Checking L
      final L = cholesky[0];
      expect(
        L.flattenData,
        orderedEquals(<double>[5, 0, 0, 3, 3, 0, -1, 1, 3]),
      );
      expect(L.rowCount, equals(matrix.rowCount));
      expect(L.columnCount, equals(matrix.columnCount));
      expect(L.isSquareMatrix, isTrue);

      // Checking Lt
      final transposedL = cholesky[1];
      expect(
        transposedL.flattenData,
        orderedEquals(<double>[5, 3, -1, 0, 3, 1, 0, 0, 3]),
      );
      expect(transposedL.rowCount, equals(matrix.rowCount));
      expect(transposedL.columnCount, equals(matrix.columnCount));
      expect(transposedL.isSquareMatrix, isTrue);
    });

    test(
        "Making sure that the Cholesky decomposition properly doesn't work "
        'when the matrix is not square.', () {
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 2,
        data: const [
          [1, 2],
          [3, 4],
          [5, 6],
        ],
      );

      // Decomposition
      expect(matrix.choleskyDecomposition, throwsA(isA<MatrixException>()));
    });

    test('Making sure that SVD decomposition works on a square matrix', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [1, 5],
          [7, -3],
        ],
      );

      // Decomposition
      final svd = matrix.singleValueDecomposition();
      expect(svd.length, equals(3));

      // Checking E
      final E = svd[0];
      expect(E.isSquareMatrix, isTrue);
      expect(
        E(0, 0),
        const MoreOrLessEquals(7.73877, precision: 1.0e-5),
      );
      expect(
        E(0, 1),
        isZero,
      );
      expect(
        E(1, 0),
        isZero,
      );
      expect(
        E(1, 1),
        const MoreOrLessEquals(4.91034, precision: 1.0e-5),
      );

      // Checking U
      final U = svd[1];
      expect(U.isSquareMatrix, isTrue);
      expect(
        U(0, 0),
        const MoreOrLessEquals(-0.22975, precision: 1.0e-5),
      );
      expect(
        U(0, 1),
        const MoreOrLessEquals(0.97324, precision: 1.0e-5),
      );
      expect(
        U(1, 0),
        const MoreOrLessEquals(0.97324, precision: 1.0e-5),
      );
      expect(
        U(1, 1),
        const MoreOrLessEquals(0.229753, precision: 1.0e-5),
      );

      // Checking V
      final V = svd[2];
      expect(V.isSquareMatrix, isTrue);
      expect(
        V(0, 0),
        const MoreOrLessEquals(0.85065, precision: 1.0e-5),
      );
      expect(
        V(0, 1),
        const MoreOrLessEquals(0.52573, precision: 1.0e-5),
      );
      expect(
        V(1, 0),
        const MoreOrLessEquals(-0.52573, precision: 1.0e-5),
      );
      expect(
        V(1, 1),
        const MoreOrLessEquals(0.85065, precision: 1.0e-5),
      );

      // Making sure that U x E x Vt (where Vt is V transposed) equals to the
      // starting matrix
      final original = U * E * V.transpose();

      expect(
        original(0, 0),
        const MoreOrLessEquals(1, precision: 1.0e-5),
      );
      expect(
        original(0, 1),
        const MoreOrLessEquals(5, precision: 1.0e-5),
      );
      expect(
        original(1, 0),
        const MoreOrLessEquals(7, precision: 1.0e-5),
      );
      expect(
        original(1, 1),
        const MoreOrLessEquals(-3, precision: 1.0e-5),
      );
    });

    test('Making sure that SVD decomposition works on a non-square matrix', () {
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 2,
        data: const [
          [3, -5],
          [4, 9],
          [-2, 1],
        ],
      );

      // Decomposition
      final svd = matrix.singleValueDecomposition();
      expect(svd.length, equals(3));

      // Checking E
      final E = svd[0];
      expect(E.isSquareMatrix, isFalse);
      expect(E.rowCount, equals(3));
      expect(E.columnCount, equals(2));
      expect(
        E(0, 0),
        const MoreOrLessEquals(10.55376, precision: 1.0e-5),
      );
      expect(
        E(0, 1),
        isZero,
      );
      expect(
        E(1, 0),
        isZero,
      );
      expect(
        E(1, 1),
        const MoreOrLessEquals(4.96165, precision: 1.0e-5),
      );
      expect(
        E(2, 0),
        isZero,
      );
      expect(
        E(2, 1),
        isZero,
      );

      // Checking U
      final U = svd[1];
      expect(U.isSquareMatrix, isTrue);
      expect(
        U(0, 0),
        const MoreOrLessEquals(0.397763, precision: 1.0e-5),
      );
      expect(
        U(0, 1),
        const MoreOrLessEquals(-0.815641, precision: 1.0e-5),
      );
      expect(
        U(0, 2),
        const MoreOrLessEquals(0.420135, precision: 1.0e-5),
      );
      expect(
        U(1, 0),
        const MoreOrLessEquals(-0.916139, precision: 1.0e-5),
      );
      expect(
        U(1, 1),
        const MoreOrLessEquals(-0.377915, precision: 1.0e-5),
      );
      expect(
        U(1, 2),
        const MoreOrLessEquals(0.133679, precision: 1.0e-5),
      );
      expect(
        U(2, 0),
        const MoreOrLessEquals(-0.04974, precision: 1.0e-5),
      );
      expect(
        U(2, 1),
        const MoreOrLessEquals(0.43807, precision: 1.0e-5),
      );
      expect(
        U(2, 2),
        const MoreOrLessEquals(0.89756, precision: 1.0e-5),
      );

      // Checking V
      final V = svd[2];
      expect(V.isSquareMatrix, isTrue);
      expect(
        V(0, 0),
        const MoreOrLessEquals(-0.22473, precision: 1.0e-5),
      );
      expect(
        V(0, 1),
        const MoreOrLessEquals(-0.97442, precision: 1.0e-5),
      );
      expect(
        V(1, 0),
        const MoreOrLessEquals(-0.97442, precision: 1.0e-5),
      );
      expect(
        V(1, 1),
        const MoreOrLessEquals(0.22473, precision: 1.0e-5),
      );

      // Making sure that U x E x Vt (where Vt is V transposed) equals to the
      // starting matrix
      final original = U * E * V.transpose();

      expect(
        original(0, 0),
        const MoreOrLessEquals(3, precision: 1.0e-5),
      );
      expect(
        original(0, 1),
        const MoreOrLessEquals(-5, precision: 1.0e-5),
      );
      expect(
        original(1, 0),
        const MoreOrLessEquals(4, precision: 1.0e-5),
      );
      expect(
        original(1, 1),
        const MoreOrLessEquals(9, precision: 1.0e-5),
      );
      expect(
        original(2, 0),
        const MoreOrLessEquals(-2, precision: 1.0e-5),
      );
      expect(
        original(2, 1),
        const MoreOrLessEquals(1, precision: 1.0e-5),
      );
    });

    test('Making sure that the transposed view is correct', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 3,
        data: const [
          [6, 4, 24],
          [1, -9, 8],
        ],
      );

      expect(matrix.transposedValue(0, 0), equals(6));
      expect(matrix.transposedValue(0, 1), equals(1));
      expect(matrix.transposedValue(1, 0), equals(4));
      expect(matrix.transposedValue(1, 1), equals(-9));
      expect(matrix.transposedValue(2, 0), equals(24));
      expect(matrix.transposedValue(2, 1), equals(8));
    });

    test('Making sure that the transposed matrix is correct (2x2)', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [1, 2],
          [3, 4],
        ],
      );

      final transposed = matrix.transpose();
      expect(transposed(0, 0), equals(1));
      expect(transposed(0, 1), equals(3));
      expect(transposed(1, 0), equals(2));
      expect(transposed(1, 1), equals(4));
    });

    test('Making sure that the transposed matrix is correct (2x3)', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 3,
        data: const [
          [6, 4, 24],
          [1, -9, 8],
        ],
      );

      final transposed = matrix.transpose();
      expect(transposed(0, 0), equals(6));
      expect(transposed(0, 1), equals(1));
      expect(transposed(1, 0), equals(4));
      expect(transposed(1, 1), equals(-9));
      expect(transposed(2, 0), equals(24));
      expect(transposed(2, 1), equals(8));
    });

    test('Making sure that minors are correctly generated', () {
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [2, 3, 1],
          [0, 5, 6],
          [1, 1, 2],
        ],
      );

      // Removing (0; 0)
      final minor1 = matrix.minor(0, 0);
      expect(
        minor1.flattenData,
        orderedEquals(
          [5, 6, 1, 2],
        ),
      );

      // Removing (1; 2)
      final minor2 = matrix.minor(1, 2);
      expect(
        minor2.flattenData,
        orderedEquals(
          [2, 3, 1, 1],
        ),
      );

      // Errors
      expect(
        () => matrix.minor(-1, 2),
        throwsA(isA<MatrixException>()),
      );
      expect(
        () => matrix.minor(11, 2),
        throwsA(isA<MatrixException>()),
      );
    });

    test('Making sure that the cofactor matrix is correctly computed', () {
      final matrixSize2 = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [4, -5],
          [7, 3],
        ],
      );

      final cofactorMatrixSize2 = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [3, -7],
          [5, 4],
        ],
      );

      expect(matrixSize2.cofactorMatrix(), equals(cofactorMatrixSize2));

      final matrixSize3 = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [2, 8, -3],
          [0, 6, 1],
          [-4, 7, 1],
        ],
      );

      final cofactorMatrixSize3 = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [-1, -4, 24],
          [-29, -10, -46],
          [26, -2, 12],
        ],
      );

      expect(matrixSize3.cofactorMatrix(), equals(cofactorMatrixSize3));
    });

    test(
        'Making sure that the cofactor matrix is NOT computed if the source '
        'matrix is NOT square', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 1,
        data: const [
          [2],
          [8],
        ],
      );

      expect(() => matrix.cofactorMatrix(), throwsA(isA<MatrixException>()));
    });

    test(
        'Making sure that the inverse matrix is NOT computed if the source '
        'matrix is NOT square', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 1,
        data: const [
          [2],
          [8],
        ],
      );

      expect(() => matrix.inverse(), throwsA(isA<MatrixException>()));
    });

    test('Making sure that the inverse of a 2x2 matrix is correct', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [-4, 2],
          [1, 3],
        ],
      ).inverse();

      expect(
        matrix(0, 0),
        const MoreOrLessEquals(-0.214286, precision: 1.0e-6),
      );
      expect(
        matrix(0, 1),
        const MoreOrLessEquals(0.142857, precision: 1.0e-6),
      );
      expect(
        matrix(1, 0),
        const MoreOrLessEquals(0.071428, precision: 1.0e-6),
      );
      expect(
        matrix(1, 1),
        const MoreOrLessEquals(0.285714, precision: 1.0e-6),
      );
    });

    test('Making sure that the inverse of a matrix is correct', () {
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [2, -1, 0],
          [4, 0, 7],
          [6, 1, 3],
        ],
      ).inverse();

      expect(
        matrix(0, 0),
        const MoreOrLessEquals(0.159091, precision: 1.0e-6),
      );
      expect(
        matrix(0, 1),
        const MoreOrLessEquals(-0.068181, precision: 1.0e-6),
      );
      expect(
        matrix(0, 2),
        const MoreOrLessEquals(0.159091, precision: 1.0e-6),
      );
      expect(
        matrix(1, 0),
        const MoreOrLessEquals(-0.681818, precision: 1.0e-6),
      );
      expect(
        matrix(1, 1),
        const MoreOrLessEquals(-0.136364, precision: 1.0e-6),
      );
      expect(
        matrix(1, 2),
        const MoreOrLessEquals(0.318182, precision: 1.0e-6),
      );
      expect(
        matrix(2, 0),
        const MoreOrLessEquals(-0.090909, precision: 1.0e-6),
      );
      expect(
        matrix(2, 1),
        const MoreOrLessEquals(0.181818, precision: 1.0e-6),
      );
      expect(
        matrix(2, 2),
        const MoreOrLessEquals(-0.090909, precision: 1.0e-6),
      );
    });

    test('Making sure that the trace is correctly computed', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [2, 5],
          [4, 9],
        ],
      );

      expect(matrix.trace(), equals(11));
    });

    test('Making sure that the trace only computed on square matrices', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 3,
        data: const [
          [2, 5, 3],
          [4, 9, 2],
        ],
      );

      expect(() => matrix.trace(), throwsA(isA<MatrixException>()));
    });

    test('Making sure that eigenvalues can be computed (1x1 matrices)', () {
      final matrix = RealMatrix.fromData(
        rows: 1,
        columns: 1,
        data: const [
          [-16],
        ],
      );

      final eigenvalues = matrix.eigenValues();

      expect(eigenvalues.length, equals(1));
      expect(eigenvalues[0], equals(const Complex.fromReal(-16)));
    });

    test('Making sure that eigenvalues can be computed (2x2 matrices)', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [3, 1],
          [2, 5],
        ],
      );

      final eigenvalues = matrix.eigenValues();

      expect(eigenvalues.length, equals(2));
      expect(
        eigenvalues[0].real,
        const MoreOrLessEquals(5.7320, precision: 1.0e-4),
      );
      expect(
        eigenvalues[1].real,
        const MoreOrLessEquals(2.2679, precision: 1.0e-4),
      );
      expect(
        eigenvalues[0].imaginary,
        isZero,
      );
      expect(
        eigenvalues[1].imaginary,
        isZero,
      );
    });

    test('Making sure that eigenvalues can be computed (3x3 matrices)', () {
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9],
        ],
      );

      final eigenvalues = matrix.eigenValues();

      expect(eigenvalues.length, equals(3));
      expect(
        eigenvalues[0].real,
        const MoreOrLessEquals(16.1168, precision: 1.0e-4),
      );
      expect(
        eigenvalues[1].real,
        const MoreOrLessEquals(-1.1168, precision: 1.0e-4),
      );
      expect(
        eigenvalues[2].real,
        const MoreOrLessEquals(0, precision: 1.0e-4),
      );
      expect(
        eigenvalues[0].imaginary,
        const MoreOrLessEquals(0, precision: 1.0e-4),
      );
      expect(
        eigenvalues[1].imaginary,
        const MoreOrLessEquals(0, precision: 1.0e-4),
      );
      expect(
        eigenvalues[2].imaginary,
        const MoreOrLessEquals(0, precision: 1.0e-4),
      );
    });
  });
}
