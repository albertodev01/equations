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

    group('Edge cases', () {
      test('Constant polynomials have no Sylvester matrix.', () {
        final matrix = SylvesterMatrix(polynomial: Algebraic.fromReal([5]));

        expect(matrix.buildMatrix, throwsA(isA<MatrixException>()));
      });

      test('Small coefficients are not dropped from the matrix.', () {
        // x^5 + 1e-11 * x
        final matrix = SylvesterMatrix(
          polynomial: Algebraic.fromReal([1, 0, 0, 0, 1e-11, 0]),
        );
        final sylvester = matrix.buildMatrix();

        // The coefficient of x in the first row of P...
        expect(sylvester(0, 4), equals(const Complex.fromReal(1e-11)));
        // ...and the coefficient of x^0 in the first row of P'.
        expect(sylvester(4, 4), equals(const Complex.fromReal(1e-11)));

        // Disc(x^5 + ax) = 256 * a^5
        const expected = 256 * 1e-55;
        final discriminant = matrix.polynomialDiscriminant();

        expect(
          discriminant.real,
          const MoreOrLessEquals(expected, precision: expected * 1e-9),
        );
        expect(discriminant.imaginary, equals(0));
      });

      test('Small leading coefficients are accepted.', () {
        // 1e-12 * (x - 1)(x - 2)(x - 3)(x - 4)(x - 5)
        final matrix = SylvesterMatrix(
          polynomial: Algebraic.fromReal(
            [1, -15, 85, -225, 274, -120].map((c) => c * 1e-12).toList(),
          ),
        );

        // Scaling by 'a' multiplies the discriminant by a^(2n - 2)
        const expected = 82944 * 1e-96;
        final discriminant = matrix.polynomialDiscriminant();

        expect(
          discriminant.real,
          const MoreOrLessEquals(expected, precision: expected * 1e-9),
        );
        expect(discriminant.imaginary, equals(0));
      });

      test('Negative sign of the resultant (degree 6).', () {
        // (x - 1)(x - 2)(x - 3)(x - 4)(x - 5)(x - 6), where n(n - 1)/2 = 15
        final matrix = SylvesterMatrix(
          polynomial: Algebraic.fromReal([1, -21, 175, -735, 1624, -1764, 720]),
        );
        final discriminant = matrix.polynomialDiscriminant();

        // The product of the squared differences of the roots
        const expected = 1194393600.0;
        expect(
          discriminant.real,
          const MoreOrLessEquals(expected, precision: expected * 1e-9),
        );
        expect(discriminant.imaginary, equals(0));
      });

      test('Low degree GenericAlgebraic uses the closed-form formulas.', () {
        final quadratic = GenericAlgebraic.realEquation(
          coefficients: [1, -7, 8],
        );
        final quartic = GenericAlgebraic.realEquation(
          coefficients: [1, 0, 0, 0, 1],
        );

        expect(quadratic.discriminant(), equals(const Complex.fromReal(17)));
        expect(quartic.discriminant(), equals(const Complex.fromReal(256)));
        expect(
          SylvesterMatrix(polynomial: quartic).polynomialDiscriminant(),
          equals(Algebraic.fromReal([1, 0, 0, 0, 1]).discriminant()),
        );
      });
    });
  });
}
