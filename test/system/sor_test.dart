import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing the 'SORSolver' class.", () {
    test(
      'Making sure that the sor iterative method works properly with a'
      ' well formed matrix.',
      () {
        final sor = SORSolver(
          matrix: RealMatrix.fromData(
            rows: 3,
            columns: 3,
            data: const [
              [3, -1, 1],
              [-1, 3, -1],
              [1, -1, 3],
            ],
          ),
          knownValues: [-1, 7, -7],
          w: 1.25,
        );

        // This is needed because we want to make sure that the "original" matrix
        // doesn't get side effects from the calculations (i.e. row swapping).
        final matrix = RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [3, -1, 1],
            [-1, 3, -1],
            [1, -1, 3],
          ],
        );

        // Checking the "state" of the object
        expect(sor.matrix, equals(matrix));
        expect(sor.knownValues, orderedEquals(<double>[-1, 7, -7]));
        expect(sor.w, equals(1.25));
        expect(sor.maxSteps, equals(30));
        expect(sor.precision, equals(1.0e-10));
        expect(sor.size, equals(3));
        expect(sor.hasSolution(), isTrue);

        // Solutions
        expect(sor.determinant(), equals(20));

        final solutions = sor.solve();
        expect(solutions.first, const MoreOrLessEquals(1, precision: 1.0e-2));
        expect(solutions[1], const MoreOrLessEquals(2, precision: 1.0e-2));
        expect(solutions[2], const MoreOrLessEquals(-2, precision: 1.0e-2));
      },
    );

    test('Making sure that the string conversion works properly.', () {
      final solver = SORSolver(
        matrix: RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [3, -1, 1],
            [-1, 3, -1],
            [1, -1, 3],
          ],
        ),
        knownValues: [-1, 7, -7],
        w: 1.25,
      );

      const toString = '[3.0, -1.0, 1.0]\n'
          '[-1.0, 3.0, -1.0]\n'
          '[1.0, -1.0, 3.0]';
      const toStringAugmented = '[3.0, -1.0, 1.0 | -1.0]\n'
          '[-1.0, 3.0, -1.0 | 7.0]\n'
          '[1.0, -1.0, 3.0 | -7.0]';

      expect(solver.toString(), equals(toString));
      expect(solver.toStringAugmented(), equals(toStringAugmented));
    });

    test(
      'Making sure that the matrix is square.',
      () {
        expect(
          () => SORSolver(
            matrix: RealMatrix.fromData(
              rows: 2,
              columns: 3,
              data: const [
                [1, 2, 4],
                [3, 4, 0],
              ],
            ),
            knownValues: [7, 8, 9],
            w: 2,
          ),
          throwsA(isA<SystemSolverException>()),
        );
      },
    );

    test(
      'Making sure that the matrix is square AND the dimension of the '
      'known values vector also matches the size of the matrix.',
      () {
        expect(
          () => SORSolver(
            matrix: RealMatrix.fromData(
              rows: 2,
              columns: 2,
              data: const [
                [1, 2],
                [3, 4],
              ],
            ),
            knownValues: [7, 8, 9],
            w: 2,
          ),
          throwsA(isA<SystemSolverException>()),
        );
      },
    );

    test('Making sure that objects comparison works properly.', () {
      final sor = SORSolver(
        matrix: RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [1, 2],
            [3, 4],
          ],
        ),
        knownValues: [0, -6],
        w: 2,
      );

      final sor2 = SORSolver(
        matrix: RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [1, 2],
            [3, 4],
          ],
        ),
        knownValues: [0, -6],
        w: 2,
      );

      expect(sor, equals(sor2));
      expect(sor == sor2, isTrue);
      expect(sor2, equals(sor));
      expect(sor2 == sor, isTrue);
      expect(sor.hashCode, equals(sor2.hashCode));
    });

    test('Batch tests', () {
      final systems = [
        SORSolver(
          matrix: RealMatrix.fromData(
            rows: 3,
            columns: 3,
            data: const [
              [3, -1, 1],
              [-1, 3, -1],
              [1, -1, 3],
            ],
          ),
          knownValues: [-1, 7, -7],
          w: 1.25,
        ).solve(),
        SORSolver(
          matrix: RealMatrix.fromData(
            rows: 3,
            columns: 3,
            data: const [
              [4, -2, 0],
              [-2, 6, -5],
              [0, -5, 11],
            ],
          ),
          knownValues: [8, -29, 43],
          w: 1.2,
        ).solve(),
        SORSolver(
          matrix: RealMatrix.fromData(
            rows: 3,
            columns: 3,
            data: const [
              [3, -1, 1],
              [-1, 3, -1],
              [1, -1, 3],
            ],
          ),
          knownValues: [-1, 7, -7],
          w: 1.65,
        ).solve(),
      ];

      const solutions = <List<double>>[
        [1, 2, -2],
        [1, -2, 3],
        [1, 2, -2],
      ];

      for (var i = 0; i < systems.length; ++i) {
        for (var j = 0; j < 2; ++j) {
          expect(
            systems[i][j],
            MoreOrLessEquals(solutions[i][j], precision: 1.0e-4),
          );
        }
      }
    });
  });
}
