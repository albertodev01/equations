import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing the 'Riddler' class", () {
    test(
      'Making sure that the series converges when the root is in the interval.',
      () {
        const riddler = Riddler(
          function: 'x^3-x-2',
          a: 1,
          b: 2,
          maxSteps: 10,
          tolerance: 1.0e-15,
        );

        expect(riddler.maxSteps, equals(10));
        expect(riddler.tolerance, equals(1.0e-15));
        expect(riddler.function, equals('x^3-x-2'));
        expect(riddler.toString(), equals('f(x) = x^3-x-2'));
        expect(riddler.a, equals(1));
        expect(riddler.b, equals(2));

        // Solving the equation, making sure that the series converged
        final solutions = riddler.solve();
        expect(solutions.guesses.length <= 10, isTrue);
        expect(solutions.guesses.length, isNonZero);
        expect(
          solutions.convergence,
          const MoreOrLessEquals(1, precision: 1),
        );
        expect(
          solutions.efficiency,
          const MoreOrLessEquals(1, precision: 1),
        );

        expect(
          solutions.guesses.last,
          const MoreOrLessEquals(1.5, precision: 1.0e-1),
        );
      },
    );

    test('Making sure that a malformed equation string throws.', () {
      expect(
        () {
          const Riddler(
            function: '5x-2',
            a: 0,
            b: 2,
          ).solve();
        },
        throwsA(isA<ExpressionParserException>()),
      );
    });

    test('Making sure that object comparison properly works', () {
      const regula = Riddler(
        function: 'x-2',
        a: 1,
        b: 2,
      );

      expect(const Riddler(function: 'x-2', a: 1, b: 2), equals(regula));
      expect(const Riddler(function: 'x-2', a: 0, b: 2) == regula, isFalse);
      expect(regula, equals(const Riddler(function: 'x-2', a: 1, b: 2)));
      expect(const Riddler(function: 'x-2', a: 0, b: 2) == regula, isFalse);
      expect(
        const Riddler(function: 'x-2', a: 1, b: 2).hashCode,
        equals(regula.hashCode),
      );
    });

    test('Making sure that the method throws if the root is not bracketed', () {
      const regula = Riddler(function: 'x^2-2', a: 100, b: 200);
      expect(regula.solve, throwsA(isA<NonlinearException>()));
    });

    test('Batch tests', () {
      final equations = [
        'x^e-cos(x)',
        '3*x-sqrt(x+2)-1',
        'x^3-5*x^2',
        'x^2-13',
        'e^(x)*(x+1)',
      ];

      final initialGuesses = <List<double>>[
        [0.5, 1],
        [-1, 1],
        [4, 6],
        [3, 4],
        [-2, 0],
      ];

      final expectedSolutions = <double>[
        0.856,
        0.901,
        5,
        3.605,
        -1,
      ];

      for (var i = 0; i < equations.length; ++i) {
        for (var j = 0; j < equations[i].length; ++j) {
          final solutions = Riddler(
            function: equations[i],
            a: initialGuesses[i].first,
            b: initialGuesses[i][1],
            tolerance: 1.0e-15,
            maxSteps: 20,
          ).solve();

          expect(
            solutions.guesses.last,
            MoreOrLessEquals(expectedSolutions[i], precision: 1.0e-3),
          );
        }
      }
    });
  });
}
