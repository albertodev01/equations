import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  group("Testing the constructors of the 'ComplexMatrix' class", () {
    test("Making sure that a new matrix is initialized with 0s.", () async {
      final matrix = ComplexMatrix(
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
          expect(matrix(i, j), equals(Complex.zero()));
          expect(matrix(i, j), equals(matrix.itemAt(i, j)));
        }
      }
    });

    test(
        "Making sure that an exception is thrown when the user tries to "
        "build a matrix whose row or column count is zero.", () async {
      expect(
          () => ComplexMatrix(
                columns: 0,
                rows: 2,
              ),
          throwsA(isA<MatrixException>()));
    });

    test(
        "Making sure that the identity matrix is filled with 0s except for "
        "its diagonal, which must contain all 1s.", () async {
      final matrix = ComplexMatrix(columns: 3, rows: 3, identity: true);

      // Checking the sizes
      expect(matrix.rowCount, equals(3));
      expect(matrix.columnCount, equals(3));

      // Checking the content of the matrix
      for (var i = 0; i < matrix.rowCount; ++i) {
        for (var j = 0; j < matrix.columnCount; ++j) {
          if (i == j) {
            expect(matrix(i, j), equals(Complex(1, 0)));
          } else {
            expect(matrix(i, j), equals(Complex.zero()));
          }
          expect(matrix(i, j), equals(matrix.itemAt(i, j)));
        }
      }
    });

    test(
        "Making sure that an exception is thrown when the user tries to "
        "build an identity matrix with a non-squared entry.", () {
      expect(() => ComplexMatrix(columns: 3, rows: 5, identity: true),
          throwsA(isA<MatrixException>()));
    });

    test("Making sure that 'toString()' works as expected.", () {
      final matrix = ComplexMatrix.fromData(columns: 2, rows: 2, data: const [
        [Complex(1, 2), Complex(3, 4)],
        [Complex(5, 6), Complex(6, 7)],
      ]);

      final expected = "[1 + 2i, 3 + 4i]\n[5 + 6i, 6 + 7i]";
      expect(matrix.toString(), equals(expected));
    });

    test(
        "Making sure that a matrix is properly built from a list of lists "
        "entries.", () async {
      final matrix = ComplexMatrix.fromData(columns: 2, rows: 2, data: const [
        [Complex(1, 2), Complex(3, 4)],
        [Complex(5, 6), Complex(7, 8)],
      ]);

      // Checking the sizes
      expect(matrix.rowCount, equals(2));
      expect(matrix.columnCount, equals(2));

      // Checking the content of the matrix
      expect(matrix(0, 0), equals(Complex(1, 2)));
      expect(matrix(0, 1), equals(Complex(3, 4)));
      expect(matrix(1, 0), equals(Complex(5, 6)));
      expect(matrix(1, 1), equals(Complex(7, 8)));
    });
  });

  group("Testing equality of 'ComplexMatrix' objects", () {
    test("Making sure that objects comparison works properly.", () async {
      final matrix = ComplexMatrix(
        columns: 2,
        rows: 2,
      );

      // Equality tests
      expect(ComplexMatrix(columns: 2, rows: 2), equals(matrix));
      expect(ComplexMatrix(columns: 2, rows: 2) == matrix, isTrue);
      expect(
          ComplexMatrix(columns: 2, rows: 2).hashCode, equals(matrix.hashCode));

      // Inequality tests
      expect(ComplexMatrix(columns: 2, rows: 2, identity: true) == matrix,
          isFalse);
      expect(ComplexMatrix(columns: 2, rows: 1).hashCode == matrix.hashCode,
          isFalse);
    });
  });

  group("Testing operation on matrices (+, *, - and /)", () {
    /*
    * A = |    i   3-8i  |
    *     | 4+7i   0     |
    * */
    final matrixA = ComplexMatrix.fromData(columns: 2, rows: 2, data: const [
      [Complex.i(), Complex(3, -8)],
      [Complex(4, 7), Complex.zero()]
    ]);

    /*
    * B = |   5   -7+i  |
    *     |  6i    1+i  |
    * */
    final matrixB = ComplexMatrix.fromData(columns: 2, rows: 2, data: const [
      [Complex.fromReal(5), Complex(-7, 1)],
      [Complex.fromImaginary(6), Complex(1, 1)]
    ]);

    test("Making sure that operator+ works properly.", () async {
      final matrixSum =
          ComplexMatrix.fromData(columns: 2, rows: 2, data: const [
        [Complex(5, 1), Complex(-4, -7)],
        [Complex(4, 13), Complex(1, 1)]
      ]);
      expect(matrixA + matrixB, equals(matrixSum));
    });

    test("Making sure that operator- works properly.", () async {
      final matrixSub = ComplexMatrix.fromData(columns: 2, rows: 2, data: [
        [Complex(-5, 1), Complex(10, -9)],
        [Complex(4, 1), Complex(-1, -1)]
      ]);
      expect(matrixA - matrixB, equals(matrixSub));
    });

    test("Making sure that operator* works properly.", () async {
      final matrixProd = ComplexMatrix.fromData(columns: 2, rows: 2, data: [
        [Complex(48, 23), Complex(10, -12)],
        [Complex(20, 35), Complex(-35, -45)]
      ]);
      expect(matrixA * matrixB, equals(matrixProd));
    });

    test("Making sure that operator/ works properly.", () async {
      final divResult = matrixA / matrixB;

      // Comparing members one by one due to machine precision issues
      expect(divResult(0, 0), equals(Complex(0, 1 / 5)));
      expect(divResult(1, 1), equals(Complex.zero()));

      // Value at [1, 0]
      expect(divResult(1, 0).real, MoreOrLessEquals(7 / 6, precision: 1.0e-3));
      expect(divResult(1, 0).imaginary,
          MoreOrLessEquals(-2 / 3, precision: 1.0e-3));

      // Value at [0, 1]
      expect(
          divResult(0, 1).real, MoreOrLessEquals(-29 / 50, precision: 1.0e-3));
      expect(divResult(0, 1).imaginary,
          MoreOrLessEquals(53 / 50, precision: 1.0e-3));
    });
  });

  group("Testing the computation of the determinant.", () {
    test("Making sure that the determinant of an 1*1 matrix is correct.", () {
      final matrix = ComplexMatrix.fromData(columns: 1, rows: 1, data: [
        [Complex(4, 7)]
      ]);
      expect(matrix.determinant(), equals(Complex(4, 7)));
    });

    test("Making sure that the determinant of a 2*2 matrix is correct.", () {
      final matrix = ComplexMatrix.fromData(columns: 2, rows: 2, data: [
        [Complex(48, 23), Complex(10, -12)],
        [Complex(20, 35), Complex(-35, -45)]
      ]);
      expect(matrix.determinant(), equals(Complex(-1265, -3075)));
    });

    test("Making sure that the determinant of a 3*3 matrix is correct.", () {
      final matrix = ComplexMatrix.fromData(columns: 3, rows: 3, data: const [
        [Complex.i(), Complex(3, -8), Complex(3, -3)],
        [Complex(4, 7), Complex.zero(), Complex(2, -6)],
        [Complex(6, 1), Complex.zero(), Complex(5, 4)],
      ]);
      expect(matrix.determinant(), equals(Complex(-602, -463)));
    });

    test("Making sure that the determinant of a 4*4 matrix is correct.", () {
      final matrix = ComplexMatrix.fromData(columns: 4, rows: 4, data: const [
        [Complex.i(), Complex(3, -8), Complex(3, -3), Complex.i()],
        [Complex(4, 7), Complex.zero(), Complex(2, -6), Complex.zero()],
        [Complex(6, 1), Complex.zero(), Complex(5, 4), Complex(1, 2)],
        [Complex(3, -2), Complex(5, 2), Complex(1, 3), Complex(6, -3)],
      ]);
      expect(matrix.determinant(), equals(Complex(-5444, -802)));
    });

    test("Making sure that the determinant of a 5*5 matrix is correct.", () {
      final matrix = ComplexMatrix.fromData(columns: 5, rows: 5, data: const [
        [
          Complex.i(),
          Complex(3, -8),
          Complex(3, -3),
          Complex.i(),
          Complex(4, -4)
        ],
        [
          Complex(-4, 4),
          Complex(2, 9),
          Complex(4, 7),
          Complex(-2, 5),
          Complex(10, 2)
        ],
        [
          Complex(4, 7),
          Complex.zero(),
          Complex(6, 7),
          Complex(2, -6),
          Complex.zero()
        ],
        [
          Complex(6, 1),
          Complex.i(),
          Complex.zero(),
          Complex(5, 4),
          Complex(1, 2)
        ],
        [
          Complex(3, -2),
          Complex(5, 2),
          Complex(1, 3),
          Complex(6, -3),
          Complex.fromReal(8)
        ],
      ]);
      expect(matrix.determinant(), equals(Complex(33818, 21240)));
    });
  });

  group("Testing operations on matrices.", () {
    test("Making sure that LU factorization works correctly.", () {
      final matrix = ComplexMatrix.fromData(columns: 3, rows: 3, data: [
        [Complex.fromReal(1), Complex.fromReal(2), Complex.fromReal(3)],
        [Complex.fromReal(4), Complex.fromReal(5), Complex.fromReal(6)],
        [Complex.fromReal(7), Complex.fromReal(8), Complex.fromReal(9)],
      ]);

      // Expected results
      final L = ComplexMatrix.fromData(columns: 3, rows: 3, data: [
        [Complex.fromReal(1), Complex.fromReal(0), Complex.fromReal(0)],
        [Complex.fromReal(4), Complex.fromReal(1), Complex.fromReal(0)],
        [Complex.fromReal(7), Complex.fromReal(2), Complex.fromReal(1)],
      ]);
      final U = ComplexMatrix.fromData(columns: 3, rows: 3, data: [
        [Complex.fromReal(1), Complex.fromReal(2), Complex.fromReal(3)],
        [Complex.fromReal(0), Complex.fromReal(-3), Complex.fromReal(-6)],
        [Complex.fromReal(0), Complex.fromReal(0), Complex.fromReal(0)],
      ]);

      // Checking the results
      final lu = matrix.luDecomposition();

      expect(lu[0], equals(L));
      expect(lu[1], equals(U));
    });
  });
}
