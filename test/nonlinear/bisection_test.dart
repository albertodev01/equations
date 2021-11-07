import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing the 'Bisection' class", () {
    test(
      'Making sure that the series converges when the root is in the interval.',
      () {
        const bisection =
            Bisection(function: 'x^3-x-2', a: 1, b: 2, maxSteps: 5);

        expect(bisection.maxSteps, equals(5));
        expect(bisection.tolerance, equals(1.0e-10));
        expect(bisection.function, equals('x^3-x-2'));
        expect(bisection.toString(), equals('f(x) = x^3-x-2'));
        expect(bisection.a, equals(1));
        expect(bisection.b, equals(2));

        // Solving the equation, making sure that the series converged
        final solutions = bisection.solve();
        expect(solutions.guesses.length <= 5, isTrue);
        expect(solutions.guesses.length, isNonZero);
        expect(solutions.convergence, const MoreOrLessEquals(1, precision: 1));
        expect(solutions.efficiency, const MoreOrLessEquals(1, precision: 1));

        expect(
          solutions.guesses.last,
          const MoreOrLessEquals(1.5, precision: 1.0e-1),
        );
      },
    );

    test('Making sure that a malformed equation string throws.', () {
      expect(
        () {
          const Bisection(function: '2x - 6', a: 1, b: 8).solve();
        },
        throwsA(isA<ExpressionParserException>()),
      );
    });

    test('Making sure that object comparison properly works', () {
      const bisection = Bisection(
        function: 'x-2',
        a: 1,
        b: 2,
      );

      expect(
        const Bisection(function: 'x-2', a: 1, b: 2),
        equals(bisection),
      );
      expect(
        bisection,
        equals(const Bisection(function: 'x-2', a: 1, b: 2)),
      );
      expect(
        const Bisection(function: 'x-2', a: 0, b: 2) == bisection,
        isFalse,
      );
      expect(
        const Bisection(function: 'x-2', a: 1, b: 2).hashCode,
        equals(bisection.hashCode),
      );
    });

    test(
      'Making sure that the bisection method still works when the root '
      'is not in the interval but the actual solution is not found',
      () {
        const bisection = Bisection(
          function: 'x^2 - 9',
          a: -120,
          b: -122,
          maxSteps: 5,
        );
        final solutions = bisection.solve();

        expect(solutions.guesses.length, isNonZero);
        expect(solutions.guesses.length <= 5, isTrue);
      },
    );

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
        5.0,
        3.605,
        -1.0,
      ];

      for (var i = 0; i < equations.length; ++i) {
        for (var j = 0; j < equations[i].length; ++j) {
          final solutions = Bisection(
            function: equations[i],
            a: initialGuesses[i].first,
            b: initialGuesses[i][1],
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
