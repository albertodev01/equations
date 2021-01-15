import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  group("Testing the constructors of the 'RealMatrix' class", () {
    test("Making sure that a new matrix is initialized with 0s.", () {
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
        "Making sure that an exception is thrown when the user tries to "
        "build a matrix whose row or column count is zero.", () {
      expect(
          () => RealMatrix(
                columns: 0,
                rows: 2,
              ),
          throwsA(isA<MatrixException>()));
    });

    test(
        "Making sure that the identity matrix is filled with 0s except for "
        "its diagonal, which must contain all 1s.", () {
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
        "Making sure that an exception is thrown when the user tries to "
        "build an identity matrix with a non-squared entry.", () {
      expect(() => RealMatrix(columns: 3, rows: 5, identity: true),
          throwsA(isA<MatrixException>()));
    });

    test("Making sure that 'toString()' works as expected.", () {
      final matrix = RealMatrix.fromData(columns: 3, rows: 3, data: const [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
      ]);

      final expected = "[1.0, 2.0, 3.0]\n[4.0, 5.0, 6.0]\n[7.0, 8.0, 9.0]";
      expect(matrix.toString(), equals(expected));
    });

    test(
        "Making sure that a matrix is properly built from a list of lists "
        "entries.", () {
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
    test("Making sure that objects comparison works properly.", () {
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
          RealMatrix(columns: 2, rows: 2, identity: true) == matrix, isFalse);
      expect(
          RealMatrix(columns: 2, rows: 1).hashCode == matrix.hashCode, isFalse);
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

    test("Making sure that operator+ works properly.", () {
      final matrixSum = RealMatrix.fromData(columns: 2, rows: 2, data: [
        [-2, 7],
        [2, -3],
      ]);
      expect(matrixA + matrixB, equals(matrixSum));
    });

    test("Making sure that operator- works properly.", () {
      final matrixSub = RealMatrix.fromData(columns: 2, rows: 2, data: [
        [6, 5],
        [-12, 3],
      ]);
      expect(matrixA - matrixB, equals(matrixSub));
    });

    test("Making sure that operator* works properly.", () {
      final matrixMul = RealMatrix.fromData(columns: 2, rows: 2, data: [
        [34, -16],
        [20, -5],
      ]);
      expect(matrixA * matrixB, equals(matrixMul));
    });

    test("Making sure that operator/ works properly.", () {
      final matrixDiv = RealMatrix.fromData(columns: 2, rows: 2, data: [
        [-1 / 2, 6],
        [-5 / 7, 0],
      ]);
      expect(matrixA / matrixB, equals(matrixDiv));
    });
  });

  group("Testing the computation of the determinant.", () {
    test("Making sure that the determinant of an 1*1 matrix is correct.", () {
      final matrix = RealMatrix.fromData(columns: 1, rows: 1, data: [
        [-5]
      ]);
      expect(matrix.determinant(), equals(-5));
    });

    test("Making sure that the determinant of a 2*2 matrix is correct.", () {
      final matrix = RealMatrix.fromData(columns: 2, rows: 2, data: [
        [6, 5],
        [-12, 3],
      ]);
      expect(matrix.determinant(), equals(78));
    });

    test("Making sure that the determinant of a 3*3 matrix is correct.", () {
      final matrix = RealMatrix.fromData(columns: 3, rows: 3, data: [
        [2, -1, 0],
        [11, 0, 7],
        [6, 1, 1],
      ]);
      expect(matrix.determinant(), equals(-45));
    });

    test("Making sure that the determinant of a 4*4 matrix is correct.", () {
      final matrix = RealMatrix.fromData(columns: 4, rows: 4, data: [
        [2, -1, 13, 4],
        [11, 0, 1, 7],
        [6, -4, 7, 2],
        [1, -1, 3, 0],
      ]);
      expect(matrix.determinant(), equals(271));
    });

    test(
        "Making sure that the determinant of a 5*5 (or greater) matrix is "
        "correct.", () {
      final matrix = RealMatrix.fromData(columns: 5, rows: 5, data: [
        [2, -1, 13, 4, 1],
        [11, 0, 5, 1, 7],
        [6, -4, 7, 2, -6],
        [1, 0, -3, -6, 9],
        [7, 0, 3, -4, 1],
      ]);
      expect(matrix.determinant(), MoreOrLessEquals(-28398, precision: 0.1));
    });
  });

  group("Testing operations on matrices.", () {
    test(
        "Making sure that the LU decomposition properly works on a square "
        "matrix of a given dimension.", () {
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
      expect(L.flattenData, orderedEquals(<double>[1, 0, 0, 4, 1, 0, 7, 2, 1]));

      // Checking U
      final U = lu[1];
      expect(U.rowCount, equals(matrix.rowCount));
      expect(U.columnCount, equals(matrix.columnCount));
      expect(U.isSquareMatrix, isTrue);
      expect(
          U.flattenData, orderedEquals(<double>[1, 2, 3, 0, -3, -6, 0, 0, 0]));
    });

    test(
        "Making sure that the LU decomposition properly doesn't work when "
        "the matrix is not square.", () {
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
        "Making sure that Cholesky decomposition properly works on a square "
        "matrix of a given dimension.", () {
      final matrix = RealMatrix.fromData(rows: 3, columns: 3, data: const [
        [25, 15, -5],
        [15, 18, 0],
        [-5, 0, 11],
      ]);

      // Decomposition
      final cholesky = matrix.choleskyDecomposition();
      expect(cholesky.length, equals(2));

      // Checking L
      final L = cholesky[0];
      expect(
          L.flattenData, orderedEquals(<double>[5, 0, 0, 3, 3, 0, -1, 1, 3]));
      expect(L.rowCount, equals(matrix.rowCount));
      expect(L.columnCount, equals(matrix.columnCount));
      expect(L.isSquareMatrix, isTrue);

      // Checking Lt
      final transposedL = cholesky[1];
      expect(transposedL.flattenData,
          orderedEquals(<double>[5, 3, -1, 0, 3, 1, 0, 0, 3]));
      expect(transposedL.rowCount, equals(matrix.rowCount));
      expect(transposedL.columnCount, equals(matrix.columnCount));
      expect(transposedL.isSquareMatrix, isTrue);
    });

    test(
        "Making sure that the Cholesky decomposition properly doesn't work "
        "when the matrix is not square.", () {
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
  });
}
