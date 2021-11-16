import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing the 'Steffensen' class", () {
    test(
      'Making sure that the series converges when the root is in the interval.',
      () {
        const steffensen = Steffensen(
          function: 'e^x-3',
          x0: 1,
          maxSteps: 5,
        );

        expect(steffensen.maxSteps, equals(5));
        expect(steffensen.tolerance, equals(1.0e-10));
        expect(steffensen.function, equals('e^x-3'));
        expect(steffensen.toString(), equals('f(x) = e^x-3'));
        expect(steffensen.x0, equals(1));

        // Solving the equation, making sure that the series converged
        final solutions = steffensen.solve();
        expect(solutions.guesses.length <= 5, isTrue);
        expect(solutions.guesses.length, isNonZero);
        expect(
          solutions.convergence,
          const MoreOrLessEquals(2, precision: 1.0e-1),
        );
        expect(
          solutions.efficiency,
          const MoreOrLessEquals(1.15, precision: 1.0e-2),
        );

        expect(
          solutions.guesses.last,
          const MoreOrLessEquals(1.098, precision: 1.0e-3),
        );
      },
    );

    test('Making sure that a malformed equation string throws.', () {
      expect(
        () {
          const steffensen = Steffensen(function: '', x0: 1);
          steffensen.solve();
        },
        throwsA(isA<ExpressionParserException>()),
      );
    });

    test('Making sure that object comparison properly works', () {
      const steffensen = Steffensen(function: 'e^x-3', x0: 3);

      expect(
        const Steffensen(function: 'e^x-3', x0: 3),
        equals(steffensen),
      );
      expect(
        steffensen,
        equals(const Steffensen(function: 'e^x-3', x0: 3)),
      );
      expect(
        const Steffensen(function: 'e^x-3', x0: 3) == steffensen,
        isTrue,
      );
      expect(
        steffensen == const Steffensen(function: 'e^x-3', x0: 3),
        isTrue,
      );
      expect(
        const Steffensen(function: 'e^x-3', x0: 1) == steffensen,
        isFalse,
      );
      expect(
        const Steffensen(function: 'e^x-3', x0: 3).hashCode,
        equals(steffensen.hashCode),
      );
    });

    test(
      'Making sure that the steffensen method still works when the root is '
      'not in the interval but the actual solution is not found',
      () {
        const steffensen = Steffensen(function: 'x-500', x0: 1, maxSteps: 3);
        final solutions = steffensen.solve();

        expect(solutions.guesses.length, isNonZero);
        expect(solutions.guesses.length <= 3, isTrue);
      },
    );

    test('Batch tests', () {
      final equations = [
        'x^e-cos(x)',
        '3*x-sqrt(x+2)-1',
        'x^3-5*x',
        'x^2-13',
      ];

      final initialGuesses = <double>[
        1,
        0.6,
        4,
        0,
      ];

      final expectedSolutions = <double>[
        0.856,
        0.901,
        2.236,
        -3.605,
      ];

      for (var i = 0; i < equations.length; ++i) {
        for (var j = 0; j < equations[i].length; ++j) {
          final solutions = Steffensen(
            function: equations[i],
            x0: initialGuesses[i],
            tolerance: 1.0e-16,
            maxSteps: 60,
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
