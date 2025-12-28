import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  group("Testing the 'LUSolver' class.", () {
    test('Making sure that the LUSolver computes the correct results of a '
        'system of linear equations.', () {
      final luSolver = LUSolver(
        matrix: RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [7, -2, 1],
            [14, -7, -3],
            [-7, 11, 18],
          ],
        ),
        knownValues: const [12, 17, 5],
      );

      // This is needed because we want to make sure that the "original"
      // matrix doesn't get side effects from the calculations (i.e. row
      // swapping).
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [7, -2, 1],
          [14, -7, -3],
          [-7, 11, 18],
        ],
      );

      // Checking solutions
      final results = luSolver.solve();
      expect(
        results.map((e) => e.roundToDouble()),
        unorderedEquals(<double>[-1, 4, 3]),
      );

      // Checking the "state" of the object
      expect(luSolver.matrix, equals(matrix));
      expect(luSolver.knownValues, orderedEquals(<double>[12, 17, 5]));
      expect(luSolver.precision, equals(1.0e-10));
      expect(luSolver.size, equals(3));
      expect(luSolver.hasSolution(), isTrue);
    });

    test('Making sure that the string conversion works properly.', () {
      final solver = LUSolver(
        matrix: RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [7, -2, 1],
            [14, -7, -3],
            [-7, 11, 18],
          ],
        ),
        knownValues: const [12, 17, 5],
      );

      const toString =
          '[7.0, -2.0, 1.0]\n'
          '[14.0, -7.0, -3.0]\n'
          '[-7.0, 11.0, 18.0]';
      const toStringAugmented =
          '[7.0, -2.0, 1.0 | 12.0]\n'
          '[14.0, -7.0, -3.0 | 17.0]\n'
          '[-7.0, 11.0, 18.0 | 5.0]';

      expect(solver.toString(), equals(toString));
      expect(solver.toStringAugmented(), equals(toStringAugmented));
    });

    test('Making sure that objects comparison works properly.', () {
      final lu = LUSolver(
        matrix: RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [1, 2],
            [3, 4],
          ],
        ),
        knownValues: [0, -6],
      );

      final lu2 = LUSolver(
        matrix: RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [1, 2],
            [3, 4],
          ],
        ),
        knownValues: [0, -6],
      );

      expect(lu, equals(lu2));
      expect(lu == lu2, isTrue);
      expect(lu2, equals(lu));
      expect(lu2 == lu, isTrue);
      expect(lu.hashCode, equals(lu2.hashCode));
    });

    test('Making sure that the matrix is squared because this method is only '
        "able to solve systems of 'N' equations in 'N' variables.", () {
      expect(
        () => LUSolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 3,
            data: const [
              [1, 2, 0],
              [3, 4, -6],
            ],
          ),
          knownValues: const [12, 17],
        ),
        throwsA(isA<SystemSolverException>()),
      );
    });

    test('Making sure that the matrix is squared AND the dimension of the '
        'known values vector also matches the size of the matrix.', () {
      expect(
        () => LUSolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [1, 2],
              [3, 4],
            ],
          ),
          knownValues: const [12, 17, 5],
        ),
        throwsA(isA<SystemSolverException>()),
      );
    });

    test('Batch tests', () {
      final systems = [
        LUSolver(
          matrix: RealMatrix.fromData(
            rows: 3,
            columns: 3,
            data: const [
              [25, 15, -5],
              [15, 18, 0],
              [-5, 0, 11],
            ],
          ),
          knownValues: [35, 33, 6],
        ).solve(),
        LUSolver(
          matrix: RealMatrix.fromData(
            rows: 3,
            columns: 3,
            data: const [
              [1, 0, 1],
              [0, 2, 0],
              [1, 0, 3],
            ],
          ),
          knownValues: [6, 5, -2],
        ).solve(),
        LUSolver(
          matrix: RealMatrix.fromData(
            rows: 3,
            columns: 3,
            data: const [
              [1, 0, 0],
              [0, 1, 0],
              [0, 0, 1],
            ],
          ),
          knownValues: [5, -2, 3],
        ).solve(),
      ];

      const solutions = <List<double>>[
        [1, 1, 1],
        [10, 2.5, -4],
        [5, -2, 3],
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

    test('Making sure that singular matrices throw an exception.', () {
      final luSolver = LUSolver(
        matrix: RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [-1, -1],
            [1, 1],
          ],
        ),
        knownValues: [-1 / 2, 2],
      );

      // The matrix has determinant = 0, so it should throw an exception
      expect(luSolver.determinant(), equals(0));
      expect(luSolver.solve, throwsA(isA<SystemSolverException>()));
    });
  });
}
