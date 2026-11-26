import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group('RegulaFalsi', () {
    test('Smoke test', () {
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
        const MoreOrLessEquals(2.24, precision: 1.0e-2),
      );
      expect(
        solutions.efficiency,
        const MoreOrLessEquals(1.17, precision: 1.0e-2),
      );

      expect(
        solutions.guesses.last,
        const MoreOrLessEquals(1.5, precision: 1.0e-1),
      );
    });

    test('Malformed equation string', () {
      expect(
        const RegulaFalsi(function: '3x^2 + 5x - 1', a: 1, b: 8).solve,
        throwsA(isA<ExpressionParserException>()),
      );
    });

    test('Object comparison', () {
      const regula = RegulaFalsi(
        function: 'x-2',
        a: 1,
        b: 2,
      );

      expect(const RegulaFalsi(function: 'x-2', a: 1, b: 2), equals(regula));
      expect(const RegulaFalsi(function: 'x-2', a: 0, b: 2) == regula, isFalse);
      expect(regula, equals(const RegulaFalsi(function: 'x-2', a: 1, b: 2)));
      expect(const RegulaFalsi(function: 'x-2', a: 0, b: 2) == regula, isFalse);
      expect(const RegulaFalsi(function: 'x-2', a: 1, b: 1) == regula, isFalse);
      expect(
        const RegulaFalsi(function: 'x-2', a: 1, b: 2).hashCode,
        equals(regula.hashCode),
      );
    });

    test('Root not bracketed', () {
      const regula = RegulaFalsi(function: 'x - 2', a: 50, b: 70);
      expect(regula.solve, throwsA(isA<NonlinearException>()));

      try {
        regula.solve();
      } on NonlinearException catch (e) {
        expect(
          e.message,
          equals(
            'The root is not bracketed in [50.0, 70.0]. f(a) and f(b) must '
            'have opposite signs.',
          ),
        );
      }
    });

    test('Early return when evalA is 0', () {
      const regula = RegulaFalsi(function: 'x^2-1', a: -1, b: 0);
      final solutions = regula.solve();
      expect(solutions.guesses.length, equals(1));
      expect(solutions.guesses.first, equals(-1));
    });

    test('Early return when evalB is 0', () {
      const regula = RegulaFalsi(function: 'x^2-1', a: 0, b: 1);
      final solutions = regula.solve();
      expect(solutions.guesses.length, equals(1));
      expect(solutions.guesses.first, equals(1));
    });

    test('Throws when denominator is invalid', () {
      const regula = RegulaFalsi(function: '1/(x-1)', a: 0, b: 2);
      expect(regula.solve, throwsA(isA<NonlinearException>()));

      try {
        regula.solve();
      } on NonlinearException catch (e) {
        expect(
          e.message,
          equals("Couldn't evaluate f(1.0). The function value is infinite."),
        );
      }
    });

    test('Throws when function value is NaN or infinite', () {
      const regula = RegulaFalsi(function: '1/(x-0.5)', a: 0, b: 1);
      expect(regula.solve, throwsA(isA<NonlinearException>()));

      try {
        regula.solve();
      } on NonlinearException catch (e) {
        expect(
          e.message,
          equals("Couldn't evaluate f(0.5). The function value is infinite."),
        );
      }
    });

    test('Does not stall when one endpoint is kept (Illinois variant)', () {
      // The plain regula falsi method is still at f(x) = -0.03 after 30 steps
      final solutions = const RegulaFalsi(
        function: 'x^10-1',
        a: 0,
        b: 1.3,
      ).solve();

      expect(solutions.guesses.length, lessThan(20));
      expect(
        solutions.guesses.last,
        const MoreOrLessEquals(1, precision: 1.0e-10),
      );
    });

    group('Roots tests', () {
      void verifySolution(
        String equation,
        double a,
        double b,
        double expectedSolution,
      ) {
        final solutions = RegulaFalsi(function: equation, a: a, b: b).solve();

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

      test('Test 9', () {
        verifySolution('cos(x)-x', 0, 1, 0.739085);
      });

      test('Test 10', () {
        verifySolution('log(x)-1', 1, 4, 2.718282);
      });

      test('Test 11', () {
        verifySolution('x^3-2*x-5', 2, 3, 2.094551);
      });

      test('Test 12', () {
        verifySolution('e^(-x)-x', 0, 1, 0.567143);
      });

      test('Test 13', () {
        verifySolution('x^3+x+1', -1, 0, -0.682328);
      });

      test('Test 14', () {
        verifySolution('x^2-1000000', 600, 1500, 1000);
      });

      test('Test 15', () {
        verifySolution('(x-1)^3', 0, 2.5, 1);
      });

      test('Test 16', () {
        verifySolution('sin(x)', 3, 4, 3.141593);
      });

      test('Test 17', () {
        verifySolution('x^5-x-1', 1, 2, 1.167304);
      });

      test('Test 18', () {
        verifySolution('atan(x)', -1, 2, 0);
      });

      test('Test 19', () {
        verifySolution('1/x-2', 0.2, 1, 0.5);
      });
    });
  });
}
