import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  group('RealMatrix', () {
    test('New matrix is initialized with zeroes.', () {
      final matrix = RealMatrix(columns: 5, rows: 3);

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

    test('Exception if matrix has row or column set to zero.', () {
      expect(
        () => RealMatrix(columns: 0, rows: 2),
        throwsA(isA<MatrixException>()),
      );
    });

    test('Identity matrix has all zeroes except for the diagonal', () {
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

    test('Exception is thrown if identity matrix is non-square.', () {
      expect(
        () => RealMatrix(columns: 3, rows: 5, identity: true),
        throwsA(isA<MatrixException>()),
      );
    });

    test('Matrix can be flattened into a list of doubles.', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: [
          [1, 2],
          [3, 4],
        ],
      );

      // Checking the sizes
      final flattenedMatrix = matrix.toList();

      expect(flattenedMatrix.length, equals(4));
      expect(flattenedMatrix, orderedEquals(<double>[1, 2, 3, 4]));
    });

    test('Matrix can be created from a flattened list of values.', () {
      final matrix = RealMatrix.fromFlattenedData(
        rows: 2,
        columns: 2,
        data: [1, 2, 3, 4],
      );

      expect(matrix.rowCount * matrix.columnCount, equals(4));
      expect(
        matrix,
        equals(
          RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: [
              [1, 2],
              [3, 4],
            ],
          ),
        ),
      );
    });

    test('Diagonal matrix can be created.', () {
      final matrix = RealMatrix.diagonal(rows: 3, columns: 3, diagonalValue: 8);

      for (var i = 0; i < matrix.rowCount; ++i) {
        for (var j = 0; j < matrix.columnCount; ++j) {
          if (i == j) {
            expect(matrix(i, j), equals(8));
          } else {
            expect(matrix(i, j), isZero);
          }
        }
      }

      const stringRepresentation =
          '[8.0, 0.0, 0.0]\n'
          '[0.0, 8.0, 0.0]\n'
          '[0.0, 0.0, 8.0]';

      expect('$matrix', equals(stringRepresentation));
    });

    test('Diagonal non square matrix is created wit the given value', () {
      final matrix = RealMatrix.diagonal(rows: 3, columns: 5, diagonalValue: 8);

      for (var i = 0; i < matrix.rowCount; ++i) {
        for (var j = 0; j < matrix.columnCount; ++j) {
          if (i == j) {
            expect(matrix(i, j), equals(8));
          } else {
            expect(matrix(i, j), isZero);
          }
        }
      }

      const stringRepresentation =
          '[8.0, 0.0, 0.0, 0.0, 0.0]\n'
          '[0.0, 8.0, 0.0, 0.0, 0.0]\n'
          '[0.0, 0.0, 8.0, 0.0, 0.0]';

      expect('$matrix', equals(stringRepresentation));
    });

    test('Diagonal, non square matrix', () {
      final matrix = RealMatrix.diagonal(rows: 6, columns: 2, diagonalValue: 1);

      for (var i = 0; i < matrix.rowCount; ++i) {
        for (var j = 0; j < matrix.columnCount; ++j) {
          if (i == j) {
            expect(matrix(i, j), equals(1));
          } else {
            expect(matrix(i, j), isZero);
          }
        }
      }

      const stringRepresentation =
          '[1.0, 0.0]\n'
          '[0.0, 1.0]\n'
          '[0.0, 0.0]\n'
          '[0.0, 0.0]\n'
          '[0.0, 0.0]\n'
          '[0.0, 0.0]';

      expect('$matrix', equals(stringRepresentation));
    });

    test('Diagonal of a single element', () {
      final matrix = RealMatrix.diagonal(
        rows: 1,
        columns: 1,
        diagonalValue: 31,
      );

      expect(matrix(0, 0), equals(31));
      expect('$matrix', equals('[31.0]'));
    });

    test('Exception if sizes and array length do not match', () {
      expect(
        () => RealMatrix.fromFlattenedData(
          rows: 6,
          columns: 2,
          data: [1, 2, 3, 4],
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('toString() works as expected.', () {
      final matrix = RealMatrix.fromData(
        columns: 3,
        rows: 3,
        data: const [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9],
        ],
      );

      const expected =
          '[1.0, 2.0, 3.0]\n'
          '[4.0, 5.0, 6.0]\n'
          '[7.0, 8.0, 9.0]';
      expect(matrix.toString(), equals(expected));
    });

    test('Matrix is properly built from a list of lists entries.', () {
      final matrix = RealMatrix.fromData(
        columns: 3,
        rows: 3,
        data: const [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9],
        ],
      );

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
    test('Objects comparison works properly.', () {
      final matrix = RealMatrix(columns: 2, rows: 2);

      // Equality tests
      expect(RealMatrix(columns: 2, rows: 2), equals(matrix));
      expect(matrix, equals(RealMatrix(columns: 2, rows: 2)));
      expect(RealMatrix(columns: 2, rows: 2) == matrix, isTrue);
      expect(matrix == RealMatrix(columns: 2, rows: 2), isTrue);
      expect(RealMatrix(columns: 2, rows: 2).hashCode, equals(matrix.hashCode));

      expect(
        RealMatrix.fromFlattenedData(rows: 1, columns: 1, data: [5.0]),
        equals(RealMatrix.fromFlattenedData(rows: 1, columns: 1, data: [5.0])),
      );

      expect(
        RealMatrix.fromFlattenedData(rows: 1, columns: 1, data: [5.0]) ==
            RealMatrix.fromFlattenedData(rows: 1, columns: 1, data: [5.01]),
        isFalse,
      );

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
    final matrixA = RealMatrix.fromData(
      columns: 2,
      rows: 2,
      data: const [
        [2, 6],
        [-5, 0],
      ],
    );

    /*
    * B = | -4  1  |
    *     |  7 -3  |
    * */
    final matrixB = RealMatrix.fromData(
      columns: 2,
      rows: 2,
      data: const [
        [-4, 1],
        [7, -3],
      ],
    );

    test('operator+ works properly.', () {
      final matrixSum = RealMatrix.fromData(
        columns: 2,
        rows: 2,
        data: [
          [-2, 7],
          [2, -3],
        ],
      );
      expect(matrixA + matrixB, equals(matrixSum));
    });

    test('operator+ works on rectangular matrices too.', () {
      final matrixA = RealMatrix.fromData(
        columns: 2,
        rows: 3,
        data: [
          [4, -1],
          [1, 9],
          [6, 5],
        ],
      );

      final matrixB = RealMatrix.fromData(
        columns: 2,
        rows: 3,
        data: [
          [3, 1],
          [-1, 5],
          [4, 9],
        ],
      );

      expect(
        matrixA + matrixB,
        equals(
          RealMatrix.fromData(
            columns: 2,
            rows: 3,
            data: [
              [7, 0],
              [0, 14],
              [10, 14],
            ],
          ),
        ),
      );
    });

    test('operator- works properly.', () {
      final matrixSub = RealMatrix.fromData(
        columns: 2,
        rows: 2,
        data: [
          [6, 5],
          [-12, 3],
        ],
      );
      expect(matrixA - matrixB, equals(matrixSub));
    });

    test('operator- works on rectangular matrices too.', () {
      final matrixA = RealMatrix.fromData(
        columns: 2,
        rows: 3,
        data: [
          [4, -1],
          [1, 9],
          [6, 5],
        ],
      );

      final matrixB = RealMatrix.fromData(
        columns: 2,
        rows: 3,
        data: [
          [3, 0],
          [-1, 5],
          [4, 9],
        ],
      );

      expect(
        matrixA - matrixB,
        equals(
          RealMatrix.fromData(
            columns: 2,
            rows: 3,
            data: [
              [1, -1],
              [2, 4],
              [2, -4],
            ],
          ),
        ),
      );
    });

    test('operator* works properly.', () {
      final matrixMul = RealMatrix.fromData(
        columns: 2,
        rows: 2,
        data: [
          [34, -16],
          [20, -5],
        ],
      );
      expect(matrixA * matrixB, equals(matrixMul));
    });

    test('operator* works on rectangular matrices too.', () {
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

    test('operator/ works properly.', () {
      final matrixDiv = RealMatrix.fromData(
        columns: 2,
        rows: 2,
        data: [
          [-1 / 2, 6],
          [-5 / 7, 0],
        ],
      );
      expect(matrixA / matrixB, equals(matrixDiv));
    });

    test('operator/ works on rectangular matrices too.', () {
      final matrixA = RealMatrix.fromData(
        columns: 2,
        rows: 3,
        data: [
          [4, -1],
          [1, 9],
          [6, 5],
        ],
      );

      final matrixB = RealMatrix.fromData(
        columns: 2,
        rows: 3,
        data: [
          [3, 1],
          [-1, 5],
          [4, 9],
        ],
      );

      expect(
        matrixA / matrixB,
        equals(
          RealMatrix.fromData(
            columns: 2,
            rows: 3,
            data: [
              [4 / 3, -1],
              [-1, 9 / 5],
              [3 / 2, 5 / 9],
            ],
          ),
        ),
      );
    });

    test(
      'operator+, operator- and operator/ fail on matrices of different sizes',
      () {
        final otherMatrix = RealMatrix.fromFlattenedData(
          rows: 1,
          columns: 1,
          data: [1],
        );

        expect(() => matrixA + otherMatrix, throwsA(isA<MatrixException>()));

        expect(() => matrixA - otherMatrix, throwsA(isA<MatrixException>()));

        expect(() => matrixA / otherMatrix, throwsA(isA<MatrixException>()));
      },
    );

    test('operator* fails if rows and columns have no matching sizes', () {
      final otherMatrix = RealMatrix.fromFlattenedData(
        rows: 1,
        columns: 2,
        data: [1, 3],
      );

      expect(() => matrixA * otherMatrix, throwsA(isA<MatrixException>()));
    });
  });

  group('Testing the computation of the determinant.', () {
    test('Determinant of an 1*1 matrix is correct.', () {
      final matrix = RealMatrix.fromData(
        columns: 1,
        rows: 1,
        data: [
          [-5],
        ],
      );
      expect(matrix.determinant(), equals(-5));
    });

    test('Determinant of a 2*2 matrix is correct.', () {
      final matrix = RealMatrix.fromData(
        columns: 2,
        rows: 2,
        data: [
          [6, 5],
          [-12, 3],
        ],
      );
      expect(matrix.determinant(), equals(78));
    });

    test('Determinant of a 3*3 matrix is correct.', () {
      final matrix = RealMatrix.fromData(
        columns: 3,
        rows: 3,
        data: [
          [2, -1, 0],
          [11, 0, 7],
          [6, 1, 1],
        ],
      );
      expect(matrix.determinant(), equals(-45));
    });

    test('Determinant of a 4*4 matrix is correct.', () {
      final matrix = RealMatrix.fromData(
        columns: 4,
        rows: 4,
        data: [
          [2, -1, 13, 4],
          [11, 0, 1, 7],
          [6, -4, 7, 2],
          [1, -1, 3, 0],
        ],
      );
      expect(matrix.determinant(), equals(271));
    });

    test('Determinant of a 5*5 (or greater) matrix is correct.', () {
      final matrix = RealMatrix.fromData(
        columns: 5,
        rows: 5,
        data: [
          [2, -1, 13, 4, 1],
          [11, 0, 5, 1, 7],
          [6, -4, 7, 2, -6],
          [1, 0, -3, -6, 9],
          [7, 0, 3, -4, 1],
        ],
      );
      expect(
        matrix.determinant(),
        const MoreOrLessEquals(-28398, precision: 0.1),
      );
    });
  });

  group('Testing operations on matrices.', () {
    test('LU decomposition works on a square matrix.', () {
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
      final L = lu.first;
      expect(L.rowCount, equals(matrix.rowCount));
      expect(L.columnCount, equals(matrix.columnCount));
      expect(L.isSquareMatrix, isTrue);
      expect(L.flattenData, orderedEquals(<double>[1, 0, 0, 4, 1, 0, 7, 2, 1]));

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

    test('LU decomposition fails when matrix is not square.', () {
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

    test('Cholesky decomposition works on a square matrix.', () {
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
      final L = cholesky.first;
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

    test('Cholesky decomposition fails when matrix is not square.', () {
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

    test('Transposed view is correct', () {
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

    test('Transposed of a square matrix is correct', () {
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

    test('Transposed of a rectangular matrix is correct', () {
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

    test('Minors are correctly generated', () {
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
      expect(minor1.flattenData, orderedEquals([5, 6, 1, 2]));

      // Removing (1; 2)
      final minor2 = matrix.minor(1, 2);
      expect(minor2.flattenData, orderedEquals([2, 3, 1, 1]));

      // Errors
      expect(() => matrix.minor(-1, 2), throwsA(isA<MatrixException>()));
      expect(() => matrix.minor(11, 2), throwsA(isA<MatrixException>()));
    });

    test('Cofactor matrix is correctly computed', () {
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

    test('Cofactor matrix is not computed if source matrix is not square', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 1,
        data: const [
          [2],
          [8],
        ],
      );

      expect(matrix.cofactorMatrix, throwsA(isA<MatrixException>()));
    });

    test('Inverse matrix is not computed if source matrix is not square', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 1,
        data: const [
          [2],
          [8],
        ],
      );

      expect(matrix.inverse, throwsA(isA<MatrixException>()));
    });

    test('Inverse of a 2x2 matrix is correct', () {
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
      expect(matrix(0, 1), const MoreOrLessEquals(0.142857, precision: 1.0e-6));
      expect(matrix(1, 0), const MoreOrLessEquals(0.071428, precision: 1.0e-6));
      expect(matrix(1, 1), const MoreOrLessEquals(0.285714, precision: 1.0e-6));
    });

    test('Inverse of a matrix is correct', () {
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [2, -1, 0],
          [4, 0, 7],
          [6, 1, 3],
        ],
      ).inverse();

      expect(matrix(0, 0), const MoreOrLessEquals(0.159091, precision: 1.0e-6));
      expect(
        matrix(0, 1),
        const MoreOrLessEquals(-0.068181, precision: 1.0e-6),
      );
      expect(matrix(0, 2), const MoreOrLessEquals(0.159091, precision: 1.0e-6));
      expect(
        matrix(1, 0),
        const MoreOrLessEquals(-0.681818, precision: 1.0e-6),
      );
      expect(
        matrix(1, 1),
        const MoreOrLessEquals(-0.136364, precision: 1.0e-6),
      );
      expect(matrix(1, 2), const MoreOrLessEquals(0.318182, precision: 1.0e-6));
      expect(
        matrix(2, 0),
        const MoreOrLessEquals(-0.090909, precision: 1.0e-6),
      );
      expect(matrix(2, 1), const MoreOrLessEquals(0.181818, precision: 1.0e-6));
      expect(
        matrix(2, 2),
        const MoreOrLessEquals(-0.090909, precision: 1.0e-6),
      );
    });

    test('Trace is correctly computed', () {
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

    test('Trace is only computed on square matrices', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 3,
        data: const [
          [2, 5, 3],
          [4, 9, 2],
        ],
      );

      expect(matrix.trace, throwsA(isA<MatrixException>()));
    });

    test('Symmetric matrices are correctly identified.', () {
      final symmetric = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [1, 7, 3],
          [7, 4, 5],
          [3, 5, 6],
        ],
      );

      expect(symmetric.isSymmetric(), isTrue);

      final notSymmetric = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [1, -7, 3],
          [7, 4, 5],
          [3, 5, 6],
        ],
      );

      expect(notSymmetric.isSymmetric(), isFalse);
    });

    test('Diagonal matrices are correctly identified.', () {
      final diagonal = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [3, 0, 0],
          [0, 4, 0],
          [0, 0, 6],
        ],
      );

      expect(diagonal.isDiagonal(), isTrue);

      final stillDiagonal = RealMatrix.fromData(
        rows: 2,
        columns: 3,
        data: const [
          [3, 0, 0],
          [0, 4, 0],
        ],
      );

      expect(stillDiagonal.isDiagonal(), isTrue);

      final notDiagonal = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [3, 0, 0],
          [0, 4, 0],
          [1, 0, 6],
        ],
      );

      expect(notDiagonal.isDiagonal(), isFalse);
    });

    test('Identity matrices are correctly identified.', () {
      final diagonal = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [1, 0, 0],
          [0, 1, 0],
          [0, 0, 1],
        ],
      );

      expect(diagonal.isDiagonal(), isTrue);
      expect(diagonal.isIdentity(), isTrue);

      final notDiagonal = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [1, 0, 0],
          [0, -1, 0],
          [0, 0, 1],
        ],
      );

      expect(notDiagonal.isDiagonal(), isTrue);
      expect(notDiagonal.isIdentity(), isFalse);
    });

    test('Identity matrix is only computed when square.', () {
      final identity = RealMatrix.fromData(
        rows: 3,
        columns: 2,
        data: const [
          [1, 0],
          [0, 1],
          [0, 0],
        ],
      );

      expect(identity.isIdentity, throwsA(isA<MatrixException>()));
    });

    test('Rank can be correctly computed.', () {
      final rank = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [6, -7],
          [0, 3],
        ],
      );

      expect(rank.rank(), equals(2));

      final singularRank = RealMatrix.fromData(
        rows: 1,
        columns: 1,
        data: const [
          [6],
        ],
      );

      expect(singularRank.rank(), equals(1));

      final zeroRank = RealMatrix.fromData(
        rows: 1,
        columns: 1,
        data: const [
          [0],
        ],
      );

      expect(zeroRank.rank(), isZero);

      final rectangularRank1 = RealMatrix.fromData(
        rows: 2,
        columns: 3,
        data: const [
          [3, -6, 5],
          [1, 9, 0],
        ],
      );

      expect(rectangularRank1.rank(), equals(2));

      final rectangularRank2 = RealMatrix.fromData(
        rows: 3,
        columns: 1,
        data: const [
          [3],
          [4],
          [8],
        ],
      );

      expect(rectangularRank2.rank(), equals(1));
    });

    test('Eigenvalues can be computed (1x1 matrices)', () {
      final matrix = RealMatrix.fromData(
        rows: 1,
        columns: 1,
        data: const [
          [-16],
        ],
      );

      final eigenvalues = matrix.eigenvalues();

      expect(eigenvalues.length, equals(1));
      expect(eigenvalues.first, equals(const Complex.fromReal(-16)));
    });

    test('Eigenvalues can be computed (2x2 matrices)', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [3, 1],
          [2, 5],
        ],
      );

      final eigenvalues = matrix.eigenvalues();

      expect(eigenvalues.length, equals(2));
      expect(
        eigenvalues.first.real,
        const MoreOrLessEquals(5.732, precision: 1.0e-4),
      );
      expect(
        eigenvalues[1].real,
        const MoreOrLessEquals(2.2679, precision: 1.0e-4),
      );
      expect(eigenvalues.first.imaginary, isZero);
      expect(eigenvalues[1].imaginary, isZero);
    });

    test('Eigenvalues can be computed (3x3 matrices)', () {
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9],
        ],
      );

      final eigenvalues = matrix.eigenvalues();

      expect(eigenvalues.length, equals(3));
      expect(
        eigenvalues.first.real,
        const MoreOrLessEquals(16.1168, precision: 1.0e-4),
      );
      expect(
        eigenvalues[1].real,
        const MoreOrLessEquals(-1.1168, precision: 1.0e-4),
      );
      expect(eigenvalues[2].real, const MoreOrLessEquals(0, precision: 1.0e-4));
      expect(
        eigenvalues.first.imaginary,
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

    test('Batch tests - Minors', () {
      final source = [
        RealMatrix.fromData(
          rows: 3,
          columns: 4,
          data: const [
            [2, -1, 5, 9],
            [-12, 3, 2, 0],
            [1, -1, 9, 8],
          ],
        ).minor(1, 2),
        RealMatrix.fromData(
          rows: 3,
          columns: 4,
          data: const [
            [2, -1, 5, 9],
            [-12, 3, 2, 0],
            [1, -1, 9, 8],
          ],
        ).minor(2, 3),
        RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [-6, 1],
            [2, 7],
          ],
        ).minor(0, 1),
        RealMatrix.fromData(
          rows: 4,
          columns: 2,
          data: const [
            [-6, 1],
            [2, 2],
            [8, -1],
            [0, -10],
          ],
        ).minor(2, 0),
      ];

      final minors = [
        RealMatrix.fromData(
          rows: 2,
          columns: 3,
          data: const [
            [2, -1, 9],
            [1, -1, 8],
          ],
        ),
        RealMatrix.fromData(
          rows: 2,
          columns: 3,
          data: const [
            [2, -1, 5],
            [-12, 3, 2],
          ],
        ),
        RealMatrix.fromData(
          rows: 1,
          columns: 1,
          data: const [
            [2],
          ],
        ),
        RealMatrix.fromData(
          rows: 3,
          columns: 1,
          data: const [
            [1],
            [2],
            [-10],
          ],
        ),
      ];

      for (var i = 0; i < source.length; ++i) {
        expect(source[i], equals(minors[i]));
      }

      // Exception test
      expect(
        () => RealMatrix.fromData(
          rows: 2,
          columns: 1,
          data: const [
            [1],
            [2],
          ],
        ).minor(1, 0),
        throwsA(isA<MatrixException>()),
      );
    });

    test('Batch tests - Cofactor matrix', () {
      final source = [
        RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [1, 2, 3],
            [0, 4, 5],
            [1, 0, 6],
          ],
        ).cofactorMatrix(),
        RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [3, 1, 2],
            [-2, 4, 4],
            [1, 3, 6],
          ],
        ).cofactorMatrix(),
        RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [-3, 6],
            [7, 9],
          ],
        ).cofactorMatrix(),
        RealMatrix.fromData(
          rows: 1,
          columns: 1,
          data: const [
            [9],
          ],
        ).cofactorMatrix(),
      ];

      final cofactorMatrices = [
        RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [24, 5, -4],
            [-12, 3, 2],
            [-2, -5, 4],
          ],
        ),
        RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [12, 16, -10],
            [0, 16, -8],
            [-4, -16, 14],
          ],
        ),
        RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [9, -7],
            [-6, -3],
          ],
        ),
        RealMatrix.fromData(
          rows: 1,
          columns: 1,
          data: const [
            [1],
          ],
        ),
      ];

      for (var i = 0; i < source.length; ++i) {
        expect(source[i], equals(cofactorMatrices[i]));
      }
    });

    test('Batch tests - Inverse matrix', () {
      final source = [
        RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [3, 0, 2],
            [2, 0, -2],
            [0, 1, 1],
          ],
        ).inverse(),
        RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [4, 7],
            [2, 6],
          ],
        ).inverse(),
        RealMatrix.fromData(
          rows: 1,
          columns: 1,
          data: const [
            [13],
          ],
        ).inverse(),
        RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [1, 0],
            [0, 1],
          ],
        ).inverse(),
      ];

      final inverse = [
        RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [0.2, 0.2, 0],
            [-0.2, 3 / 10, 1],
            [0.2, -3 / 10, 0],
          ],
        ),
        RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [0.6, -0.7],
            [-0.2, 0.4],
          ],
        ),
        RealMatrix.fromData(
          rows: 1,
          columns: 1,
          data: const [
            [1 / 13],
          ],
        ),
        RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [1, 0],
            [0, 1],
          ],
        ),
      ];

      for (var i = 0; i < source.length; ++i) {
        for (var j = 0; j < source[i].rowCount; ++j) {
          for (var k = 0; k < source[i].rowCount; ++k) {
            expect(
              source[i](j, k),
              MoreOrLessEquals(inverse[i](j, k), precision: 1.0e-2),
            );
          }
        }
      }
    });

    test('Batch tests - Rank of a matrix', () {
      final source = [
        RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [3, 0, 2],
            [2, 0, -2],
            [0, 1, 1],
          ],
        ).rank(),
        RealMatrix.fromData(
          rows: 1,
          columns: 1,
          data: const [
            [4],
          ],
        ).rank(),
        RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [4, 7],
            [2, 6],
          ],
        ).rank(),
        RealMatrix.fromData(
          rows: 3,
          columns: 2,
          data: const [
            [1, 6],
            [-2, 9],
            [0, 1],
          ],
        ).rank(),
        RealMatrix.fromData(
          rows: 3,
          columns: 2,
          data: const [
            [1, 3],
            [2, 6],
            [3, 9],
          ],
        ).rank(),
      ];

      final ranks = [3, 1, 2, 2, 1];

      for (var i = 0; i < source.length; ++i) {
        expect(source[i], equals(ranks[i]));
      }
    });

    test('Batch tests - Characteristic polynomial', () {
      final polynomials = [
        RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [3, 1, 5],
            [3, 3, 1],
            [4, 6, 4],
          ],
        ).characteristicPolynomial(),
        RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [2, -1, 1],
            [-1, 2, 1],
            [1, -1, 2],
          ],
        ).characteristicPolynomial(),
        RealMatrix.fromData(
          rows: 4,
          columns: 4,
          data: const [
            [8, -1, 3, -1],
            [-1, 6, 2, 0],
            [3, 2, 9, 1],
            [-1, 0, 1, 7],
          ],
        ).characteristicPolynomial(),
        RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [3, 9],
            [-7, 2],
          ],
        ).characteristicPolynomial(),
        RealMatrix.fromData(
          rows: 1,
          columns: 1,
          data: const [
            [12],
          ],
        ).characteristicPolynomial(),
      ];

      final expectedSolutions = <Algebraic>[
        Algebraic.fromReal([1, -10, 4, -40]),
        Algebraic.fromReal([1, -6, 11, -6]),
        Algebraic.fromReal([1, -30, 319, -1410, 2138]),
        Algebraic.fromReal([1, -5, 69]),
        Algebraic.fromReal([1, -12]),
      ];

      for (var i = 0; i < polynomials.length; ++i) {
        expect(polynomials[i].degree, equals(expectedSolutions[i].degree));

        for (var j = 0; j < polynomials[i].coefficients.length; ++j) {
          expect(
            polynomials[i].coefficients[j].real,
            MoreOrLessEquals(
              expectedSolutions[i].coefficients[j].real,
              precision: 1.0e-3,
            ),
          );
          expect(
            polynomials[i].coefficients[j].imaginary,
            MoreOrLessEquals(
              expectedSolutions[i].coefficients[j].imaginary,
              precision: 1.0e-3,
            ),
          );
        }
      }
    });

    test('Batch tests - Eigenvalues', () {
      final eigenvalues = [
        RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: [
            [2, -4],
            [-1, -1],
          ],
        ).eigenvalues(),
        RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: [
            [5, 8, 16],
            [4, 1, 8],
            [6, -4, -11],
          ],
        ).eigenvalues(),
        RealMatrix.fromData(
          rows: 4,
          columns: 4,
          data: [
            [1, 2, 3, 4],
            [-1, 8, 3, 7],
            [0, 0, 0, 0],
            [9, 5, -7, 4],
          ],
        ).eigenvalues(),
        RealMatrix.fromData(
          rows: 1,
          columns: 1,
          data: [
            [16],
          ],
        ).eigenvalues(),
        RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: [
            [9, 7, -6],
            [5, 8, -1],
            [5, 3, 2],
          ],
        ).eigenvalues(),
        RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: [
            [1, -1],
            [1, 1],
          ],
        ).eigenvalues(),
        RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: [
            [1, 7, 3],
            [7, 4, 5],
            [3, 5, 0],
          ],
        ).eigenvalues(),
      ];

      final expected = <List<Complex>>[
        const [Complex.fromReal(3), Complex.fromReal(-2)],
        const [
          Complex.fromReal(11.8062),
          Complex.fromReal(-13.8062),
          Complex.fromReal(-3),
        ],
        const [
          Complex.fromReal(-4.039),
          Complex.fromReal(3.1566),
          Complex.fromReal(13.8824),
          Complex.zero(),
        ],
        const [Complex.fromReal(16)],
        const [
          Complex.fromReal(11.6784),
          Complex(3.6607, 2.257),
          Complex(3.6607, -2.257),
        ],
        const [Complex(1, -1), Complex(1, 1)],
        const [
          Complex.fromReal(-4.9095),
          Complex.fromReal(-2.4546),
          Complex.fromReal(12.3641),
        ],
      ];

      for (var i = 0; i < eigenvalues.length; ++i) {
        for (var j = 0; j < expected[i].length; ++j) {
          expect(
            eigenvalues[i][j].real,
            MoreOrLessEquals(expected[i][j].real, precision: 1.0e-4),
          );
          expect(
            eigenvalues[i][j].imaginary,
            MoreOrLessEquals(expected[i][j].imaginary, precision: 1.0e-4),
          );
        }
      }
    });
  });
}
