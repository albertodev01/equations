import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/singular_value_decomposition/complex_svd.dart';
import 'package:equations/src/system/utils/matrix/decompositions/singular_value_decomposition/real_svd.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  group('SingleValueDecomposition class', () {
    test('Equality tests', () {
      final real = SVDReal(
        matrix: RealMatrix.fromData(
          rows: 1,
          columns: 1,
          data: [
            [1],
          ],
        ),
      );

      final complex = SVDComplex(
        matrix: ComplexMatrix.fromData(
          rows: 1,
          columns: 1,
          data: const [
            [Complex.i()],
          ],
        ),
      );

      expect(
        SVDReal(
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
          SVDReal(
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
        SVDReal(
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

      expect(
        SVDComplex(
          matrix: ComplexMatrix.fromData(
            rows: 1,
            columns: 1,
            data: const [
              [Complex.i()],
            ],
          ),
        ),
        equals(complex),
      );

      expect(
        complex,
        equals(
          SVDComplex(
            matrix: ComplexMatrix.fromData(
              rows: 1,
              columns: 1,
              data: const [
                [Complex.i()],
              ],
            ),
          ),
        ),
      );

      expect(
        SVDComplex(
          matrix: ComplexMatrix.fromData(
            rows: 1,
            columns: 1,
            data: const [
              [Complex.i()],
            ],
          ),
        ).hashCode,
        equals(complex.hashCode),
      );
    });

    group('Real values', () {
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
        final E = svd.first;
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

      test(
        'Making sure that SVD decomposition works on a non-square matrix',
        () {
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
          final E = svd.first;
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

          // Making sure that U x E x Vt (where Vt is V transposed) equals to
          // the starting matrix
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
        },
      );

      test(
        'Making sure that the SVD algorithm does NOT throw exceptions with '
        'particular matrices.',
        () {
          expect(
            RealMatrix.fromData(
              rows: 2,
              columns: 3,
              data: const [
                [3, -5, 1],
                [4, -3, 9],
              ],
            ).singleValueDecomposition(),
            isA<List<RealMatrix>>(),
          );

          expect(
            RealMatrix.fromData(
              rows: 2,
              columns: 2,
              data: const [
                [-3, 0],
                [0, -3],
              ],
            ).singleValueDecomposition(),
            isA<List<RealMatrix>>(),
          );

          expect(
            RealMatrix.fromData(
              rows: 2,
              columns: 4,
              data: const [
                [0, 3, -5, 1],
                [4, 0, -3, 9],
              ],
            ).singleValueDecomposition(),
            isA<List<RealMatrix>>(),
          );

          expect(
            RealMatrix.fromData(
              rows: 3,
              columns: 6,
              data: const [
                [0, 3, -5, 1, 0, -1],
                [4, 0, -3, 9, 0, 0],
                [4, 5, 0, -1, -2, 1],
              ],
            ).singleValueDecomposition(),
            isA<List<RealMatrix>>(),
          );

          expect(
            RealMatrix.fromData(
              rows: 5,
              columns: 5,
              data: const [
                [-1, 0, 0, 0, 1],
                [0, -1, 0, 1, 0],
                [0, 0, 1, 0, 0],
                [0, 1, 0, -1, 0],
                [1, 0, 0, 0, -1],
              ],
            ).singleValueDecomposition(),
            isA<List<RealMatrix>>(),
          );

          // Small values precision
          expect(
            RealMatrix.fromData(
              rows: 5,
              columns: 4,
              data: const [
                [0, 0, 1.0e-4, 4],
                [0, 0, 0, 0],
                [0, 0, 1.0e-6, 0],
                [0, 5, 0, 0],
                [0, 0, 1.0e-4, 0],
              ],
            ).singleValueDecomposition(),
            isA<List<RealMatrix>>(),
          );

          // Zeroes
          final zeroes = RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [0, 0],
              [0, 0],
            ],
          );
          final zeroesSvd = zeroes.singleValueDecomposition();

          expect(
            zeroesSvd.first,
            RealMatrix.fromFlattenedData(
              rows: 2,
              columns: 2,
              data: [0, 0, 0, 0],
            ),
          );
          expect(
            zeroesSvd[1],
            RealMatrix.fromFlattenedData(
              rows: 2,
              columns: 2,
              data: [1, 0, 0, 1],
            ),
          );
          expect(
            zeroesSvd[2],
            RealMatrix.fromFlattenedData(
              rows: 2,
              columns: 2,
              data: [-1, 0, 0, -1],
            ),
          );
          expect(
            zeroesSvd.first * zeroesSvd[1] * zeroesSvd[2].transpose(),
            equals(zeroes),
          );

          // Single element
          final special1x1 = RealMatrix.fromData(
            rows: 1,
            columns: 1,
            data: const [
              [8],
            ],
          ).singleValueDecomposition();

          expect(special1x1.first(0, 0), equals(8));
          expect(special1x1[1](0, 0), equals(1));
          expect(special1x1[2](0, 0), equals(1));
        },
      );
    });

    group('Complex values', () {
      test('Making sure that SVD decomposition works on a square matrix', () {
        final matrix = ComplexMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [Complex.fromReal(1), Complex.fromReal(5)],
            [Complex.fromReal(7), Complex.fromReal(-3)],
          ],
        );

        // Decomposition
        final svd = matrix.singleValueDecomposition();
        expect(svd.length, equals(3));

        // Checking E
        final E = svd.first;
        expect(E.isSquareMatrix, isTrue);
        expect(
          E(0, 0).real,
          const MoreOrLessEquals(-7.73877, precision: 1.0e-5),
        );
        expect(
          E(0, 1).real,
          isZero,
        );
        expect(
          E(1, 0).real,
          isZero,
        );
        expect(
          E(1, 1).real,
          const MoreOrLessEquals(-4.91034, precision: 1.0e-5),
        );

        // Checking U
        final U = svd[1];
        expect(U.isSquareMatrix, isTrue);
        expect(
          U(0, 0).real,
          const MoreOrLessEquals(0.22975, precision: 1.0e-5),
        );
        expect(
          U(0, 1).real,
          const MoreOrLessEquals(-0.97324, precision: 1.0e-5),
        );
        expect(
          U(1, 0).real,
          const MoreOrLessEquals(-0.97324, precision: 1.0e-5),
        );
        expect(
          U(1, 1).real,
          const MoreOrLessEquals(-0.229753, precision: 1.0e-5),
        );

        // Checking V
        final V = svd[2];
        expect(V.isSquareMatrix, isTrue);
        expect(
          V(0, 0).real,
          const MoreOrLessEquals(0.85065, precision: 1.0e-5),
        );
        expect(
          V(0, 1).real,
          const MoreOrLessEquals(0.52573, precision: 1.0e-5),
        );
        expect(
          V(1, 0).real,
          const MoreOrLessEquals(-0.52573, precision: 1.0e-5),
        );
        expect(
          V(1, 1).real,
          const MoreOrLessEquals(0.85065, precision: 1.0e-5),
        );

        // Making sure that U x E x Vt (where Vt is V transposed) equals to the
        // starting matrix
        final original = U * E * V.transpose();

        expect(
          original(0, 0).real,
          const MoreOrLessEquals(1, precision: 1.0e-5),
        );
        expect(
          original(0, 1).real,
          const MoreOrLessEquals(5, precision: 1.0e-5),
        );
        expect(
          original(1, 0).real,
          const MoreOrLessEquals(7, precision: 1.0e-5),
        );
        expect(
          original(1, 1).real,
          const MoreOrLessEquals(-3, precision: 1.0e-5),
        );
      });

      test(
        'Making sure that SVD decomposition works on a non-square matrix',
        () {
          final matrix = ComplexMatrix.fromData(
            rows: 3,
            columns: 2,
            data: const [
              [Complex.fromReal(3), Complex.fromReal(-5)],
              [Complex.fromReal(4), Complex.fromReal(9)],
              [Complex.fromReal(-2), Complex.fromReal(1)],
            ],
          );

          // Decomposition
          final svd = matrix.singleValueDecomposition();
          expect(svd.length, equals(3));

          // Checking E
          final E = svd.first;
          expect(E.isSquareMatrix, isFalse);
          expect(E.rowCount, equals(3));
          expect(E.columnCount, equals(2));
          expect(
            E(0, 0).real,
            const MoreOrLessEquals(-10.55376, precision: 1.0e-5),
          );
          expect(
            E(0, 1).real,
            isZero,
          );
          expect(
            E(1, 0).real,
            isZero,
          );
          expect(
            E(1, 1).real,
            const MoreOrLessEquals(-4.96165, precision: 1.0e-5),
          );
          expect(
            E(2, 0).real,
            isZero,
          );
          expect(
            E(2, 1).real,
            isZero,
          );

          // Checking U
          final U = svd[1];
          expect(U.isSquareMatrix, isTrue);
          expect(
            U(0, 0).real,
            const MoreOrLessEquals(0.397763, precision: 1.0e-5),
          );
          expect(
            U(0, 1).real,
            const MoreOrLessEquals(0.815641, precision: 1.0e-5),
          );
          expect(
            U(0, 2).real,
            const MoreOrLessEquals(0.420135, precision: 1.0e-5),
          );
          expect(
            U(1, 0).real,
            const MoreOrLessEquals(-0.916139, precision: 1.0e-5),
          );
          expect(
            U(1, 1).real,
            const MoreOrLessEquals(0.377915, precision: 1.0e-5),
          );
          expect(
            U(1, 2).real,
            const MoreOrLessEquals(0.133679, precision: 1.0e-5),
          );
          expect(
            U(2, 0).real,
            const MoreOrLessEquals(-0.04974, precision: 1.0e-5),
          );
          expect(
            U(2, 1).real,
            const MoreOrLessEquals(-0.43807, precision: 1.0e-5),
          );
          expect(
            U(2, 2).real,
            const MoreOrLessEquals(0.89756, precision: 1.0e-5),
          );

          // Checking V
          final V = svd[2];
          expect(V.isSquareMatrix, isTrue);
          expect(
            V(0, 0).real,
            const MoreOrLessEquals(0.22473, precision: 1.0e-5),
          );
          expect(
            V(0, 1).real,
            const MoreOrLessEquals(-0.97442, precision: 1.0e-5),
          );
          expect(
            V(1, 0).real,
            const MoreOrLessEquals(0.97442, precision: 1.0e-5),
          );
          expect(
            V(1, 1).real,
            const MoreOrLessEquals(0.22473, precision: 1.0e-5),
          );

          // Making sure that U x E x Vt (where Vt is V transposed) equals to
          // the starting matrix
          final original = U * E * V.transpose();

          expect(
            original(0, 0).real,
            const MoreOrLessEquals(3, precision: 1.0e-5),
          );
          expect(
            original(0, 1).real,
            const MoreOrLessEquals(-5, precision: 1.0e-5),
          );
          expect(
            original(1, 0).real,
            const MoreOrLessEquals(4, precision: 1.0e-5),
          );
          expect(
            original(1, 1).real,
            const MoreOrLessEquals(9, precision: 1.0e-5),
          );
          expect(
            original(2, 0).real,
            const MoreOrLessEquals(-2, precision: 1.0e-5),
          );
          expect(
            original(2, 1).real,
            const MoreOrLessEquals(1, precision: 1.0e-5),
          );
        },
      );

      test(
        'Making sure that the SVD algorithm does NOT throw exceptions with '
        'particular matrices.',
        () {
          expect(
            ComplexMatrix.fromData(
              rows: 2,
              columns: 3,
              data: const [
                [
                  Complex.fromReal(3),
                  Complex.fromReal(-5),
                  Complex.fromReal(1),
                ],
                [
                  Complex.fromReal(4),
                  Complex.fromReal(-3),
                  Complex.fromReal(9),
                ],
              ],
            ).singleValueDecomposition(),
            isA<List<ComplexMatrix>>(),
          );

          expect(
            ComplexMatrix.fromData(
              rows: 2,
              columns: 2,
              data: const [
                [Complex.fromReal(-3), Complex.i()],
                [Complex.i(), Complex.fromReal(-3)],
              ],
            ).singleValueDecomposition(),
            isA<List<ComplexMatrix>>(),
          );

          expect(
            ComplexMatrix.fromData(
              rows: 2,
              columns: 4,
              data: const [
                [
                  Complex.zero(),
                  Complex.fromReal(3),
                  Complex.fromReal(-5),
                  Complex.fromReal(1),
                ],
                [
                  Complex.fromReal(4),
                  Complex.zero(),
                  Complex.fromReal(-3),
                  Complex.fromReal(9),
                ],
              ],
            ).singleValueDecomposition(),
            isA<List<ComplexMatrix>>(),
          );

          expect(
            ComplexMatrix.fromData(
              rows: 3,
              columns: 6,
              data: const [
                [
                  Complex.zero(),
                  Complex.fromReal(3),
                  Complex.fromReal(-5),
                  Complex.fromReal(1),
                  Complex.zero(),
                  Complex.fromReal(-1),
                ],
                [
                  Complex.fromReal(4),
                  Complex.zero(),
                  Complex.fromReal(-3),
                  Complex.fromReal(9),
                  Complex.zero(),
                  Complex.zero(),
                ],
                [
                  Complex.fromReal(4),
                  Complex.fromReal(5),
                  Complex.zero(),
                  Complex.fromReal(-1),
                  Complex.fromReal(-2),
                  Complex.fromReal(1),
                ],
              ],
            ).singleValueDecomposition(),
            isA<List<ComplexMatrix>>(),
          );

          expect(
            ComplexMatrix.fromData(
              rows: 5,
              columns: 5,
              data: const [
                [
                  Complex.fromReal(-1),
                  Complex.zero(),
                  Complex.fromReal(1.0e-5),
                  Complex.zero(),
                  Complex.i(),
                ],
                [
                  Complex.zero(),
                  Complex.fromReal(-1),
                  Complex.zero(),
                  Complex.i(),
                  Complex.zero(),
                ],
                [
                  Complex.zero(),
                  Complex.zero(),
                  Complex.i(),
                  Complex.zero(),
                  Complex.zero(),
                ],
                [
                  Complex.zero(),
                  Complex.i(),
                  Complex.zero(),
                  Complex.fromReal(-1),
                  Complex.zero(),
                ],
                [
                  Complex.i(),
                  Complex.zero(),
                  Complex.zero(),
                  Complex.zero(),
                  Complex.fromReal(-1),
                ],
              ],
            ).singleValueDecomposition(),
            isA<List<ComplexMatrix>>(),
          );

          // Small values precision
          expect(
            ComplexMatrix.fromData(
              rows: 5,
              columns: 4,
              data: const [
                [
                  Complex.fromReal(1),
                  Complex.fromReal(1),
                  Complex.fromReal(0),
                  Complex.fromReal(1.0e-8),
                ],
                [
                  Complex.zero(),
                  Complex.zero(),
                  Complex.zero(),
                  Complex.zero(),
                ],
                [
                  Complex.zero(),
                  Complex.zero(),
                  Complex.fromReal(1.0e-6),
                  Complex.zero(),
                ],
                [
                  Complex.zero(),
                  Complex.fromReal(1),
                  Complex.fromReal(2),
                  Complex.zero(),
                ],
                [
                  Complex.zero(),
                  Complex.zero(),
                  Complex.fromReal(1.0e-10),
                  Complex.zero(),
                ],
              ],
            ).singleValueDecomposition(),
            isA<List<ComplexMatrix>>(),
          );

          // Complex entries
          final complexSvd = ComplexMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [Complex.i(), Complex(2, 0)],
              [Complex(7, 1), Complex.fromReal(6)],
            ],
          ).singleValueDecomposition();

          final matrix =
              complexSvd[1] * complexSvd.first * complexSvd[2].transpose();
          expect(
            matrix(0, 0).real,
            const MoreOrLessEquals(0, precision: 1.0e-5),
          );
          expect(
            matrix(0, 0).imaginary,
            const MoreOrLessEquals(1, precision: 1.0e-5),
          );
          expect(
            matrix(0, 1).real,
            const MoreOrLessEquals(2, precision: 1.0e-5),
          );
          expect(
            matrix(0, 1).imaginary,
            const MoreOrLessEquals(0, precision: 1.0e-5),
          );
          expect(
            matrix(1, 0).real,
            const MoreOrLessEquals(7, precision: 1.0e-5),
          );
          expect(
            matrix(1, 0).imaginary,
            const MoreOrLessEquals(1, precision: 1.0e-5),
          );
          expect(
            matrix(1, 1).real,
            const MoreOrLessEquals(6, precision: 1.0e-5),
          );
          expect(
            matrix(1, 1).imaginary,
            const MoreOrLessEquals(0, precision: 1.0e-5),
          );

          // Single element
          final special1x1 = ComplexMatrix.fromData(
            rows: 1,
            columns: 1,
            data: const [
              [Complex.fromReal(3)],
            ],
          ).singleValueDecomposition();

          expect(special1x1.first(0, 0), equals(const Complex.fromReal(3)));
          expect(special1x1[1](0, 0), equals(const Complex.fromReal(1)));
          expect(special1x1[2](0, 0), equals(const Complex.fromReal(1)));
        },
      );
    });
  });
}
