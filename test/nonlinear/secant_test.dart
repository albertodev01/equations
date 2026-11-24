import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group('Secant', () {
    test('Smoke test', () {
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
        const MoreOrLessEquals(1.06, precision: 1.0e-2),
      );

      expect(
        solutions.guesses.last,
        const MoreOrLessEquals(1.5, precision: 1.0e-1),
      );
    });

    test('Malformed equation string', () {
      expect(
        const Secant(function: 'xsin(x)', a: 0, b: 2).solve,
        throwsA(isA<ExpressionParserException>()),
      );
    });

    test('Object comparison', () {
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
        secant,
        equals(const Secant(function: 'x-2', a: -1, b: 2)),
      );
      expect(
        const Secant(function: 'x-2', a: -1, b: 2) == secant,
        isTrue,
      );
      expect(
        secant == const Secant(function: 'x-2', a: -1, b: 2),
        isTrue,
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

    test('Derivatives can be evaluated on 0', () {
      const secant = Secant(function: 'x', a: 0, b: 0);

      expect(
        secant.evaluateDerivativeOn(0),
        const MoreOrLessEquals(1, precision: 1.0e-8),
      );
      expect(secant.solve, throwsA(isA<NonlinearException>()));
    });

    test('Throws initial guesses are equal', () {
      const secant = Secant(function: 'x^2 - 9', a: 1, b: 1);
      expect(secant.solve, throwsA(isA<NonlinearException>()));

      try {
        secant.solve();
      } on NonlinearException catch (e) {
        expect(
          e.message,
          equals(
            'The two initial guesses must be different. Both a and b '
            'are equal to 1.0.',
          ),
        );
      }
    });

    test('Early return when fPrev is 0', () {
      const secant = Secant(function: 'x', a: 0, b: 1);
      final solutions = secant.solve();
      expect(solutions.guesses.length, equals(1));
      expect(solutions.guesses.first, equals(0));
    });

    test('Early return when fCurr is 0', () {
      const secant = Secant(function: 'x', a: -1, b: 0);
      final solutions = secant.solve();
      expect(solutions.guesses.length, equals(1));
      expect(solutions.guesses.first, equals(0));
    });

    test('Throws when denominator is invalid', () {
      const secant = Secant(function: 'x^2', a: 1, b: -1);
      expect(secant.solve, throwsA(isA<NonlinearException>()));

      try {
        secant.solve();
      } on NonlinearException catch (e) {
        expect(
          e.message,
          contains('Invalid denominator encountered'),
        );
        expect(
          e.message,
          contains('The denominator f('),
        );
      }
    });

    group('Roots tests', () {
      void verifySolution(
        String equation,
        double a,
        double b,
        double expectedSolution,
      ) {
        final solutions = Secant(function: equation, a: a, b: b).solve();
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
