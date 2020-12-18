import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the constructors of the 'Matrix' class", () {
    test("Making sure that a new matrix is initialized with 0s.", () async {
      final matrix = Matrix(
        columns: 5,
        rows: 3,
      );

      // Checking the sizes
      expect(matrix.rowCount, equals(3));
      expect(matrix.columnCount, equals(5));

      // Checking the content of the matrix
      for (var i = 0; i < matrix.rowCount; ++i) {
        for (var j = 0; j < matrix.columnCount; ++j) {
          expect(matrix(i, j), isZero);
        }
      }
    });

    test(
        "Making sure that an exception is thrown when the user tries to "
        "build a matrix whose row or column count is zero.", () async {
      expect(
          () => Matrix(
                columns: 0,
                rows: 2,
              ),
          throwsA(isA<MatrixException>()));
    });

    test(
        "Making sure that the identity matrix is filled with 0s except for "
        "its diagonal, which must contain all 1s.", () async {
      final matrix = Matrix(columns: 3, rows: 3, identity: true);

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
        }
      }
    });

    test(
        "Making sure that an exception is thrown when the user tries to "
        "build an identity matrix with a non-squared entry.", () async {
      expect(() => Matrix(columns: 3, rows: 5, identity: true),
          throwsA(isA<MatrixException>()));
    });

    test(
        "Making sure that a matrix is properly built from a list of lists "
        "entries.", () async {
      final matrix = Matrix.fromData(columns: 3, rows: 3, data: const [
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

  group("Testing equality of 'Matrix' objects", () {
    test("Making sure that objects comparison works properly.", () async {
      final matrix = Matrix(
        columns: 2,
        rows: 2,
      );

      // Equality tests
      expect(Matrix(columns: 2, rows: 2), equals(matrix));
      expect(Matrix(columns: 2, rows: 2) == matrix, isTrue);
      expect(Matrix(columns: 2, rows: 2).hashCode, equals(matrix.hashCode));

      // Inequality tests
      expect(Matrix(columns: 2, rows: 2, identity: true) == matrix, isFalse);
      expect(Matrix(columns: 2, rows: 1).hashCode == matrix.hashCode, isFalse);
    });
  });

  group("Testing operation on matrices (+, *, - and /)", () {
    /*
    * A = |  2  6  |
    *     | -5  0  |
    * */
    final matrixA = Matrix.fromData(columns: 2, rows: 2, data: const [
      [2, 6],
      [-5, 0]
    ]);

    /*
    * B = | -4  1  |
    *     |  7 -3  |
    * */
    final matrixB = Matrix.fromData(columns: 2, rows: 2, data: const [
      [-4, 1],
      [7, -3]
    ]);

    test("Making sure that operator+ works properly.", () async {
      final matrixSum = Matrix.fromData(columns: 2, rows: 2, data: [
        [-2, 7],
        [2, -3]
      ]);
      expect(matrixA + matrixB, equals(matrixSum));
    });

    test("Making sure that operator- works properly.", () async {
      final matrixSum = Matrix.fromData(columns: 2, rows: 2, data: [
        [6, 5],
        [-12, 3]
      ]);
      expect(matrixA - matrixB, equals(matrixSum));
    });

    test("Making sure that operator* works properly.", () async {
      final matrixSum = Matrix.fromData(columns: 2, rows: 2, data: [
        [34, -16],
        [20, -5]
      ]);
      expect(matrixA * matrixB, equals(matrixSum));
    });

    test("Making sure that operator/ works properly.", () async {
      final matrixSum = Matrix.fromData(columns: 2, rows: 2, data: [
        [-1 / 2, 6],
        [-5 / 7, 0]
      ]);
      expect(matrixA / matrixB, equals(matrixSum));
    });
  });

  group("Testing various operators (+, -, *, /) and the determinant.", () {
    test("Making sure that the determinant of an 1*1 matrix is correct.", () {
      final matrix = Matrix.fromData(columns: 1, rows: 1, data: [
        [-5]
      ]);
      expect(matrix.determinant(), equals(-5));
    });

    test("Making sure that the determinant of a 2*2 matrix is correct.", () {
      final matrix = Matrix.fromData(columns: 2, rows: 2, data: [
        [6, 5],
        [-12, 3]
      ]);
      expect(matrix.determinant(), equals(78));
    });

    test("Making sure that the determinant of a 3*3 matrix is correct.", () {
      final matrix = Matrix.fromData(columns: 3, rows: 3, data: [
        [2, -1, 0],
        [11, 0, 7],
        [6, 1, 1]
      ]);
      expect(matrix.determinant(), equals(-45));
    });

    test("Making sure that the determinant of a 4*4 matrix is correct.", () {
      final matrix = Matrix.fromData(columns: 4, rows: 4, data: [
        [2, -1, 13, 4],
        [11, 0, 1, 7],
        [6, -4, 7, 2],
        [1, -1, 3, 0]
      ]);
      expect(matrix.determinant(), equals(271));
    });

    test(
        "Making sure that the determinant of a 5*5 (or greater) matrix is "
        "correct.", () {
      final matrix = Matrix.fromData(columns: 5, rows: 5, data: [
        [2, -1, 13, 4, 1],
        [11, 0, 5, 1, 7],
        [6, -4, 7, 2, -6],
        [1, 0, -3, -6, 9],
        [7, 0, 3, -4, 1]
      ]);
      expect(matrix.determinant(), equals(-28398));
    });
  });
}
