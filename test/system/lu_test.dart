import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the 'LUSolver' class.", () {
    test(
      'Making sure that the LUSolver computes the correct results of a '
      'system of linear equations.',
      () {
        final luSolver = LUSolver(
          equations: const [
            [7, -2, 1],
            [14, -7, -3],
            [-7, 11, 18],
          ],
          constants: const [12, 17, 5],
        );

        // This is needed because we want to make sure that the "original" matrix
        // doesn't get side effects from the calculations (i.e. row swapping).
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
        expect(results, unorderedEquals(<double>[-1, 4, 3]));

        // Checking the "state" of the object
        expect(luSolver.equations, equals(matrix));
        expect(luSolver.knownValues, orderedEquals(<double>[12, 17, 5]));
        expect(luSolver.precision, equals(1.0e-10));
        expect(luSolver.size, equals(3));
        expect(luSolver.hasSolution(), isTrue);
      },
    );

    test(
      'Making sure that flat constructor produces the same object that '
      'a non-flattened constructor does',
      () {
        final matrix = LUSolver(
          equations: const [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9],
          ],
          constants: const [1, 2, 3],
        );

        final flatMatrix = LUSolver.flatMatrix(
          equations: const [1, 2, 3, 4, 5, 6, 7, 8, 9],
          constants: const [1, 2, 3],
        );

        expect(matrix, equals(flatMatrix));
      },
    );

    test('Making sure that the string conversion works properly.', () {
      final solver = LUSolver(
        equations: const [
          [7, -2, 1],
          [14, -7, -3],
          [-7, 11, 18],
        ],
        constants: const [12, 17, 5],
      );

      const toString = '[7.0, -2.0, 1.0]\n'
          '[14.0, -7.0, -3.0]\n'
          '[-7.0, 11.0, 18.0]';
      const toStringAugmented = '[7.0, -2.0, 1.0 | 12.0]\n'
          '[14.0, -7.0, -3.0 | 17.0]\n'
          '[-7.0, 11.0, 18.0 | 5.0]';

      expect(solver.toString(), equals(toString));
      expect(solver.toStringAugmented(), equals(toStringAugmented));
    });

    test(
      'Making sure that the matrix is squared because this method is only '
      "able to solve systems of 'N' equations in 'N' variables.",
      () {
        expect(
          () => LUSolver(
            equations: const [
              [7, -2, 1],
              [14, -7, -3],
            ],
            constants: const [12, 17],
          ),
          throwsA(isA<MatrixException>()),
        );
      },
    );

    test(
      'Making sure that when the input is a flat matrix, the matrix must '
      'be squared.',
      () {
        expect(
          () => LUSolver.flatMatrix(
            equations: const [1, 2, 3, 4, 5],
            constants: [7, 8],
          ),
          throwsA(isA<MatrixException>()),
        );
      },
    );

    test(
      'Making sure that the matrix is squared AND the dimension of the '
      'known values vector also matches the size of the matrix.',
      () {
        expect(
          () => LUSolver(
            equations: const [
              [7, -2],
              [14, -7],
            ],
            constants: const [12, 17, 5],
          ),
          throwsA(isA<MatrixException>()),
        );
      },
    );
  });
}
