import 'dart:math';

import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  group('SylvesterMatrix', () {
    final matrix = SylvesterMatrix(
      polynomial: Algebraic.fromReal(
        [1, -7, 8],
      ),
    );

    test('Smoke test.', () {
      expect(
        matrix.polynomial.coefficients,
        orderedEquals(const <Complex>[
          Complex.fromReal(1),
          Complex.fromReal(-7),
          Complex.fromReal(8),
        ]),
      );
    });

    test('Polynomial discriminant.', () {
      expect(
        matrix.polynomialDiscriminant(),
        equals(
          const Complex(17, 0),
        ),
      );
    });

    test('Matrix construction.', () {
      final expected = ComplexMatrix.fromFlattenedData(
        rows: 3,
        columns: 3,
        data: const [
          Complex.fromReal(1),
          Complex.fromReal(-7),
          Complex.fromReal(8),
          Complex.fromReal(2),
          Complex.fromReal(-7),
          Complex.zero(),
          Complex.zero(),
          Complex.fromReal(2),
          Complex.fromReal(-7),
        ],
      );

      expect(matrix.buildMatrix(), equals(expected));
    });

    test('Determinant computation.', () {
      expect(
        matrix.matrixDeterminant(),
        equals(
          -const Complex(17, 0),
        ),
      );
    });

    test('Objects comparison.', () {
      final matrix2 = SylvesterMatrix(
        polynomial: Algebraic.from(const [
          Complex.fromReal(1),
          Complex.fromReal(-7),
          Complex.fromReal(8),
        ]),
      );

      expect(matrix == matrix2, isTrue);
      expect(matrix2 == matrix, isTrue);
      expect(matrix, equals(matrix2));
      expect(matrix2, equals(matrix));

      expect(
        matrix ==
            SylvesterMatrix(
              polynomial: Algebraic.from(const [
                Complex.fromReal(1),
                Complex.fromReal(-7),
                Complex.fromReal(8),
              ]),
            ),
        isTrue,
      );
      expect(
        SylvesterMatrix(
              polynomial: Algebraic.from(const [
                Complex.fromReal(1),
                Complex.fromReal(-7),
                Complex.fromReal(8),
              ]),
            ) ==
            matrix,
        isTrue,
      );

      expect(matrix.hashCode, equals(matrix2.hashCode));
    });

    group('Determinant tests', () {
      test('Test 1', () {
        final poly = Algebraic.fromReal([2, -1, 5]);
        final matrix = SylvesterMatrix(polynomial: poly);
        const expectedDeterminant = Complex.fromReal(78);

        final expectedMatrix = ComplexMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [Complex.fromReal(2), Complex.fromReal(-1), Complex.fromReal(5)],
            [Complex.fromReal(4), Complex.fromReal(-1), Complex.fromReal(0)],
            [Complex.fromReal(0), Complex.fromReal(4), Complex.fromReal(-1)],
          ],
        );

        expect(matrix.buildMatrix(), equals(expectedMatrix));

        final determinant = matrix.matrixDeterminant();
        expect(
          determinant.real,
          MoreOrLessEquals(expectedDeterminant.real, precision: 1.0e-5),
        );
        expect(
          determinant.imaginary,
          MoreOrLessEquals(expectedDeterminant.imaginary, precision: 1.0e-5),
        );

        // Discriminant computation
        final degree = poly.degree;
        const complexOne = Complex.fromReal(1);
        final resSign = pow(-1, degree * (degree - 1) / 2) as double;
        final sign = Complex.fromReal(resSign);
        final discriminant = sign * (complexOne / poly[0]) * determinant;

        expect(
          discriminant.real.round(),
          equals(poly.discriminant().real.round()),
        );
      });

      test('Test 2', () {
        final poly = Algebraic.fromReal([4, -1, 10, -5]);
        final matrix = SylvesterMatrix(polynomial: poly);
        const expectedDeterminant = Complex.fromReal(92480);

        final expectedMatrix = ComplexMatrix.fromFlattenedData(
          rows: 5,
          columns: 5,
          data: const [
            Complex.fromReal(4),
            Complex.fromReal(-1),
            Complex.fromReal(10),
            Complex.fromReal(-5),
            Complex.zero(),
            Complex.zero(),
            Complex.fromReal(4),
            Complex.fromReal(-1),
            Complex.fromReal(10),
            Complex.fromReal(-5),
            Complex.fromReal(12),
            Complex.fromReal(-2),
            Complex.fromReal(10),
            Complex.zero(),
            Complex.zero(),
            Complex.zero(),
            Complex.fromReal(12),
            Complex.fromReal(-2),
            Complex.fromReal(10),
            Complex.zero(),
            Complex.zero(),
            Complex.zero(),
            Complex.fromReal(12),
            Complex.fromReal(-2),
            Complex.fromReal(10),
          ],
        );

        expect(matrix.buildMatrix(), equals(expectedMatrix));

        final determinant = matrix.matrixDeterminant();
        expect(
          determinant.real,
          MoreOrLessEquals(expectedDeterminant.real, precision: 1.0e-5),
        );
        expect(
          determinant.imaginary,
          MoreOrLessEquals(expectedDeterminant.imaginary, precision: 1.0e-5),
        );

        // Discriminant computation
        final degree = poly.degree;
        const complexOne = Complex.fromReal(1);
        final resSign = pow(-1, degree * (degree - 1) / 2) as double;
        final sign = Complex.fromReal(resSign);
        final discriminant = sign * (complexOne / poly[0]) * determinant;

        expect(
          discriminant.real.round(),
          equals(poly.discriminant().real.round()),
        );
      });

      test('Test 3', () {
        final poly = Algebraic.fromReal([3, 7, 0, -5, 1, 2]);
        final matrix = SylvesterMatrix(polynomial: poly);
        const expectedDeterminant = Complex.fromReal(-784356);

        final expectedMatrix = ComplexMatrix.fromFlattenedData(
          rows: 9,
          columns: 9,
          data: const [
            Complex.fromReal(3),
            Complex.fromReal(7),
            Complex.zero(),
            Complex.fromReal(-5),
            Complex.fromReal(1),
            Complex.fromReal(2),
            Complex.zero(),
            Complex.zero(),
            Complex.zero(),
            Complex.zero(),
            Complex.fromReal(3),
            Complex.fromReal(7),
            Complex.zero(),
            Complex.fromReal(-5),
            Complex.fromReal(1),
            Complex.fromReal(2),
            Complex.zero(),
            Complex.zero(),
            Complex.zero(),
            Complex.zero(),
            Complex.fromReal(3),
            Complex.fromReal(7),
            Complex.zero(),
            Complex.fromReal(-5),
            Complex.fromReal(1),
            Complex.fromReal(2),
            Complex.zero(),
            Complex.zero(),
            Complex.zero(),
            Complex.zero(),
            Complex.fromReal(3),
            Complex.fromReal(7),
            Complex.zero(),
            Complex.fromReal(-5),
            Complex.fromReal(1),
            Complex.fromReal(2),
            Complex.fromReal(15),
            Complex.fromReal(28),
            Complex.zero(),
            Complex.fromReal(-10),
            Complex.fromReal(1),
            Complex.zero(),
            Complex.zero(),
            Complex.zero(),
            Complex.zero(),
            Complex.zero(),
            Complex.fromReal(15),
            Complex.fromReal(28),
            Complex.zero(),
            Complex.fromReal(-10),
            Complex.fromReal(1),
            Complex.zero(),
            Complex.zero(),
            Complex.zero(),
            Complex.zero(),
            Complex.zero(),
            Complex.fromReal(15),
            Complex.fromReal(28),
            Complex.zero(),
            Complex.fromReal(-10),
            Complex.fromReal(1),
            Complex.zero(),
            Complex.zero(),
            Complex.zero(),
            Complex.zero(),
            Complex.zero(),
            Complex.fromReal(15),
            Complex.fromReal(28),
            Complex.zero(),
            Complex.fromReal(-10),
            Complex.fromReal(1),
            Complex.zero(),
            Complex.zero(),
            Complex.zero(),
            Complex.zero(),
            Complex.zero(),
            Complex.fromReal(15),
            Complex.fromReal(28),
            Complex.zero(),
            Complex.fromReal(-10),
            Complex.fromReal(1),
          ],
        );

        expect(matrix.buildMatrix(), equals(expectedMatrix));

        final determinant = matrix.matrixDeterminant();
        expect(
          determinant.real,
          MoreOrLessEquals(expectedDeterminant.real, precision: 1.0e-5),
        );
        expect(
          determinant.imaginary,
          MoreOrLessEquals(expectedDeterminant.imaginary, precision: 1.0e-5),
        );

        // Discriminant computation
        final degree = poly.degree;
        const complexOne = Complex.fromReal(1);
        final resSign = pow(-1, degree * (degree - 1) / 2) as double;
        final sign = Complex.fromReal(resSign);
        final discriminant = sign * (complexOne / poly[0]) * determinant;

        expect(
          discriminant.real.round(),
          equals(poly.discriminant().real.round()),
        );
      });
    });
  });
}
