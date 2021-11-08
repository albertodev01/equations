import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing the 'RegulaFalsi' class", () {
    test(
      'Making sure that the series converges when the root is in the interval.',
      () {
        const regula = RegulaFalsi(
          function: 'x^3-x-2',
          a: 1,
          b: 2,
          maxSteps: 5,
          tolerance: 1.0e-15,
        );

        expect(regula.maxSteps, equals(5));
        expect(regula.tolerance, equals(1.0e-15));
        expect(regula.function, equals('x^3-x-2'));
        expect(regula.toString(), equals('f(x) = x^3-x-2'));
        expect(regula.a, equals(1));
        expect(regula.b, equals(2));

        // Solving the equation, making sure that the series converged
        final solutions = regula.solve();
        expect(solutions.guesses.length <= 5, isTrue);
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
          const RegulaFalsi(function: '3x^2 + 5x - 1', a: 1, b: 8).solve();
        },
        throwsA(isA<ExpressionParserException>()),
      );
    });

    test('Making sure that object comparison properly works', () {
      const regula = RegulaFalsi(
        function: 'x-2',
        a: 1,
        b: 2,
      );

      expect(const RegulaFalsi(function: 'x-2', a: 1, b: 2), equals(regula));
      expect(const RegulaFalsi(function: 'x-2', a: 0, b: 2) == regula, isFalse);
      expect(regula, equals(const RegulaFalsi(function: 'x-2', a: 1, b: 2)));
      expect(const RegulaFalsi(function: 'x-2', a: 0, b: 2) == regula, isFalse);
      expect(
        const RegulaFalsi(function: 'x-2', a: 1, b: 2).hashCode,
        equals(regula.hashCode),
      );
    });

    test('Making sure that the method throws if the root is not bracketed', () {
      const regula = RegulaFalsi(function: 'x - 2', a: 50, b: 70);
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
        5.0,
        3.605,
        -1.0,
      ];

      for (var i = 0; i < equations.length; ++i) {
        for (var j = 0; j < equations[i].length; ++j) {
          final solutions = RegulaFalsi(
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
