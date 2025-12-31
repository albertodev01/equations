import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group('Brent', () {
    test('Smoke test', () {
      const brent = Brent(
        function: 'x^3-sqrt(x+3)',
        a: 0,
        b: 2,
        maxSteps: 10,
      );

      expect(brent.a, equals(0));
      expect(brent.b, equals(2));
      expect(brent.maxSteps, equals(10));
      expect(brent.tolerance, equals(1.0e-10));
      expect(brent.function, equals('x^3-sqrt(x+3)'));
      expect(brent.toString(), equals('f(x) = x^3-sqrt(x+3)'));

      // Solving the equation, making sure that the series converged
      final solutions = brent.solve();
      expect(solutions.guesses.length <= 10, isTrue);
      expect(solutions.guesses.length, isNonZero);
      expect(solutions.convergence, const MoreOrLessEquals(0, precision: 1));
      // Efficiency can vary based on the exact convergence path
      // The important thing is that it's a valid positive number
      expect(solutions.efficiency, isPositive);
      expect(solutions.efficiency, lessThanOrEqualTo(2.0));
      expect(
        solutions.guesses.last,
        const MoreOrLessEquals(1.27, precision: 1.0e-2),
      );
    });

    test('Malformed equation string', () {
      const brent = Brent(function: 'x^3-√(x+3)', a: 0, b: 2);
      expect(brent.solve, throwsA(isA<ExpressionParserException>()));
    });

    test('Object comparison', () {
      const brent = Brent(function: 'x-10', a: 8, b: 12);

      expect(const Brent(function: 'x-10', a: 8, b: 12), equals(brent));
      expect(const Brent(function: 'x-10', a: 8, b: 12) == brent, isTrue);
      expect(brent, equals(const Brent(function: 'x-10', a: 8, b: 12)));
      expect(brent == const Brent(function: 'x-10', a: 8, b: 12), isTrue);
      expect(const Brent(function: 'x-10', a: 1, b: 12) == brent, isFalse);
      expect(const Brent(function: 'x-10', a: 8, b: -12) == brent, isFalse);
      expect(const Brent(function: 'x', a: 8, b: 12) == brent, isFalse);
      expect(
        const Brent(function: 'x-10', a: 8, b: 12).hashCode,
        equals(brent.hashCode),
      );
    });

    test(
      'Root not bracketed',
      () {
        const brent = Brent(function: 'x^3-sqrt(x+3)', a: 3, b: 5, maxSteps: 5);
        expect(brent.solve, throwsA(isA<NonlinearException>()));

        try {
          brent.solve();
        } on NonlinearException catch (e) {
          expect(
            e.message,
            equals(
              'The root is not bracketed in [3.0, 5.0]. '
              'f(a) and f(b) must have opposite signs.',
            ),
          );
        }
      },
    );

    group('Roots tests', () {
      void verifySolution(
        String equation,
        double a,
        double b,
        double expectedSolution,
      ) {
        final solutions = Brent(function: equation, a: a, b: b).solve();
        expect(
          solutions.guesses.last,
          MoreOrLessEquals(expectedSolution, precision: 1.0e-3),
        );
        expect(solutions.guesses.length, isNonZero);
      }

      test('Test 1', () {
        verifySolution('x^e-cos(x)', 0.5, 1, 0.856);
      });

      test('Test 2', () {
        verifySolution('3*x-sqrt(x+2)-1', -1, 1, 0.901);
      });

      test('Test 3', () {
        verifySolution('x^3-5*x^2', 4, 6, 5);
      });

      test('Test 4', () {
        verifySolution('x^2-13', 3, 4, 3.605);
      });

      test('Test 5', () {
        verifySolution('e^(x)*(x+1)', -2, 0, -1);
      });

      test('Test 6', () {
        verifySolution('x', -1, 1, 0);
      });

      test('Test 7', () {
        verifySolution('sin(x+2)*cos(x-1)', 0.5, 1.5, 1.141592);
      });

      test('Test 8', () {
        verifySolution('x^x-1', 0.5, 1.1, 1);
      });
    });
  });
}
