import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group('Riddler', () {
    test('Smoke test', () {
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
    });

    test('Malformed equation string', () {
      expect(
        const Riddler(function: '5x^2-2', a: 0, b: 2).solve,
        throwsA(isA<ExpressionParserException>()),
      );
    });

    test('Object comparison', () {
      const riddler = Riddler(
        function: 'x-2',
        a: 1,
        b: 2,
      );

      expect(const Riddler(function: 'x-2', a: 1, b: 2), equals(riddler));
      expect(const Riddler(function: 'x-2', a: 0, b: 2) == riddler, isFalse);
      expect(riddler, equals(const Riddler(function: 'x-2', a: 1, b: 2)));
      expect(const Riddler(function: 'x-2', a: 0, b: 2) == riddler, isFalse);
      expect(const Riddler(function: 'x-2', a: 1, b: 1) == riddler, isFalse);
      expect(
        const Riddler(function: 'x-2', a: 1, b: 2).hashCode,
        equals(riddler.hashCode),
      );
    });

    test('Making sure that the method throws if the root is not bracketed', () {
      const riddler = Riddler(function: 'x^2-2', a: 100, b: 200);
      expect(riddler.solve, throwsA(isA<NonlinearException>()));

      try {
        riddler.solve();
      } on NonlinearException catch (e) {
        expect(
          e.message,
          equals(
            'The root is not bracketed in [100.0, 200.0]. f(a) and f(b) '
            'must have opposite signs.',
          ),
        );
      }
    });

    test('Throws when function value at midpoint is NaN or infinite', () {
      const riddler2 = Riddler(function: '1/(x-0.5)', a: 0, b: 1);
      expect(riddler2.solve, throwsA(isA<NonlinearException>()));

      try {
        riddler2.solve();
      } on NonlinearException catch (e) {
        expect(
          e.message,
          contains("Couldn't evaluate f("),
        );
        expect(
          e.message,
          anyOf(
            contains('NaN'),
            contains('infinite'),
          ),
        );
      }
    });

    test('Throws when function value at computed point is NaN or infinite', () {
      const riddler2 = Riddler(function: '1/(x-1)', a: 0, b: 2);
      expect(riddler2.solve, throwsA(isA<NonlinearException>()));

      try {
        riddler2.solve();
      } on NonlinearException catch (e) {
        expect(
          e.message,
          contains("Couldn't evaluate f("),
        );
        expect(
          e.message,
          anyOf(
            contains('NaN'),
            contains('infinite'),
          ),
        );
      }
    });

    test('Tests the else if branch for y0.sign != y.sign', () {
      const riddler = Riddler(function: 'x^3 - 3*x', a: -2, b: 2);
      final solutions = riddler.solve();
      expect(solutions.guesses.length, isNonZero);
    });

    group('Roots tests', () {
      void verifySolution(
        String equation,
        double a,
        double b,
        double expectedSolution,
      ) {
        final solutions = Riddler(function: equation, a: a, b: b).solve();
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
