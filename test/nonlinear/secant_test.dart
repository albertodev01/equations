import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing the 'Secant' class", () {
    test(
      'Making sure that the series converges when the root is in the interval.',
      () {
        const secant = Secant(
          function: 'x^3-x-2',
          a: 1,
          b: 2,
          maxSteps: 10,
        );

        expect(secant.maxSteps, equals(10));
        expect(secant.tolerance, equals(1.0e-10));
        expect(secant.function, equals('x^3-x-2'));
        expect(secant.toString(), equals('f(x) = x^3-x-2'));
        expect(secant.a, equals(1));
        expect(secant.b, equals(2));

        // Solving the equation, making sure that the series converged
        final solutions = secant.solve();
        expect(solutions.guesses.length <= 10, isTrue);
        expect(solutions.guesses.length, isNonZero);
        expect(
          solutions.convergence,
          const MoreOrLessEquals(1.61, precision: 1.0e-2),
        );
        expect(
          solutions.efficiency,
          const MoreOrLessEquals(1.04, precision: 1.0e-2),
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
          const Secant(
            function: 'xsin(x)',
            a: 0,
            b: 2,
          ).solve();
        },
        throwsA(isA<ExpressionParserException>()),
      );
    });

    test('Making sure that object comparison properly works', () {
      const secant = Secant(
        function: 'x-2',
        a: -1,
        b: 2,
      );

      expect(
        const Secant(function: 'x-2', a: -1, b: 2),
        equals(secant),
      );
      expect(
        const Secant(function: 'x-2', a: 0, b: 2) == secant,
        isFalse,
      );
      expect(
        const Secant(function: 'x-2', a: -1, b: 0) == secant,
        isFalse,
      );
      expect(
        const Secant(function: 'x-2', a: -1, b: 2).hashCode,
        equals(secant.hashCode),
      );
    });

    test('Making sure that derivatives evaluated on 0 return NaN.', () {
      const secant = Secant(function: 'x', a: 0, b: 0);

      // The derivative on 0 is 'NaN'
      expect(secant.evaluateDerivativeOn(0).isNaN, isTrue);

      // Making sure that the method actually throws
      expect(secant.solve, throwsA(isA<Exception>()));
    });

    test(
      'Making sure that the secant method still works when the root is '
      'not in the interval but the actual solution is not found',
      () {
        const secant = Secant(
          function: 'x^2-8',
          a: -180,
          b: -190,
          maxSteps: 4,
        );
        final solutions = secant.solve();

        expect(solutions.guesses.length, isNonZero);
        expect(solutions.guesses.length <= 4, isTrue);
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
          final solutions = Secant(
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
