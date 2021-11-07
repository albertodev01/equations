import 'dart:math';

import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  group('Testing the behaviors of the SylvesterMatrix class.', () {
    final matrix = SylvesterMatrix.fromReal(
      coefficients: [
        1,
        -7,
        8,
      ],
    );

    test('Making sure that values are properly constructed.', () {
      expect(
        matrix.coefficients,
        orderedEquals(
          const <Complex>[
            Complex.fromReal(1),
            Complex.fromReal(-7),
            Complex.fromReal(8),
          ],
        ),
      );
    });

    test('Making sure that the list of coefficients is unmodifiable.', () {
      expect(
        () => matrix.coefficients.first = const Complex.zero(),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('Making sure that the discriminant is properly computed.', () {
      expect(
        matrix.polynomialDiscriminant(),
        equals(const Complex(17, 0)),
      );
      expect(
        matrix.polynomialDiscriminant(optimize: false),
        equals(const Complex(17, 0)),
      );
    });

    test('Making sure that the matrix is correctly built.', () {
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

      expect(
        matrix.buildMatrix(),
        equals(expected),
      );
    });

    test('Making sure that the determinant is properly computed.', () {
      expect(
        matrix.matrixDeterminant(),
        equals(-const Complex(17, 0)),
      );
    });

    test('Making sure that SylvesterMatrix instances can be compared.', () {
      final matrix2 = SylvesterMatrix(
        coefficients: const [
          Complex.fromReal(1),
          Complex.fromReal(-7),
          Complex.fromReal(8),
        ],
      );

      expect(matrix == matrix2, isTrue);
      expect(matrix.hashCode, equals(matrix2.hashCode));
    });

    test('Batch tests', () {
      final poly = [
        Algebraic.fromReal([2, -1, 5]),
        Algebraic.fromReal([4, -1, 10, -5]),
        Algebraic.fromReal([3, 7, 0, -5, 1, 2]),
      ];

      const determinants = [
        Complex.fromReal(78),
        Complex.fromReal(92480),
        Complex.fromReal(-784356),
      ];

      final sylvesterMatrices = [
        ComplexMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [Complex.fromReal(2), Complex.fromReal(-1), Complex.fromReal(5)],
            [Complex.fromReal(4), Complex.fromReal(-1), Complex.fromReal(0)],
            [Complex.fromReal(0), Complex.fromReal(4), Complex.fromReal(-1)],
          ],
        ),
        ComplexMatrix.fromFlattenedData(
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
        ),
        ComplexMatrix.fromFlattenedData(
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
        ),
      ];

      for (var i = 0; i < determinants.length; ++i) {
        final matrix = SylvesterMatrix(
          coefficients: poly[i].coefficients,
        );

        expect(
          matrix.buildMatrix(),
          equals(sylvesterMatrices[i]),
        );

        final determinant = matrix.matrixDeterminant();
        expect(
          determinant.real,
          MoreOrLessEquals(determinants[i].real, precision: 1.0e-5),
        );
        expect(
          determinant.imaginary,
          MoreOrLessEquals(determinants[i].imaginary, precision: 1.0e-5),
        );

        // Discriminant computation
        final degree = poly[i].degree;
        const complexOne = Complex.fromReal(1);

        final resSign = pow(-1, degree * (degree - 1) / 2) as double;
        final sign = Complex.fromReal(resSign);
        final discriminant = sign * (complexOne / poly[i][0]) * determinant;

        expect(
          discriminant.real.round(),
          equals(poly[i].discriminant().real.round()),
        );
      }
    });
  });
}
